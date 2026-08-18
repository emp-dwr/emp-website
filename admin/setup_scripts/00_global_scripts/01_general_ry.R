# Global Functions --------------------------------------------------------

# determine water year
get_water_year <- function(given_year = report_year) {
  
  cache_path <- repo_path('admin', 'data', 'cache', 'WSIHIST.html')
  url <- 'https://cdec.water.ca.gov/reportapp/javareports?name=WSIHIST'
  
  # try to read from the website
  wy_html <- tryCatch({
    message('Fetching current WSIHIST data from CDEC...')
    xml2::read_html(url)
  }, error = function(e) {
    warning(paste0('Could not connect to CDEC (', conditionMessage(e),
                   '). Using cached data instead.'))
    if (file.exists(cache_path)) {
      message('Reading cached WSIHIST.html from: ', cache_path)
      xml2::read_html(cache_path)
    } else {
      stop('No cached WSIHIST.html found at ', cache_path,
           ' and CDEC could not be reached.')
    }
  })
  
  # cache result if successfully fetched
  dir.create(dirname(cache_path), showWarnings = FALSE, recursive = TRUE)
  xml2::write_html(wy_html, cache_path)
  
  # extract the <pre> block
  wy_text <- wy_html %>%
    rvest::html_element('pre') %>%
    rvest::html_text2()
  
  # split into lines and find the one matching the year
  line <- stringr::str_subset(stringr::str_split(wy_text, '\n')[[1]],
                              paste0('^', given_year, '\\b'))
  
  if (length(line) == 0)
    stop('Could not find line for year ', given_year)
  
  # split the line into columns by whitespace
  parts <- stringr::str_split(line, '\\s+')[[1]]
  parts <- parts[parts != '']  # drop empties
  
  # WY type for each basin is at the 6th and 11th position
  sac <- parts[6]
  sj  <- parts[11]
  
  decode <- function(x) switch(x,
                               'C'  = 'critically dry',
                               'D'  = 'dry',
                               'BN' = 'below normal',
                               'AN' = 'above normal',
                               'W'  = 'wet',
                               x
  )
  
  list(sac = decode(sac), sj = decode(sj))
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

# Global Variables --------------------------------------------------------

prev_year <- report_year - 1

label_order <- c(glue("Oct-{prev_year%%100}"), glue("Nov-{prev_year%%100}"), glue("Dec-{prev_year%%100}"), glue("Jan-{report_year%%100}"), glue("Feb-{report_year%%100}"), glue("Mar-{report_year%%100}"), glue("Apr-{report_year%%100}"), glue("May-{report_year%%100}"), glue("Jun-{report_year%%100}"), glue("Jul-{report_year%%100}"), glue("Aug-{report_year%%100}"), glue("Sep-{report_year%%100}"))
