# download data from EDI (assumption is all data will be downloaded for all; not great, but for now)
df_wq_raw <- get_edi_file(458, glue::glue('EMP_DWQ_1975_{report_year}'))
df_wq_raw <- df_wq_raw[[1]]

# clean data --------------------------------------------------------------

#' Assign unit to nutrient
#'
#' @param nutrient the relevant nutrient
#'
#' @details TODO: TURN INTO CSV (so others can edit)
#' 
assign_units <- function(nutrient){
  if (nutrient == 'SpCndSurface'){
    unit <- '\U03BCS/cm'
  } else if (nutrient == 'TurbiditySurface_FNU'){
    unit <- 'FNU'
  } else if (nutrient == 'DissAmmonia' | nutrient == 'DissNitrateNitrite' |nutrient == 'TotPhos'){
    unit <- 'mg/L'
  } else if (nutrient == 'Chla'){
    unit <- '\U03BC/L'
  }
}

# statistics helper functions --------------------------------------------------------------
#' Compute statistics
#'
#' Computes various statistics for reports
#'
#' @param df the relevant data frame
#' @param nutrient the nutrient column name (as string) to pull data from
#' @param stat the function to apply to the data. choices are: min, max, etc.
#'
#' @details this is a helper function for 'func_stats_report'
#'
func_sumstats <- function(df, nutrient, year, stat){
  # subset report year
  df <- subset_year(df, year)
  
  if (stat == 'min'){
    df_output <- df %>% dplyr::filter(!!rlang::sym(nutrient) == min(df[[nutrient]], na.rm = TRUE))
  } else if (stat == 'max'){
    df_output <- df %>% dplyr::filter(!!rlang::sym(nutrient) == max(df[[nutrient]], na.rm = TRUE))
  } else if (stat == 'median'){
    # percent_nd <- df[[nutrient]]/df[[paste0(nutrient,'_Sign')]]
    df_output <- median(df[[nutrient]], na.rm = TRUE)
  }
  return(df_output)
}

#' Compute statistics
#'
#' Creates a string version of statistical outputs to enter in reports
#'
#' @param df the relevant dataframe
#' @param nutrient the nutrient column name (as string) to pull data from
#' @param output the type of output string desired. choices are: min, max, etc.
#'
#' @details this is a helper function for 'func_stats_report'
#'
func_output <- function(df, nutrient, year, output){
  print(typeof(df))
  if(typeof(df) == 'list'){
    # subset report year
    df <- subset_year(df, year)
    
    # needed variables
    col_sign <- paste0(nutrient,'_Sign')  
    
    if (col_sign %in% colnames(df)){
      sign <- unique(dplyr::pull(df, col_sign))
      if ('<' %in% sign){
        sign <- '<'
      }
    } else {
      sign <- 'none'
    }
    print('here')
    if (output == 'value'){
      print('maybe here')
      # define nutrient value
      nutri <- unique(dplyr::pull(df, nutrient))
      
      # if sign exists (ie. "<"), then append to output
      if (sign == '<'){
        vari <- paste(sign, nutri)
      } else {
        vari <- as.character(nutri)
      }
    } else if (output == 'metadata') {
      # assign regions to df
      df <- assign_regions(df)
      
      # define relevant variables
      station <- dplyr::pull(df, Station)
      region <- dplyr::pull(df, Region)
      month <- months(dplyr::pull(df, Date))
      
      # return string based on # of occurrences
      if (nrow(df) == 1) {
        vari <- glue::glue('({station} in {region}, {month})')
      } else if ('<' %in% sign) {
        vari <- glue::glue('(the reporting limit)')
      } else{
        vari <- NULL
      }
    }
  } else{
    df <- round(df, 2)
    vari <- as.character(df)
  }
  return(vari)
}

