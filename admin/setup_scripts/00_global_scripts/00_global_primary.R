# define pipe expression
`%>%` <- magrittr::`%>%`
`%!in%` <- function(x,y)!('%in%'(x,y))


#' TODO: later
#' 

read_quiet_csv <- function(fp){
  df <- readr::read_csv(fp, show_col_types = FALSE)
  
  return(df)
}

#' TODO: later
#' 

color_func <- function(txt_str){
  if(exists('autogen_color')){
    color <- ifelse(!!{autogen_color}, 'red', '#585858')
  } else{
    color <- '#585858'
  }

  kableExtra::text_spec(txt_str, color = color)
}

#' TODO: later
#' 

assign_colors <- function(df, col, pal = 'cbfriendly'){
  # create df for colors
    # grab needed variables
  uni_vals <- unique(df[[col]])
  
  if (pal != 'custom' & pal != 'cbfriendly'){
    colors <- RColorBrewer::brewer.pal(length(uni_vals), pal)    
  } else if (pal == 'custom') {
    colors <- pal[1:length(uni_vals)]
  } else if (pal == 'cbfriendly'){
    colors <- c(RColorBrewer::brewer.pal(8, 'Set2'), RColorBrewer::brewer.pal(8, 'Dark2'))[1:length(uni_vals)]
  }

    # create data frame
  df_colors <- data.frame(color = colors)
  df_colors[[col]] <- with(df_colors, uni_vals)
  
  # merge with original df
  df_out <- dplyr::left_join(df, df_colors)  
  
  return(df_out)
}

# global variables --------------------------------------------------------

report_year <- as.character(as.integer(format(Sys.Date(), '%Y'))-1)
report_year_txt <- color_func(report_year)

prev_year <- as.character(as.integer(format(Sys.Date(), '%Y'))-2)
prev_year_txt <- color_func(prev_year)


# basic functions ---------------------------------------------------------

#' Subset by Year
#' 
#' Subset df by given year
#' 
#' @param df the relevant df
#' @param year the relevant year (as string)
#' 
subset_year <- function(df, year = report_year){
  date_col <- colnames(df)[stringr::str_detect(colnames(df), 'Date')]

  df <- df %>%
    dplyr::filter(lubridate::year(get(date_col)) == year)
  
  return(df)
}

# file organization functions -------------------------------------------------------

#' Data export path
#'
#' The path to the EMP SharePoint. Used for exporting files
#'
#' @param fp_rel The relative filepath nested under the absolute one
#' @details Assumes access to EMP SharePoint
#'
abs_path_data <- function(fp_rel = NULL) {
  fp_emp <- 'California Department of Water Resources/Environmental Monitoring Program - Documents/Annual Report Docs/'
  
  if (is.null(fp_rel)) {
    fp_abs <- normalizePath(file.path(Sys.getenv('USERPROFILE'), fp_emp))
  } else {
    fp_abs <- normalizePath(file.path(Sys.getenv('USERPROFILE'), fp_emp, fp_rel))
  }
  
  return(fp_abs)
}

