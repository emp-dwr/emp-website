# Create Base Data Frame -------------------------------------------------------

library(colorspace)

BaseClass <- R6Class(
  "BaseClass",
  private = list(
    df_units = NULL,
    df_regions = NULL
  ),
  public = list(
    df_raw = NULL,
    initialize = function(df_raw, df_units, df_regions) {
      # add in a detect column if none exists (for coding purposes)
      if (!any(c("DetectStatus", "Lab: Detection Condition") %in% colnames(df_raw))) {
        df_raw$DetectStatus <- "Detect"
      }
      self$df_raw <- df_raw
      
      private$df_units <- df_units
      private$df_regions <- df_regions
    },
    
    # remove EZ stations and blanks
    remove_EZ = function() {
      self$df_raw <- filter(self$df_raw, !(Station %in% c(
        "EZ2", "EZ6", "EZ2-SJR", "EZ6-SJR", "LSZ2", "LSZ6", "LSZ2-SJR", "LSZ6-SJR",
        "Equipment Blank"
      )))
      return(invisible(self))
    },
    
    # add units to dataframe
    assign_analyte_meta = function() {
      self$df_raw <- left_join(self$df_raw, private$df_units, by = "Analyte")
      return(invisible(self))
    },
    
    # simplify station names (benthic)
    simplify_stations = function() {
      self$df_raw$Station <- str_remove(self$df_raw$Station, "-.*")
      return(invisible(self))
    },
    
    # remove '_bottom' stations (cwq)
    remove_bottom = function() {
      self$df_raw <- filter(self$df_raw, !grepl("_bottom", Station))
      return(invisible(self))
    },
    
    # format Aquarius data (dwq)
    # format_aquarius = function() {
    #   self$df_raw <- self$df_raw %>%
    #     rename(
    #       Value = `Result Value`,
    #       Analyte = `Observed Property ID`,
    #       DetectStatus = `Lab: Detection Condition`,
    #       ReportingLimit = `Lab: MRL`,
    #       Station = `Location ID`
    #     ) %>%
    #     mutate(Date = as.Date(`Observed DateTime`))
    #   
    #   self$df_raw <- self$df_raw %>%
    #     filter(!(Analyte %in% c("Sky Conditions", "Rain"))) %>% # remove character-type analytes
    #     filter(is.na(`QC: Type`)) %>% # remove replicates
    #     mutate(
    #       DetectStatus = case_when(
    #         DetectStatus == "NOT_DETECTED" ~ "Nondetect",
    #         TRUE ~ "Detect"
    #       ),
    #       Analyte = case_when(
    #         Analyte == "Specific Conductance" ~ "SpCndSurface",
    #         Analyte == "Turbidity" ~ "TurbiditySurface",
    #         Analyte == "Dissolved Ammonia" ~ "DissAmmonia",
    #         Analyte == "Dissolved Nitrate + Nitrite" ~ "DissNitrateNitrite",
    #         Analyte == "Total Phosphorus" ~ "TotPhos",
    #         Analyte == "Chlorophyll a" ~ "Chla",
    #         Analyte == "Pheophytin a" ~ "Pheoa",
    #         TRUE ~ Analyte
    #       )
    #     ) %>%
    #     mutate(Value = as.numeric(Value))
    #   
    #   return(invisible(self))
    # },
    
    # add regions to dataframe
    assign_regions = function(program) {
      filt_regions <- private$df_regions %>%
        filter(grepl(program, Program))
      
      self$df_raw <- left_join(self$df_raw, filt_regions[c("Station", "Region")], by = "Station")
      return(invisible(self))
    },
    
    # filter by water year
    filter_years = function(given_year, range = c("single", "all")) {
      range <- match.arg(range)
      end_date <- as.Date(paste0(given_year, "-09-30"))
      
      if (range == "single") {
        start_date <- as.Date(paste0(given_year - 1, "-10-01"))
      } else if (range == "all") {
        oldest_year <- self$df_raw %>%
          filter(
            Year <= given_year - 1,
            Month == "October"
          ) %>%
          pull(Year) %>%
          min(na.rm = TRUE)
        
        start_date <- as.Date(paste0(oldest_year, "-10-01"))
      }
      
      self$df_raw <- self$df_raw %>%
        filter(Date >= start_date & Date <= end_date)
      
      return(invisible(self))
    },
    
    # add Month variable and refactor for water year definition
    add_month = function() {
      self$df_raw <- self$df_raw %>%
        mutate(
          Month = month(Date, label = TRUE, abbr = FALSE),
          Month = fct_shift(Month, -3L)
        )
      
      return(invisible(self))
    },
    
    # remove NA data (CWQ)
    remove_NAs = function() {
      self$df_raw <- self$df_raw %>%
        filter(!is.na(Value))
      
      return(invisible(self))
    },
    
    # populate `Value` column of Nondetect entries with `ReportLimit` value (for coding purposes)
    replace_nondetect = function() {
      self$df_raw <- mutate(self$df_raw, Value = if_else(DetectStatus == "Nondetect", ReportingLimit, Value))
      return(invisible(self))
    }
  )
)

