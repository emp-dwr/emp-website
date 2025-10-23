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
    format_aquarius = function() {
      self$df_raw <- self$df_raw %>%
        rename(
          Value = `Result Value`,
          Analyte = `Observed Property ID`,
          DetectStatus = `Lab: Detection Condition`,
          ReportingLimit = `Lab: MRL`,
          Station = `Location ID`
        ) %>%
        mutate(Date = as.Date(`Observed DateTime`))

      self$df_raw <- self$df_raw %>%
        filter(!(Analyte %in% c("Sky Conditions", "Rain"))) %>% # remove character-type analytes
        filter(is.na(`QC: Type`)) %>% # remove replicates
        mutate(
          DetectStatus = case_when(
            DetectStatus == "NOT_DETECTED" ~ "Nondetect",
            TRUE ~ "Detect"
          ),
          Analyte = case_when(
            Analyte == "Specific Conductance" ~ "SpCndSurface",
            Analyte == "Turbidity" ~ "TurbiditySurface",
            Analyte == "Dissolved Ammonia" ~ "DissAmmonia",
            Analyte == "Dissolved Nitrate + Nitrite" ~ "DissNitrateNitrite",
            Analyte == "Total Phosphorus" ~ "TotPhos",
            Analyte == "Chlorophyll a" ~ "Chla",
            Analyte == "Pheophytin a" ~ "Pheoa",
            TRUE ~ Analyte
          )
        ) %>%
        mutate(Value = as.numeric(Value))

      return(invisible(self))
    },

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
    initialize = function(df_regionhex) {
      self$df_regionhex <- read_csv(here("admin/figures-tables/admin/region_table.csv"), show_col_types = FALSE)
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
                            spread_L = 60,
                            L_min = 45, # nudge up to avoid near-black
                            L_max = 80, # nudge down to avoid near-white
                            C_abs_min = 55, # absolute chroma floor
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

# determine water year
get_water_year <- function(given_year = report_year) {
  wy_text <- "https://cdec.water.ca.gov/reportapp/javareports?name=WSIHIST" %>%
    read_html() %>%
    html_element("pre") %>%
    html_text2()

  wy_int <- str_match(wy_text, paste0("(?<=", given_year, ")(.*?[a-zA-Z]+)(?=\\r)"))[[1]][1]
  wy_parts <- str_extract_all(wy_int, "[a-zA-Z]+")[[1]]

  sac_abb <- wy_parts[1]
  sj_abb <- wy_parts[2]

  sac_abb <- switch(sac_abb,
    "C" = "critically dry",
    "W" = "wet",
    "D" = "dry",
    "AN" = "above normal",
    "BN" = "below normal",
    "Unknown"
  )

  sj_abb <- switch(sj_abb,
    "C" = "critically dry",
    "W" = "wet",
    "D" = "dry",
    "AN" = "above normal",
    "BN" = "below normal",
    "Unknown"
  )


  wy_abb <- list(sac = sac_abb, sj = sj_abb)
  return(wy_abb)
}

# text string for water year
str_water_year <- function(given_year = report_year, period = c("cur", "prev")) {
  period <- match.arg(period)

  wy_abb <- get_water_year(given_year)

  if (period == "cur") {
    if (wy_abb$sac == wy_abb$sj) {
      result_string <- glue("which was classified as {wy_abb$sac} in the Sacramento and San Joaquin Valleys")
    } else {
      result_string <- glue("which was classified as {wy_abb$sac} in the Sacramento Valley and {wy_abb$sj} in the San Joaquin Valley")
    }
  }

  if (period == "prev") {
    if (wy_abb$sac == wy_abb$sj) {
      result_string <- glue("which was classified as {wy_abb$sac} in both valleys")
    } else {
      result_string <- glue("which was classified as {wy_abb$sac} in the Sacramento Valley and {wy_abb$sj} in the San Joaquin Valley")
    }
  }

  return(result_string)
}

# format numbers for display based on analyte
format_vals <- function(value, vari) {
  df_analytes <- read_csv(here("admin/figures-tables/admin/analyte_table.csv"),
    locale = locale(encoding = "UTF-8"),
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
    edi_url <- glue("https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier={pkg_id}&revision={revision}")
  }

  return(edi_url)
}

# Read in EDI file
get_edi_file <- function(pkg_id, fname) {
  # get latest revision
  revisions <- EDIutils::list_data_package_revisions(scope = "edi", identifier = pkg_id)
  latest_revision <- max(as.numeric(revisions))
  package_id_str <- glue::glue("{scope}.{pkg_id}.{latest_revision}")

  # get entity IDs
  entities <- EDIutils::list_data_entities(packageId = package_id_str)

  # slow wrapper (avoid rate limit)
  slow_read <- purrr::slowly(EDIutils::read_data_entity_name, purrr::rate_delay(pause = 1))

  # find the matching entity
  matched <- purrr::keep(entities, function(entity_id) {
    entity_name <- slow_read(packageId = package_id_str, entityId = entity_id)
    identical(entity_name, fname)
  })

  if (length(matched) == 0) {
    stop(glue::glue("File '{fname}' not found in package edi.{pkg_id}.{latest_revision}"))
  }

  # construct download URL and read csv
  entity_id <- matched[[1]]
  file_url <- glue::glue("https://pasta.lternet.edu/package/data/eml/{scope}/{pkg_id}/{latest_revision}/{entity_id}")
  df <- readr::read_csv(file_url, guess_max = 1000000, show_col_types = FALSE)

  return(df)
}


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

# render individual reports
render_report <- function(programs, report_type) {
  programs <- match.arg(programs, c("benthic", "cwq", "dwq", "phyto", "zoop"), several.ok = TRUE)
  report_type <- match.arg(report_type, c("pdf", "website"))

  for (prog in programs) {
    base_dir <- if (report_type == "pdf") {
      "qmd-files/pdfs"
    } else {
      file.path("qmd-files/website/", prog)
    }

    profile <- report_type
    file_path <- file.path(base_dir, paste0(prog, "-report.qmd"))

    if (!file.exists(file_path)) stop("File not found: ", file_path)

    message("Rendering ", prog, "-report.qmd...")
    quarto::quarto_render(input = file_path, profile = profile)
  }

  message("Done!")
}

render_reports <- function(..., report_type) {
  programs <- c(...)
  report_type <- match.arg(report_type, c("pdf", "website"))
  render_report(programs, report_type)
}


# Global Variables --------------------------------------------------------

# define default year (change manually if needed)
report_year <- as.integer(format(Sys.Date(), "%Y")) - 1

prev_year <- report_year - 1

label_order <- c(glue("Oct-{prev_year%%100}"), glue("Nov-{prev_year%%100}"), glue("Dec-{prev_year%%100}"), glue("Jan-{report_year%%100}"), glue("Feb-{report_year%%100}"), glue("Mar-{report_year%%100}"), glue("Apr-{report_year%%100}"), glue("May-{report_year%%100}"), glue("Jun-{report_year%%100}"), glue("Jul-{report_year%%100}"), glue("Aug-{report_year%%100}"), glue("Sep-{report_year%%100}"))

styler <- StylingClass$new()

# read in relevant dataframes
df_analytes <- read_quiet_csv(here("admin/figures-tables/admin/analyte_table.csv"), locale = locale(encoding = "UTF-8"))

df_regions <- read_quiet_csv(here("admin/figures-tables/admin/station_table.csv"))
