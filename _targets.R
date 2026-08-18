
library(targets)
library(tarchetypes)

# Functions ---------------------------------------------------------------

# better ways to do this, but functional for now
repo_path <- function(...) {
  here::here(...)
}

source(repo_path('admin', 'setup_scripts', '00_global_scripts', '00_pkgfuncs.R'))

source(repo_path('admin', 'setup_scripts', '00_global_scripts', '01_general.R'))

source(repo_path('admin', 'setup_scripts', '00_global_scripts', '03_schema.R'))

# Targets -----------------------------------------------------------------

benthic_targets <- tar_plan(
  schema_benthic = yaml::read_yaml("admin/file_schemas/benthic.yml"),
  df_raw_ben = read_typed(schema_benthic, \(ct)
                          get_edi_file("1036", "DWR Benthic CPUE data", match_type = "regex", col_types = ct))
)

cwq_targets <- tar_plan(
  schema_cwq = yaml::read_yaml("admin/file_schemas/cwq.yml"),
  df_raw_cwq = read_typed(schema_cwq, \(ct)
                          read_csv(here::here('admin','data','CWQ_Data.csv'), col_types = ct, lazy = FALSE))
)

dwq_targets <- tar_plan(
  schema_dwq = yaml::read_yaml("admin/file_schemas/dwq.yml"),
  df_raw_dwq = read_typed(schema_dwq, \(ct)
                          get_edi_file("458", "EMP_DWQ", match_type = "regex", col_types = ct))
)

phyto_targets <- tar_plan(
  schema_phyto = yaml::read_yaml("admin/file_schemas/phyto.yml"),
  df_raw_phyto = read_typed(schema_phyto, \(ct)
                            get_edi_file("1320", "EMP_Phyto_FieldOnly", match_type = "regex", col_types = ct))
)

meta_targets <- tar_plan(
  schema_analytes = yaml::read_yaml("admin/file_schemas/meta_analytes.yml"),
  df_analytes = read_typed(schema_analytes, \(ct)
                           read_csv(here::here('admin', 'figures-tables', 'admin', 'analyte_table.csv'),
                           locale = locale(encoding = 'UTF-8'), col_types = ct, lazy = FALSE)),
  
  schema_regions  = yaml::read_yaml("admin/file_schemas/meta_regions.yml"),
  df_regions = read_typed(schema_regions, \(ct)
                          read_csv(here::here('admin', 'figures-tables', 'admin', 'station_table.csv'),
                          col_types = ct, lazy = FALSE)),
  
  year_file = tar_target(year_file, here::here("admin/data/report_year.txt"), format = "file"),
  report_year = as.integer(readLines(year_file)),
)

# final list
tar_plan(benthic_targets, dwq_targets, cwq_targets, phyto_targets, meta_targets)