# Style Various Elements --------------------------------------------------

StylingClass <- R6Class(
  "StylingClass",
  public = list(
    df_regionhex = NULL,
    station_colors = NULL,
    initialize = function() {
      self$df_regionhex <- read_csv(repo_path('admin', 'figures-tables', 'admin', 'region_colors.csv'), show_col_types = FALSE)
    },
    
    generate_station_colors = function(df_raw) {
      df_stn <- df_raw %>%
        distinct(Region, Station) %>%
        filter(!is.na(Region), !is.na(Station))
      
      region_hexes <- self$df_regionhex %>%
        select(Region, HexColor)
      
      df_stn <- df_stn %>%
        left_join(region_hexes, by = "Region") %>%
        group_by(Region) %>%
        arrange(Station, .by_group = TRUE)  # optional ordering
      
      region_station_colors <- df_stn %>%
        group_by(Region) %>%
        group_map(\(df, key) {
          if (nrow(df) == 0) return(tibble(Station = character(), Color = character()))
          n_stn <- nrow(df)
          center_hex <- df$HexColor[1]
          grad_cols <- self$gen_gradient(center_hex, num_colors = n_stn)
          tibble(Station = df$Station, Color = grad_cols)
        }) %>%
        bind_rows()
        
      self$station_colors <- setNames(
        region_station_colors$Color,
        region_station_colors$Station
      )
      
      invisible(self)
    },
    
    # TABLES
    # # style all tables
    
    style_kable = function(df) {
      # website
      if (is_html_output()) {
        table <- kable(df, align = "c", digits = 2, escape = FALSE) %>%
          kable_styling(c("striped", "scale_down"), font_size = 14, html_font = "Arimo", full_width = TRUE) %>%
          column_spec(1:ncol(df), width = paste0(100 / ncol(df), "%"))
        
        # pdf
      } else if (is_latex_output()) {
        num_columns <- ncol(df)
        table_width <- 35
        column_width <- paste0(table_width / num_columns, "em")
        
        table <- kable(df, align = "c", digits = 2, format = "latex", booktabs = TRUE, escape = FALSE) %>%
          kable_styling(latex_options = c("hold_position", "scale_down"), position = "center") %>%
          column_spec(1:ncol(df), width = column_width)
      }
      
      return(table)
    },
    
    # PLOTS
    # # Define custom theme for WQ plots
    wq_plt_theme = list(
      theme_bw(),
      theme(
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        axis.text = element_text(color = "black", size = 5, family = "sans"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.title = element_text(size = 7, hjust = 0.5),
        legend.position = "top",
        legend.title = element_blank(),
        legend.box.margin = margin(-10, -10, -10, -10),
        legend.text = element_text(size = 5),
        legend.key.size = unit(0.3, "lines")
        # panel.border = element_blank()
      )
    ),
    
    # # Format x-axis text labels and tick marks for WQ plots
    wq_plt_xaxis = function(x_lab) {
      if (x_lab == TRUE) {
        list(
          theme(
            axis.text.x = element_text(angle = 45, vjust = 0.5, margin = margin(t = 1))
          )
        )
      } else {
        list(
          theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())
        )
      }
    },
    
    gen_gradient = function(center_hex, num_colors,
                            spread_L = 40,
                            L_min = 37, # nudge up to avoid near-black
                            L_max = 85, # nudge down to avoid near-white
                            C_abs_min = 60, # absolute chroma floor
                            hue_wiggle = 15) {
      hcl <- as(hex2RGB(center_hex), "polarLUV")
      H0 <- hcl@coords[, "H"]
      C0 <- hcl@coords[, "C"]
      L0 <- hcl@coords[, "L"]
      
      # lightness sequence
      Lmin <- max(L_min, L0 - spread_L)
      Lmax <- min(L_max, L0 + spread_L)
      Lseq <- seq(Lmin, Lmax, length.out = num_colors)
      
      # hue sequence (small wobble)
      Hseq <- if (num_colors > 1 && hue_wiggle > 0) {
        ((seq(H0 - hue_wiggle, H0 + hue_wiggle, length.out = num_colors) %% 360) + 360) %% 360
      } else {
        rep(H0, num_colors)
      }
      
      # chroma: peak near mid L, but never below absolute floor; cap by gamut
      x <- (Lseq - mean(c(Lmin, Lmax))) / ((Lmax - Lmin) / 2) # -1..1
      C_peak <- max(C0, C_abs_min + 10) # ensure a decent mid saturation
      C_target <- (1 - pmin(1, abs(x) * 0.9)) * C_peak # “tent” peaking at mid L
      
      C_max <- pmax(0, max_chroma(h = Hseq, l = Lseq)) # displayable max chroma
      # Cseq <- rep(pmin(C0, C_max), length(Lseq)) # clamp colors
      Cseq <- pmin(pmax(C_target, C_abs_min), C_max) # clamp to [floor, gamut]
      
      # fix=TRUE keeps colors inside sRGB instead of silently clipping to grayish
      hex(polarLUV(Lseq, Cseq, Hseq), fix = TRUE)
    },
    
    # Create scale_color_manual layer based off region and palette
    wq_plt_colors = function(region, plt_type = c("dwq", "cwq")) {
      plt_type <- match.arg(plt_type)
      
      center_hex <- self$df_regionhex %>%
        filter(Region == region) %>%
        pull(HexColor)
      
      if (length(center_hex) == 0) {
        stop("Region not found in region_table")
      }
      
      num_colors <- self$df_raw %>%
        filter(Region == region) %>%
        pull(Station) %>%
        unique() %>%
        length()
      
      if (num_colors == 0) {
        stop("No stations found for the region in self$df_raw")
      }
      
      color_pal <- self$gen_gradient(center_hex, num_colors)
      
      return(list(scale_color_manual(values = color_pal)))
    },
    
    # # create list item for bullet lists
    list_item = function(ele) {
      # website
      if (is_html_output()) {
        item <- glue("&#x2022; {ele}<br />")
        
        # pdf
      } else if (is_latex_output()) {
        item <- glue("\\item {ele}")
        
        # other (eg. running on own)
      } else {
        item <- glue("&#x2022; {ele}<br />")
      }
      return(item)
    },
    
    # LISTS
    # # style bullet lists
    bullet_list = function(vec) {
      final_list <- c()
      
      for (i in 1:length(vec)) {
        new_ele <- self$list_item(vec[i])
        final_list <- c(final_list, new_ele)
      }
      
      # website
      if (is_html_output()) {
        final_list <- paste0(final_list, collapse = "")
        
        # pdf
      } else if (is_latex_output()) {
        final_list <- c("\\begin{itemize}", final_list, "\\end{itemize}")
        final_list <- paste0(final_list, collapse = "\n")
        
        # other (eg. running on own)
      } else {
        final_list <- paste0(final_list, collapse = "")
      }
      
      return(final_list)
    }
  )
)

