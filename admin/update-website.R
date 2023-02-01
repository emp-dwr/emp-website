# run to compile html files for website
# WARNING: after running, once pushed to GitHub "gh-pages" branch, website will be updated

bookdown::render_book(
  input = 'admin/config-yaml.Rmd',
  output_dir = './docs',
  config_file = 'admin/_bookdown.yml',
  output_format = 'bookdown::gitbook'
)
 