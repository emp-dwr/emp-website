# Create Base Data Frame -------------------------------------------------------

BaseClass <- R6Class(
  'BaseClass',
  private = list(
    df_analytes = NULL,
    df_stations = NULL
  ),
  public = list(
    df_raw = NULL,
    initialize = function(df_raw, df_analytes, df_stations) {
      # add in a detect column if none exists (for coding purposes)
      if (!any(c('DetectStatus', 'Lab: Detection Condition') %in% colnames(df_raw))) {
        df_raw$DetectStatus <- 'Detect'
      }
      self$df_raw <- df_raw
      
      private$df_analytes <- df_analytes
      private$df_stations <- df_stations
    },
    
    # remove EZ stations and blanks
    remove_EZ = function() {
      self$df_raw <- filter(self$df_raw, !(Station %in% c(
        'EZ2', 'EZ6', 'EZ2-SJR', 'EZ6-SJR', 'LSZ2', 'LSZ6', 'LSZ2-SJR', 'LSZ6-SJR',
        'Equipment Blank'
      )))
      return(invisible(self))
    },
    
    # add units to dataframe (dwq/cwq)
    assign_analyte_meta = function() {
      self$df_raw <- left_join(self$df_raw, private$df_analytes, by = 'Analyte')
      return(invisible(self))
    },
    
    # simplify station names (benthic)
    simplify_stations = function() {
      self$df_raw$Station <- str_remove(self$df_raw$Station, '-.*')
      return(invisible(self))
    },
    
    # remove '_bottom' stations (cwq)
    remove_bottom = function() {
      self$df_raw <- filter(self$df_raw, !grepl('_bottom', Station))
      return(invisible(self))
    },
    
    # format DWQ EDI data (dwq)
    format_dwq = function() {
      analyte_map <- c(
        'Specific Conductance'        = 'SpCndSurface',
        'Turbidity'                   = 'TurbiditySurface',
        'Dissolved Ammonia'           = 'DissAmmonia',
        'Dissolved Nitrate + Nitrite' = 'DissNitrateNitrite',
        'Total Phosphorus'            = 'TotPhos',
        'Chlorophyll a'               = 'Chla',
        'Pheophytin a'                = 'Pheoa'
      )
      
      valid_detect <- c('Not detected', 'Detected')
      
      # check DetectStatus values
      bad_detect <- setdiff(unique(na.omit(self$df_raw$DetectStatus)), valid_detect)
      if (length(bad_detect)) {
        stop('Unexpected DetectStatus value(s): ',
             paste(bad_detect, collapse = ', '),
             '. Expected: ', paste(valid_detect, collapse = ', '), call. = FALSE)
      }
      
      # check that every mapped analyte is actually present
      missing_analytes <- setdiff(names(analyte_map), unique(self$df_raw$Analyte))
      if (length(missing_analytes)) {
        warning('Analyte(s) in the mapping but not in the data: ',
                paste(missing_analytes, collapse = ', '), call. = FALSE)
      }
      
      self$df_raw <- self$df_raw %>%
        filter(Analyte %in% names(analyte_map)) %>%   # keep only mapped analytes
        select(-Unit) %>%                             # get from df_analytes instead (for now)
        mutate(
          DetectStatus = if_else(DetectStatus == 'Not detected', 'Nondetect', 'Detect'),
          Analyte      = unname(analyte_map[Analyte]),
          Value        = as.numeric(Value)
        )
      
      return(invisible(self))
    },
    
    # add regions to dataframe
    assign_regions = function(section) {
      filt_regions <- private$df_stations %>%
        filter(grepl(section, Section))
      
      self$df_raw <- left_join(self$df_raw, filt_regions[c('Station', 'Region')], by = 'Station')
      return(invisible(self))
    },
    
    # filter by water year
    filter_years = function(given_year, range = c('single', 'all')) {
      range <- match.arg(range)
      end_date <- as.Date(paste0(given_year, '-09-30'))
      
      start_year <- if (range == 'single') given_year - 1 else given_year - 12
      start_date <- as.Date(paste0(start_year, '-10-01'))
      
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
      self$df_raw <- mutate(self$df_raw, Value = if_else(DetectStatus == 'Nondetect', ReportingLimit, Value))
      return(invisible(self))
    }
  )
)

# Style Various Elements --------------------------------------------------