# Global Functions --------------------------------------------------------

# read in csv without output
read_quiet_csv <- function(fp, ...) {
  df <- read_csv(fp, show_col_types = FALSE, ...)
  
  if ("Date" %in% colnames(df)) {
    df$Date <- as.Date(parse_date_time(df$Date, orders = c("ymd", "mdy", "dmy")))
  }
  
  return(df)
}

# base filepath to EMP SharePoint
abs_path_data <- function(fp_rel = NULL) {
  fp_emp <- "California Department of Water Resources/Environmental Monitoring Program - Documents/"
  
  if (is.null(fp_rel)) {
    fp_abs <- normalizePath(file.path(Sys.getenv("USERPROFILE"), fp_emp))
  } else {
    fp_abs <- normalizePath(file.path(Sys.getenv("USERPROFILE"), fp_emp, fp_rel))
  }
  
  return(fp_abs)
}

# format numbers for display based on analyte
format_vals <- function(value, vari) {
  df_analytes <- readr::read_csv(
    repo_path('admin', 'figures-tables', 'admin', 'analyte_table.csv'),
    locale = readr::locale(encoding = 'UTF-8'),
    show_col_types = FALSE
  )
  
  fracdigits <- df_analytes$FracDigits[df_analytes$Analyte == vari]
  sigfigs <- df_analytes$SigFigs[df_analytes$Analyte == vari]
  
  rounded_val <- signif(value, sigfigs)
  
  format_str <- sprintf("%%.%df", fracdigits)
  
  final_val <- sprintf(format_str, rounded_val)
  
  return(final_val)
}

