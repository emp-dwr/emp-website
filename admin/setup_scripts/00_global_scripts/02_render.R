
# render individual reports
render_report <- function(sections, report_type, report_year = NULL) {
  
  if (is.null(report_year)) {
    stop('report_year must be supplied explicitly')
  }
  
  sections <- match.arg(
    sections,
    c('benthic', 'cwq', 'dwq', 'phyto', 'zoop'),
    several.ok = TRUE
  )
  
  report_type <- match.arg(report_type, c('pdfs', 'website'))
  report_year <- as.integer(report_year)
  
  for (sect in sections) {
    
    file_path <- if (report_type == 'pdfs') {
      here::here('pdfs', paste0(sect, '-report.qmd'))
    } else {
      here::here('website', sect, paste0(sect, '-report.qmd'))
    }
    
    if (!file.exists(file_path)) {
      stop('File not found: ', file_path)
    }
    
    message('Rendering ', file_path, ' for report year ', report_year, '...')
    
    quarto::quarto_render(
      input = file_path,
      execute_params = list(report_year = report_year),
      as_job = FALSE,
      quiet = FALSE
    )
  }
  
  message('Copying figures and tables...')
  copy_figures(report_type)
  
  message('Done!')
}

# render whole website
render_website <- function(report_year = NULL) {
  
  if (is.null(report_year)) {
    stop('report_year must be supplied explicitly')
  }
  
  report_year <- as.integer(report_year)
  
  message('Rendering full website for report year ', report_year, '...')
  quarto::quarto_render(
    input = here::here('website'),
    execute_params = list(report_year = report_year)
  )
  
  message('Copying figures and tables...')
  copy_figures('website')
  
  message('Rebuilding site with fresh figures...')
  quarto::quarto_render(
    input = here::here('website'),
    execute_params = list(report_year = report_year),
    profile = 'freeze',
    as_job = FALSE,
    quiet = FALSE
  )
  
  message('Done!')
}

# render all pdfs
render_pdfs <- function(report_year = NULL) {
  
  if (is.null(report_year)) {
    stop('report_year must be supplied explicitly')
  }
  
  report_year <- as.integer(report_year)

  message('Rendering all pdfs for report year ', report_year, '...')
  quarto::quarto_render(
    input = here::here('pdfs'),
    execute_params = list(report_year = report_year),
    quiet = FALSE,
    as_job = FALSE
  )
  
  message('Copying figures and tables...')
  copy_figures('pdfs')
  
  message('Done!')
}

# for use by GitHub for auto-updates
render_mussels <- function(as_job = FALSE) {
  
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