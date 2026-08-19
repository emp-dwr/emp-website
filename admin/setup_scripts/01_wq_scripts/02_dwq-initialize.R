# Read in Data ------------------------------------------------------------

store <- normalizePath(repo_path('_targets'))
df_raw_dwq  <- targets::tar_read(df_raw_dwq, store = store)
df_analytes <- targets::tar_read(df_analytes, store = store)
df_stations <- targets::tar_read(df_stations, store = store)

# Create Base DWQ Object --------------------------------------------------

obj_dwq <- BaseClass$new(df_raw_dwq, df_analytes, df_stations)

obj_dwq$
  format_dwq()$
  remove_EZ()$
  add_month()$
  replace_nondetect()

# Create Current/Previous Year Objects ------------------------------------

obj_dwq_cur <- obj_dwq$clone(deep = TRUE)
obj_dwq_cur$
  filter_years(report_year, range = 'single')$
  assign_regions('DWQ')$
  assign_analyte_meta()
  
obj_dwq_prev <- obj_dwq$clone(deep = TRUE)
obj_dwq_prev$
  filter_years(prev_year, range = 'single')$
  assign_regions('DWQ')$
  assign_analyte_meta()

# Create Current/Previous Year Stats --------------------------------------

stats_dwq_cur <- WQStatsClass$new(obj_dwq_cur$df_raw)

stats_dwq_prev <- WQStatsClass$new(obj_dwq_prev$df_raw)

# Create Current/Previous Year Text Strings -------------------------------

strings_dwq_cur <- WQStringClass$new(obj_dwq_cur$df_raw)

strings_dwq_prev <- WQStringClass$new(obj_dwq_prev$df_raw)

# Create Current Year Summary Table ---------------------------------------

table_dwq <- WQTableClass$new(obj_dwq_cur$df_raw)

# Create Figure Object ----------------------------------------------------

fig_dwq <- WQFigureClass$new(obj_dwq_cur$df_raw, report_year)

# Generate Figures --------------------------------------------------------

create_figs_dwq <- function() {
  dwq_analytes <- df_analytes %>%
    filter(str_detect(Section, '\\bDEMP\\b')) %>%
    pull(Analyte)
  
  for (param in dwq_analytes) {
    plt <- fig_dwq$wq_return_plt_gaps(param, 'dwq')
    
    height_factor <- fig_dwq$df_raw %>%
      pull(Region) %>%
      unique() %>%
      length()
    
    exp_height <- ceiling(height_factor / 2) * 2
    
    ggsave(
      filename = repo_path(paste0('admin/figures-tables/dwq/dwq_ts_', tolower(param), '.png')),
      plot = plt,
      width = 6 * 0.8,
      height = exp_height * 0.8,
      units = 'in'
    )
  }
}

create_figs_dwq()