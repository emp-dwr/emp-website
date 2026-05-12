repo_path <- function(...) {
  qpd <- Sys.getenv('QUARTO_PROJECT_DIR')
  
  if (nzchar(qpd)) {
    file.path(qpd, '..', ...)
  } else {
    here::here(...)
  }
}

source_env <- if (requireNamespace('knitr', quietly = TRUE)) {
  knitr::knit_global()
} else {
  .GlobalEnv
}

file_sources <- list.files(
  path = repo_path('admin', 'setup_scripts'),
  pattern = '\\.R$',
  full.names = TRUE,
  recursive = TRUE
)

invisible(lapply(file_sources, source, local = source_env))