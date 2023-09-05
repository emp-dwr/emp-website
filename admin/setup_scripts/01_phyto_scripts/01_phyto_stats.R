
# basic stats -------------------------------------------------------------

#' Determine limiting chla
#' 
#' determine percentage of samples with Chla < 10 ug
#' 
#' @param df the relevant data frame
#' 
low_chla <- function(df, output_type){
  # determine when chla < 10 ug
  df <- df %>%
    dplyr::filter(!is.na(Chla)) %>%
    dplyr::mutate(LowChla = 
                    dplyr::case_when(Chla < 10 ~ TRUE,
                                     Chla >= 10 ~ FALSE)
    )
    
  if (output_type == 'percent'){
    output <- round((sum(df$LowChla)/nrow(df))*100,1)    
  } else if (output_type == 'count') {
    output <- sum(df$LowChla)
  } else if (output_type == 'inverse') {
    output <- nrow(df) - sum(df$LowChla)
  }
  
  return(output)
}
