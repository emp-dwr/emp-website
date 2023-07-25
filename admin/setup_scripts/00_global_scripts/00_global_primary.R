# define pipe expression
`%>%` <- magrittr::`%>%`
`%!in%` <- function(x,y)!('%in%'(x,y))


# global variables --------------------------------------------------------

report_year <- as.character(as.integer(format(Sys.Date(), '%Y'))-1)
prev_year <- as.character(as.integer(format(Sys.Date(), '%Y'))-2)

# file organization -------------------------------------------------------

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

