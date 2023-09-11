# run to compile html files for website
# WARNING: after running, once pushed to GitHub "gh-pages" branch, website will be updated

file_sources <- list.files(path = 'admin/setup_scripts', pattern = '.R$', full.names = TRUE, recursive = TRUE)
sapply(file_sources, source, .GlobalEnv)

bookdown::render_book(
  input = 'admin/config-yaml.Rmd',
  output_dir = './docs',
  config_file = 'admin/_bookdown.yml',
  output_format = 'bookdown::gitbook'
)

# rm(list = ls())
