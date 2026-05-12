# render individual reports
render_report <- function(programs, report_type, report_year = NULL, as_job = TRUE) {
  
  if (is.null(report_year)) {
    stop('report_year must be supplied explicitly, e.g. report_year = 2024')
  }
  
  programs <- match.arg(
    programs,
    c('benthic', 'cwq', 'dwq', 'phyto', 'zoop'),
    several.ok = TRUE
  )
  
  report_type <- match.arg(report_type, c('pdfs', 'website'))
  report_year <- as.integer(report_year)
  
  for (prog in programs) {
    
    file_path <- if (report_type == 'pdfs') {
      here::here('pdfs', paste0(prog, '-report.qmd'))
    } else {
      here::here('website', prog, paste0(prog, '-report.qmd'))
    }
    
    if (!file.exists(file_path)) {
      stop('File not found: ', file_path)
    }
    
    message('Rendering ', file_path, ' for report year ', report_year, '...')
    
    quarto::quarto_render(
      input = file_path,
      execute_params = list(report_year = report_year),
      as_job = as_job
    )
  }
  
  message('Done!')
}

# render whole website
render_website <- function(report_year = NULL, as_job = TRUE) {
  
  if (is.null(report_year)) {
    stop('report_year must be supplied explicitly, e.g. report_year = 2024')
  }
  
  report_year <- as.integer(report_year)
  
  quarto::quarto_render(
    input = here::here('website'),
    execute_params = list(report_year = report_year),
    as_job = as_job
  )
}

# for use by GitHub for auto-updates
render_mussels <- function(as_job = TRUE) {
  
  file_path <- here::here(
    'website',
    'special-studies',
    'golden-mussels.qmd'
  )
  
  if (!file.exists(file_path)) {
    stop('File not found: ', file_path)
  }
  
  message('Rendering golden-mussels.qmd...')
  
  quarto::quarto_render(
    input = file_path,
    as_job = as_job
  )
  
  message('Done!')
}