StylingClass <- R6Class(
  'StylingClass',
  public = list(
    df_regionhex = NULL,
    station_colors = NULL,
    initialize = function() {
      self$df_regionhex <- read_csv(repo_path('admin', 'figures-tables', 'admin', 'region_metadata.csv'), show_col_types = FALSE)
    },
    
    generate_station_colors = function(df_raw) {
      df_stn <- df_raw %>%
        distinct(Region, Station) %>%
        filter(!is.na(Region), !is.na(Station))
      
      region_hexes <- self$df_regionhex %>%
        select(Region, HexColor)
      
      df_stn <- df_stn %>%
        left_join(region_hexes, by = 'Region') %>%
        group_by(Region) %>%
        arrange(Station, .by_group = TRUE)
      
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
        table <- kable(df, align = 'c', digits = 2, escape = FALSE) %>%
          kable_styling(c('striped', 'scale_down'), font_size = 14, html_font = 'Arimo', full_width = TRUE) %>%
          column_spec(1:ncol(df), width = paste0(100 / ncol(df), '%'))
        
        # pdf
      } else if (is_latex_output()) {
        num_columns <- ncol(df)
        table_width <- 35
        column_width <- paste0(table_width / num_columns, 'em')
        
        table <- kable(df, align = 'c', digits = 2, format = 'latex', booktabs = TRUE, escape = FALSE) %>%
          kable_styling(latex_options = c('HOLD_position'), position = 'center') %>%
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
        axis.text = element_text(color = 'black', size = 5, family = 'sans'),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.title = element_text(size = 7, hjust = 0.5),
        legend.position = 'top',
        legend.title = element_blank(),
        legend.box.margin = margin(-10, -10, -10, -10),
        legend.text = element_text(size = 5),
        legend.key.size = unit(0.3, 'lines')
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
      hcl <- as(hex2RGB(center_hex), 'polarLUV')
      H0 <- hcl@coords[, 'H']
      C0 <- hcl@coords[, 'C']
      L0 <- hcl@coords[, 'L']
      
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
    wq_plt_colors = function(region, plt_type = c('dwq', 'cwq')) {
      plt_type <- match.arg(plt_type)
      
      center_hex <- self$df_regionhex %>%
        filter(Region == region) %>%
        pull(HexColor)
      
      if (length(center_hex) == 0) {
        stop('Region not found in region_table')
      }
      
      num_colors <- self$df_raw %>%
        filter(Region == region) %>%
        pull(Station) %>%
        unique() %>%
        length()
      
      if (num_colors == 0) {
        stop('No stations found for the region in self$df_raw')
      }
      
      color_pal <- self$gen_gradient(center_hex, num_colors)
      
      return(list(scale_color_manual(values = color_pal)))
    },
    
    # # create list item for bullet lists
    list_item = function(ele) {
      # website
      if (is_html_output()) {
        item <- glue('&#x2022; {ele}<br />')
        
        # pdf
      } else if (is_latex_output()) {
        item <- glue('\\item {ele}')
        
        # other (eg. running on own)
      } else {
        item <- glue('&#x2022; {ele}<br />')
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
        final_list <- paste0(final_list, collapse = '')
        
        # pdf
      } else if (is_latex_output()) {
        final_list <- c('\\begin{itemize}', final_list, '\\end{itemize}')
        final_list <- paste0(final_list, collapse = '\n')
        
        # other (eg. running on own)
      } else {
        final_list <- paste0(final_list, collapse = '')
      }
      
      return(final_list)
    }
  )
)

# Global Functions --------------------------------------------------------

# read in csv without output
read_quiet_csv <- function(fp, ...) {
  df <- read_csv(fp, show_col_types = FALSE, ...)
  
  if ('Date' %in% colnames(df)) {
    df$Date <- as.Date(parse_date_time(df$Date, orders = c('ymd', 'mdy', 'dmy')))
  }
  
  return(df)
}

# base filepath to EMP SharePoint
abs_path_data <- function(fp_rel = NULL) {
  fp_emp <- 'California Department of Water Resources/Environmental Monitoring Program - Documents/'
  
  if (is.null(fp_rel)) {
    fp_abs <- normalizePath(file.path(Sys.getenv('USERPROFILE'), fp_emp))
  } else {
    fp_abs <- normalizePath(file.path(Sys.getenv('USERPROFILE'), fp_emp, fp_rel))
  }
  
  return(fp_abs)
}

# format numbers for display based on analyte
format_vals <- function(value, vari) {
  df_analytes <- readr::read_csv(
    repo_path('admin', 'figures-tables', 'admin', 'analyte_metadata.csv'),
    locale = readr::locale(encoding = 'UTF-8'),
    show_col_types = FALSE
  )
  
  fracdigits <- df_analytes$FracDigits[df_analytes$Analyte == vari]
  sigfigs <- df_analytes$SigFigs[df_analytes$Analyte == vari]
  
  rounded_val <- signif(value, sigfigs)
  
  format_str <- sprintf('%%.%df', fracdigits)
  
  final_val <- sprintf(format_str, rounded_val)
  
  return(final_val)
}

# generate figures
create_figs <- function(group = c('cwq', 'dwq', 'phyto', 'benthic')) {
  if ('cwq' %in% group) {
    cat('generating CWQ graphs\n')
    create_figs_cwq()
  }
  if ('dwq' %in% group) {
    cat('generating DWQ graphs\n')
    create_figs_dwq()
  }
  if ('phyto' %in% group) {
    cat('generating phyto graphs\n')
    create_figs_phyto()
  }
  if ('benthic' %in% group) {
    cat('generating benthic graphs')
    create_figs_benthic()
  }
}

# Global Variables --------------------------------------------------------

styler <- StylingClass$new()
