# Read in Data ------------------------------------------------------------

repo_dir <- rprojroot::find_root(
  rprojroot::has_file_pattern("[.]Rproj$")
)

admin_file <- function(...) {
  file.path(repo_dir, "admin", ...)
}

schema_phyto = yaml::read_yaml(admin_file("file_schemas", "phyto.yml"))
df_raw_phyto = read_typed(schema_phyto, \(ct)
                          get_edi_file("1320", "EMP_Phyto_FieldOnly", match_type = "regex", col_types = ct))

schema_dwq = yaml::read_yaml(admin_file("file_schemas", "dwq.yml"))
df_raw_dwq = read_typed(schema_dwq, \(ct)
                        get_edi_file("458", "EMP_DWQ", match_type = "regex", col_types = ct))

schema_analytes <- yaml::read_yaml(admin_file("file_schemas", "meta_analytes.yml"))
df_analytes <- read_typed(schema_analytes, \(ct)
                          read_csv(admin_file("figures-tables", "admin", "analyte_table.csv"),
                                   locale = locale(encoding = "UTF-8"), col_types = ct, lazy = FALSE))

schema_regions <- yaml::read_yaml(admin_file("file_schemas", "meta_regions.yml"))
df_regions <- read_typed(schema_regions, \(ct)
                         read_csv(admin_file("figures-tables", "admin", "station_table.csv"),
                                  col_types = ct, lazy = FALSE))

# Create Base Phyto Object ------------------------------------------------

obj_phyto <- BaseClass$new(df_raw_phyto, df_analytes, df_regions)

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

obj_pwq <- BaseClass$new(df_raw_dwq, df_analytes, df_regions)

obj_pwq$
  format_aquarius()$
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

fig_pwq <- WQFigureClass$new(obj_pwq_cur$df_raw)
fig_phyto <- BioFigureClass$new(obj_phyto_cur$df_raw)

# Generate Figures --------------------------------------------------------

create_figs_phyto <- function() {
  fig_phyto$plt_algal_tree()
  
  phyto_regions <- fig_pwq$df_raw %>%
    pull(Region) %>%
    unique()
  
  for (region in phyto_regions) {
    plt_wq <- fig_pwq$phyto_return_plt(region)[1][[1]]
    
    plt_phyto <- fig_phyto$plt_org_density(region, program = 'Phyto')
    
    fp_name <- gsub(' ', '', tolower(region))
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