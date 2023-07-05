# basic variables ---------------------------------------------------------
#' Extract water year
#'
#' Extract water year from CDEC. Uses the 'Sac WY' location
#'
#' @param year the year desired
#'
func_wy_pre <- function(year){
  wy_text <- 'https://cdec.water.ca.gov/reportapp/javareports?name=WSIHIST' %>%
    rvest::read_html() %>%
    rvest::html_element('pre') %>% rvest::html_text2()
  
  wy_int <- stringr::str_match(wy_text, paste0("(?<=",year,")(.*?[a-zA-Z]+)(?=\\r)"))[[1]][1]
  wy_abb <- stringr::str_match(wy_int, "[a-zA-Z]+")
  
  if(wy_abb == 'C'){
    water_year <- 'Critical'
    } else if(wy_abb == 'W'){
      water_year <- 'Wet'
      } else if(wy_abb == 'D'){
        water_year <- 'Dry'
        } else if(wy_abb == 'AN'){
          water_year <- 'Above Normal'
          } else if (wy_abb == 'BN'){
            water_year <- 'Below Normal'
          }
  return(water_year)
}

func_wy <- function(year){
  color = ifelse(autogen_color, 'red', '#585858')
  kableExtra::text_spec(func_wy_pre(year), color = color)
}