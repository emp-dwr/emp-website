# Read in Data ------------------------------------------------------------

repo_dir <- rprojroot::find_root(
  rprojroot::has_file_pattern("[.]Rproj$")
)

admin_file <- function(...) {
  file.path(repo_dir, "admin", ...)
}

schema_cwq = yaml::read_yaml(admin_file("file_schemas", "cwq.yml"))
df_raw_cwq <- read_typed(schema_cwq,
  \(ct) read_csv(admin_file("data", "CWQ_Data.csv"), col_types = ct, lazy = FALSE)
)

schema_analytes <- yaml::read_yaml(admin_file("file_schemas", "meta_analytes.yml"))
df_analytes <- read_typed(schema_analytes, \(ct)
                          read_csv(admin_file("figures-tables", "admin", "analyte_table.csv"),
                                   locale = locale(encoding = "UTF-8"), col_types = ct, lazy = FALSE))

schema_regions <- yaml::read_yaml(admin_file("file_schemas", "meta_regions.yml"))
df_regions <- read_typed(schema_regions, \(ct)
                         read_csv(admin_file("figures-tables", "admin", "station_table.csv"),
                                  col_types = ct, lazy = FALSE))

# Create Base CWQ Object --------------------------------------------------

obj_cwq <- BaseClass$new(df_raw_cwq, df_analytes, df_regions)

obj_cwq$remove_EZ()

obj_cwq$remove_bottom()

obj_cwq$assign_analyte_meta()

obj_cwq$assign_regions("CWQ")

obj_cwq$remove_NAs()

obj_cwq$add_month()

# Create Current/Previous Year Objects ------------------------------------

obj_cwq_cur <- obj_cwq$clone(deep = TRUE)
obj_cwq_cur$filter_years(report_year, range = "single")

obj_cwq_prev <- obj_cwq$clone(deep = TRUE)
obj_cwq_prev$filter_years(prev_year, range = "single")

# Create Current/Previous Year Stats --------------------------------------

stats_cwq_cur <- WQStatsClass$new(obj_cwq_cur$df_raw)

stats_cwq_prev <- WQStatsClass$new(obj_cwq_prev$df_raw)

# Create Current/Previous Year Text Strings -------------------------------

strings_cwq_cur <- WQStringClass$new(obj_cwq_cur$df_raw)

strings_cwq_prev <- WQStringClass$new(obj_cwq_prev$df_raw)

# Create Current Year Summary Table ---------------------------------------

table_cwq <- WQTableClass$new(obj_cwq_cur$df_raw)

# Create Current Year Plots -----------------------------------------------

fig_cwq <- WQFigureClass$new(obj_cwq_cur$df_raw)

# Create RRI DO Object ----------------------------------------------------

obj_rri <- WQRRIClass$new(obj_cwq_cur$df_raw)

# Generate Figures --------------------------------------------------------

create_figs_cwq <- function() {
  # main figures
  cwq_analytes <- df_analytes %>%
    filter(str_detect(Program, "\\bCEMP\\b")) %>%
    pull(Analyte)
  
  for (param in cwq_analytes) {
    plt <- fig_cwq$wq_return_plt_gaps(param, "cwq")
    
    height_factor <- fig_cwq$df_raw %>%
      pull(Region) %>%
      unique() %>%
      length()
    
    exp_height <- ceiling(height_factor) * 2
    
    ggsave(
      filename = repo_path(
        'admin',
        'figures-tables',
        'cwq',
        paste0('cwq_ts_', tolower(param), '.png')
      ),
      plot = plt,
      width = 7 * 0.8,
      height = exp_height * 0.8,
      units = 'in'
    )
  }
  
  # # RRI fig
  obj_rri$create_rri_plt()
}

create_figs_cwq()