#' Download EDI Package Files
#'
#' Download the latest revision of files in an EDI package
#'
#' @param pkg_id The EDI Package ID
#' @param fnames A vector of file names in the package to download. Supports regex.
#' @param verbose If TRUE, display descriptive messages.
#' @return a list of dataframes
#'
#' @details Currently, this function assumes that all files in fnames can be 
#'   parsed using readr::read_csv().
#'
get_edi_file = function(pkg_id, fnames, verbose = TRUE){
  # get revision
  revision_url = glue::glue("https://pasta.lternet.edu/package/eml/edi/{pkg_id}")
  all_revisions = readLines(revision_url, warn = FALSE) 
  latest_revision = tail(all_revisions, 1)
  if (verbose) {
    message("Latest revision: ", latest_revision)
  }
  # get entities 
  pkg_url = glue::glue("https://pasta.lternet.edu/package/data/eml/edi/{pkg_id}/{latest_revision}")
  all_entities = readLines(pkg_url, warn = FALSE)
  name_urls = glue::glue("https://pasta.lternet.edu/package/name/eml/edi/{pkg_id}/{latest_revision}/{all_entities}")
  names(all_entities) = purrr::map_chr(name_urls, readLines, warn = FALSE)
  if (verbose) {
    message("Package contains files:\n", 
            stringr::str_c("    ", names(all_entities), sep = "", collapse = "\n"))
  }
  # select entities that match fnames
  fname_regex = stringr::str_c(glue::glue("({fnames})"), collapse = "|")
  included_entities = all_entities[stringr::str_detect(names(all_entities), fname_regex)]
  if(length(included_entities) != length(fnames)){
    stop("Not all specified filenames are included in package")
  }
  # download data
  if (verbose) {
    message("Downloading files:\n",
            stringr::str_c("    ", names(included_entities), sep = "", collapse = "\n"))
  }
  dfs = purrr::map(glue::glue("https://portal.edirepository.org/nis/dataviewer?packageid=edi.{pkg_id}.{latest_revision}&entityid={included_entities}"),
                   readr::read_csv, guess_max = 1000000)
  names(dfs) = names(included_entities)
  dfs
}


#' Obtain EDI URL
#'
#' Gives the url for a package's specified revision
#'
#' @param pkg_id The EDI Package ID
#' @param fnames A vector of file names in the package to download. Supports regex.
#' @param verbose If TRUE, display descriptive messages.
#' @return a list of dataframes
#'
#' @details Currently, this function assumes that all files in fnames can be 
#'   parsed using readr::read_csv().
#'
get_edi_url <- function(pkg_id, revision_num = 'current', verbose = FALSE) {
  # get revision
  revision_url = glue::glue('https://pasta.lternet.edu/package/eml/edi/{pkg_id}')
  all_revisions = readLines(revision_url, warn = FALSE)
  latest_revision = tail(all_revisions, 1)
  if (verbose) {
    message('Latest revision: ', latest_revision)
  }
  all_revisions = readLines(revision_url, warn = FALSE)
  latest_revision = tail(all_revisions, 1)

  if (revision_num != 'current') {
    revision <- revision_num
  } else {
    revision <- latest_revision
  }
  
  if (latest_revision == 0) {
    edi_url <- glue::glue('https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier={pkg_id}')
  }  else {
    edi_url <- glue::glue('https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier={pkg_id}&revision={revision}')
  }
  
  return(edi_url)
}

#' Assign regions to stations
#'
#' @param df the relevant data frame
#'
assign_regions <- function(df){
  df %>% dplyr::mutate(
    Region = dplyr::case_when(
      Station == 'D16' | Station == 'D19' | Station == 'D26' | Station == 'D28A' ~ 'Central Delta',
      Station =='D10' | Station == 'D12' | Station == 'D22' | Station == 'D4' ~ 'Confluence',
      Station =='C3A' | Station == 'NZ068' ~ 'Northern Interior Delta',
      Station =='D41' | Station == 'D41A' | Station == 'D6' | Station == 'NZ002' | Station == 'NZ004' | Station == 'NZ325' ~ 'San Pablo Bay',
      Station == 'C10A' | Station == 'C9' | Station == 'MD10A' | Station == 'P8' ~ 'Southern Interior Delta',
      Station == 'D7' | Station == 'D8' | Station == 'NZ032' | Station == 'NZS42' ~ 'Suisun & Grizzly Bays'
    )
  )
}


# Table Options -----------------------------------------------------------

# kable options
opts <- options(knitr.kable.NA = '') # NA not displayed in tables

kable_tables <- function(data, caption = NULL) {
  knitr::kable(data, caption = caption, align = 'c') %>% 
    kableExtra::kable_styling(c('striped', 'scale_down'), font_size = 14, html_font = 'Arimo', full_width = FALSE)
}