# Get EDI URL
get_edi_url <- function(pkg_id, revision_num = "current") {
  if (revision_num == "current") {
    edi_url <- glue::glue("https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier={pkg_id}")
  } else {
    edi_url <- glue("https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier={pkg_id}&revision={revision_num}")
  }
  
  return(edi_url)
}


# get API key
# # must have API key saved as an environment variable if running locally (defaults "EDI_API_KEY")
# # also can save as repo secret if using GitHub Actions
edi_get <- function(url, key_name = "EDI_API_KEY") {
  request(url) %>%
    req_url_query(key = Sys.getenv(key_name)) %>%
    req_perform()
}

# get EDI file
# # match type: use "regex" if the name isn't consistent (eg. updates annually)
get_edi_file <- function(pkg_id, fname, scope = "edi", match_type = c("exact", "regex"),
                         col_types = NULL, key_name = "EDI_API_KEY") {
  match_type <- match.arg(match_type)
  base <- "https://pasta.lternet.edu/package"
  
  revisions <- edi_get(sprintf("%s/eml/%s/%s", base, scope, pkg_id), key_name) %>%
    resp_body_string()
  latest_revision <- max(as.numeric(strsplit(trimws(revisions), "\n")[[1]]))
  
  entities <- edi_get(sprintf("%s/data/eml/%s/%s/%s", base, scope, pkg_id, latest_revision), key_name) %>%
    resp_body_string()
  entities <- strsplit(trimws(entities), "\n")[[1]]
  
  # rate limit to be nicer to servers; technically optional
  get_name <- purrr::slowly(function(entity_id) {
    edi_get(sprintf("%s/name/eml/%s/%s/%s/%s", base, scope, pkg_id, latest_revision, entity_id), key_name) %>%
      resp_body_string() %>% trimws()
  }, purrr::rate_delay(pause = 0.3))
  
  is_match <- function(name) {
    if (match_type == "regex") grepl(fname, name) else identical(name, fname)
  }
  
  matched <- purrr::keep(entities, ~ is_match(get_name(.x)))
  if (length(matched) == 0) {
    stop(sprintf("No entity matching '%s' (%s) in %s.%s.%s",
                 fname, match_type, scope, pkg_id, latest_revision))
  }
  entity_id <- matched[[1]]
  
  raw <- edi_get(sprintf("%s/data/eml/%s/%s/%s/%s", base, scope, pkg_id, latest_revision, entity_id), key_name) %>%
    resp_body_raw()
  readr::read_csv(raw, show_col_types = FALSE, col_types = col_types, lazy = FALSE)
}


# Read in EDI file (old, can update when EDIutils allows API keys)
# get_edi_file <- function(pkg_id, fname, scope = 'edi') {
#   # get latest revision
#   revisions <- EDIutils::list_data_package_revisions(scope = "edi", identifier = pkg_id)
#   latest_revision <- max(as.numeric(revisions))
#   package_id_str <- glue::glue("{scope}.{pkg_id}.{latest_revision}")
#   
#   # get entity IDs
#   entities <- EDIutils::list_data_entities(packageId = package_id_str)
#   
#   # slow wrapper (avoid rate limit)
#   slow_read <- purrr::slowly(EDIutils::read_data_entity_name, purrr::rate_delay(pause = 1))
#   
#   # find the matching entity
#   matched <- purrr::keep(entities, function(entity_id) {
#     entity_name <- slow_read(packageId = package_id_str, entityId = entity_id)
#     identical(entity_name, fname)
#   })
#   
#   if (length(matched) == 0) {
#     stop(glue::glue("File '{fname}' not found in package edi.{pkg_id}.{latest_revision}"))
#   }
#   
#   # construct download URL and read csv
#   entity_id <- matched[[1]]
#   file_url <- glue::glue("https://pasta.lternet.edu/package/data/eml/{scope}/{pkg_id}/{latest_revision}/{entity_id}")
#   df <- readr::read_csv(file_url, guess_max = 1000000, show_col_types = FALSE)
#   
#   return(df)
# }

# generate figures
create_figs <- function(group = c("cwq", "dwq", "phyto", "benthic")) {
  if ("cwq" %in% group) {
    cat("generating CWQ graphs\n")
    create_figs_cwq()
  }
  if ("dwq" %in% group) {
    cat("generating DWQ graphs\n")
    create_figs_dwq()
  }
  if ("phyto" %in% group) {
    cat("generating phyto graphs\n")
    create_figs_phyto()
  }
  if ("benthic" %in% group) {
    cat("generating benthic graphs")
    create_figs_benthic()
  }
}

# Global Variables --------------------------------------------------------

styler <- StylingClass$new()
