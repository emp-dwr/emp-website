pdfs_dir <- normalizePath(getwd(), winslash = '/', mustWork = TRUE)
repo_dir <- normalizePath(file.path(pdfs_dir, '..'), winslash = '/', mustWork = TRUE)

src <- file.path(repo_dir, 'admin', 'figures-tables')
dst_parent <- file.path(pdfs_dir, 'admin')
dst <- file.path(dst_parent, 'figures-tables')

if (!dir.exists(src)) {
  stop('Source figures folder does not exist: ', src)
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

if (!ok) {
  stop('Failed to copy figures folder from ', src, ' to ', dst_parent)
}