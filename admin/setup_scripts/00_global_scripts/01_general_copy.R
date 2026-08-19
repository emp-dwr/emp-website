# copy figures
copy_figures <- function(target = c('website', 'pdfs')) {
  target <- match.arg(target)
  
  repo_dir <- rprojroot::find_root(rprojroot::has_file_pattern('[.]Rproj$'))
  src <- file.path(repo_dir, 'admin', 'figures-tables')
  dst_parent <- file.path(repo_dir, target, 'admin')
  dst <- file.path(dst_parent, 'figures-tables')
  
  if (!dir.exists(src)) {
    stop('Source figures folder does not exist: ', src, call. = FALSE)
  }
  
  if (dir.exists(dst)) {
    unlink(dst, recursive = TRUE, force = TRUE)
  }
  
  dir.create(dst_parent, recursive = TRUE, showWarnings = FALSE)
  
  ok <- file.copy(
    from = src,
    to = dst_parent,
    recursive = TRUE,
    overwrite = TRUE,
    copy.date = TRUE
  )
  
  if (!all(ok)) {
    stop('Failed to copy figures folder from ', src, ' to ', dst_parent, call. = FALSE)
  }
  
  invisible(dst)
}