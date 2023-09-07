# statistics --------------------------------------------------------------
#' Statistics strings
#'
#' Computes various statistics and creates a string for use in reports
#'
#' @param df the relevant data frame
#' @param nutrient the nutrient column name (as string) to pull data from
#' @param stat the function to apply to the data. choices are: min, max, etc.
#' @param output the type of output string desired. choices are: min, max, etc.
#'
func_stats_report <- function(df, nutrient, stat, output, year = report_year){
  df_vari <- func_stats(df, nutrient, year, stat)
  vari <- func_output(df_vari, nutrient, year, output)
  return(vari)
}

# annual report statements ------------------------------------------------
#' Give range for values
#'
#' Outputs string stating value ranges for insertion into annual reports
#'
#' @param nutrient the nutrient column name (as string) to pull data from
#'
func_range <- function(nutrient){
  # filter date range
  df_wq_cur <- subset(df_wq_raw, Date >= glue::glue('{report_year}-01-01'))
  
  
  # pull relevant values and info
  min_val <- paste(func_stats_report(df_wq_cur, nutrient, 'min', 'value'), assign_units(nutrient))
  min_meta <- func_stats_report(df_wq_cur, nutrient,'min','metadata')
  max_val <- paste(func_stats_report(df_wq_cur, nutrient, 'max', 'value'), assign_units(nutrient))
  max_meta <- func_stats_report(df_wq_cur, nutrient, 'max','metadata')
  
  # if (min_meta)
  vari <- glue::glue('{min_val} {min_meta} to {max_val} {max_meta} in {report_year}')

  vari <- color_func(vari)
  
  return(vari)
}

#' Compare highest values between years
#'
#' Outputs string stating value ranges for insertion into annual reports
#'
#' @param nutrient the nutrient column name (as string) to pull data from
#'
func_comparison <- function(nutrient){
  df_wq_cur <- subset(df_wq_raw, Date >= glue::glue('{report_year}-01-01'))
  df_wq_prev <- subset(df_wq_raw, Date <= glue::glue('{report_year}-01-01') & Date >= glue::glue('{prev_year}-01-01'))
  
  max_cur <- func_stats_report(df_wq_cur, nutrient, 'max', 'value', report_year)
  max_prev <- func_stats_report(df_wq_prev, nutrient, 'max', 'value', prev_year)
  
  if(max_cur > max_prev){
    dif_dir <- 'higher than'
  } else if (max_cur < max_prev){
    dif_dir <- 'lower than'
  } else if (max_cur == max_prev){
    dif_dir <- 'equal to'
  }
  
  max_cur_txt <- paste(max_cur, assign_units(nutrient))
  max_prev_txt <- paste(max_prev, assign_units(nutrient))
  
  # slight differences for grammar
  if(dif_dir == 'equal to'){
    vari <- glue::glue('in {report_year} were {dif_dir} the average from {prev_year} (\U03BC  = {max_cur_txt})')
  } else{
    vari <- glue::glue('in {report_year} (\U03BC  = {max_cur_txt}) were {dif_dir} the {prev_year} average (\U03BC = {max_prev_txt})')
  }
  
  vari <- color_func(vari)
  
  return(vari)
}

