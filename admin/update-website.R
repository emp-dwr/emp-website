# run to compile html files for website
# WARNING: after running, once pushed to GitHub "gh-pages" branch, website will be updated

quarto::quarto_render(
  profile = 'website'
)
