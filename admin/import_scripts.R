repo_path <- function(...) {
  qpd <- Sys.getenv('QUARTO_PROJECT_DIR')
  root <- if (nzchar(qpd)) file.path(qpd, '..') else here::here()
  normalizePath(file.path(root, ...), winslash = '/', mustWork = FALSE)
}

.global_scripts <- c(
  '00_pkgfuncs.R',
  '01_general.R',
  '01_general_copy.R',
  '01_general_edi.R',
  '01_general_ry.R',
  '03_schema.R'
)

.section_scripts <- list(
  cwq = c('01_wq_scripts/00_wq-general.R',
          '01_wq_scripts/01_cwq-specific.R',
          '01_wq_scripts/02_cwq-initialize.R'),
  
  dwq = c('01_wq_scripts/00_wq-general.R',
          '01_wq_scripts/02_dwq-initialize.R'),
  
  benthic = c('02_bio_scripts/00_phyto-specific.R', # bc of class inheritance
              '02_bio_scripts/00_bio-general.R',
              '02_bio_scripts/01_benthic-processing.R',
              '02_bio_scripts/02_benthic-initialize.R'),
  
  phyto = c('02_bio_scripts/00_phyto-specific.R',
            '02_bio_scripts/00_bio-general.R',
            '01_wq_scripts/00_wq-general.R',
            '02_bio_scripts/02_phyto-initialize.R'),
  
  zoop = character(0)
)

load_section <- function(section, envir = parent.frame()) {
  section <- match.arg(section, names(.section_scripts))
  
  paths <- c(
    repo_path('admin', 'setup_scripts', '00_global_scripts', .global_scripts),
    repo_path('admin', 'setup_scripts', .section_scripts[[section]])
  )
  
  missing <- paths[!file.exists(paths)]
  if (length(missing)) {
    stop('Missing script(s) for section "', section, '":\n  ',
         paste(missing, collapse = '\n  '), call. = FALSE)
  }
  
  invisible(lapply(paths, source, local = envir))
}