# Read in Data ------------------------------------------------------------

store <- normalizePath(repo_path('_targets'))
df_raw_phyto <- targets::tar_read(df_raw_phyto, store = store)
df_analytes <- targets::tar_read(df_analytes, store = store)
df_stations <- targets::tar_read(df_stations, store = store)

# Create Base Phyto Object ------------------------------------------------

obj_phyto <- BaseClass$new(df_raw_phyto, df_analytes, df_stations)

obj_phyto$
  remove_EZ()$
  add_month()

# Create Current Year Object ----------------------------------------------

obj_phyto_cur <- obj_phyto$clone(deep = TRUE)
obj_phyto_cur$
  filter_years(report_year, range = 'single')$
  assign_regions('Phyto')

# Create Current Year Text Strings ----------------------------------------

strings_phyto_cur <- PhytoStringClass$new(obj_phyto_cur$df_raw)

# Create Base WQ Object ---------------------------------------------------

obj_pwq <- BaseClass$new(df_raw_dwq, df_analytes, df_stations)

obj_pwq$
  format_dwq()$
  remove_EZ()$
  add_month()$
  replace_nondetect()

obj_pwq_cur <- obj_pwq$clone(deep = TRUE)

obj_pwq_cur$
  filter_years(report_year)$
  assign_regions('DWQ')$
  assign_analyte_meta()

stats_pwq_cur <- WQStatsClass$new(obj_pwq_cur$df_raw)
strings_pwq_cur <- WQStringClass$new(obj_pwq_cur$df_raw)

# Create Figure Classes ---------------------------------------------------

fig_pwq <- WQFigureClass$new(obj_pwq_cur$df_raw, report_year)
fig_phyto <- BioFigureClass$new(obj_phyto_cur$df_raw, report_year)

# Generate Figures --------------------------------------------------------

create_figs_phyto <- function() {
  fig_phyto$plt_algal_tree()
  
  phyto_stations <- fig_pwq$df_raw %>%
    pull(Region) %>%
    unique()
  
  for (station in phyto_stations) {
    plt_wq <- fig_pwq$phyto_return_plt(station)[1][[1]]
    
    plt_phyto <- fig_phyto$plt_org_density(station, section = 'Phyto')
    
    fp_name <- gsub(' ', '', tolower(station))
    fp_name <- gsub('&', '', fp_name)
    
    ggsave(
      filename = repo_path(paste0('admin/figures-tables/phyto/phyto_wq_', fp_name, '.png')),
      plot = plt_wq,
      width = 6 * 0.8,
      height = 3.5 * 0.8,
      units = 'in'
    )
    
    ggsave(
      filename = repo_path(paste0('admin/figures-tables/phyto/phyto_bar_', fp_name, '.png')),
      plot = plt_phyto,
      width = 10,
      height = 8,
      units = 'in'
    )
  }
}

create_figs_phyto()