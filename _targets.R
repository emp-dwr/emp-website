library(targets)
library(tarchetypes)
library(httr2)
library(purrr)

repo_path <- function(...) here::here(...)

tar_option_set(packages = c("readr", "dplyr", "stringr", "yaml", "here", "purrr", "httr2"))

invisible(lapply(
  file.path(repo_path('admin', 'setup_scripts', '00_global_scripts'),
            c('01_general_edi.R', '03_schema.R')),
  source
))

# EDI-sourced -------------------------------------------------------------
benthic_targets <- tar_plan(
  tar_target(benthic_schema_file, "admin/file_schemas/benthic.yml", format = "file"),
  schema_benthic = yaml::read_yaml(benthic_schema_file),
  tar_target(ben_rev, edi_latest_revision("1036"), cue = tar_cue(mode = "always")),
  df_raw_ben = read_typed(schema_benthic, \(ct)
                          get_edi_file("1036", "DWR Benthic CPUE data", match_type = "regex",
                                       col_types = ct, revision = ben_rev))
)

dwq_targets <- tar_plan(
  tar_target(dwq_schema_file, "admin/file_schemas/dwq.yml", format = "file"),
  schema_dwq = yaml::read_yaml(dwq_schema_file),
  tar_target(dwq_rev, edi_latest_revision("458"), cue = tar_cue(mode = "always")),
  df_raw_dwq = read_typed(schema_dwq, \(ct)
                          get_edi_file("458", "EMP_DWQ", match_type = "regex",
                                       col_types = ct, revision = dwq_rev))
)

phyto_targets <- tar_plan(
  tar_target(phyto_schema_file, "admin/file_schemas/phyto.yml", format = "file"),
  schema_phyto = yaml::read_yaml(phyto_schema_file),
  tar_target(phyto_rev, edi_latest_revision("1320"), cue = tar_cue(mode = "always")),
  df_raw_phyto = read_typed(schema_phyto, \(ct)
                            get_edi_file("1320", "EMP_Phyto_FieldOnly", match_type = "regex",
                                         col_types = ct, revision = phyto_rev))
)

# Local files -------------------------------------------------------------
cwq_targets <- tar_plan(
  tar_target(cwq_schema_file, "admin/file_schemas/cwq.yml", format = "file"),
  tar_target(cwq_data_file,   "admin/data/CWQ_Data.csv",    format = "file"),
  schema_cwq = yaml::read_yaml(cwq_schema_file),
  df_raw_cwq = read_typed(schema_cwq, \(ct)
                          read_csv(cwq_data_file, col_types = ct, lazy = FALSE))
)

meta_targets <- tar_plan(
  tar_target(analytes_schema_file, "admin/file_schemas/meta_analytes.yml",   format = "file"),
  tar_target(analytes_file, "admin/figures-tables/admin/analyte_metadata.csv",  format = "file"),
  schema_analytes = yaml::read_yaml(analytes_schema_file),
  df_analytes = read_typed(schema_analytes, \(ct)
                           read_csv(analytes_file, locale = locale(encoding = "UTF-8"),
                                    col_types = ct, lazy = FALSE)),
  
  tar_target(stations_schema_file, "admin/file_schemas/meta_stations.yml",     format = "file"),
  tar_target(stations_file, "admin/figures-tables/admin/station_metadata.csv",   format = "file"),
  schema_stations = yaml::read_yaml(stations_schema_file),
  df_stations = read_typed(schema_stations, \(ct)
                          read_csv(stations_file, col_types = ct, lazy = FALSE)),
  
  # tar_target(year_file, "admin/data/report_year.txt", format = "file"),
  # report_year = as.integer(readLines(year_file)),
  # prev_year   = report_year - 1L
)

tar_plan(benthic_targets, cwq_targets, dwq_targets, phyto_targets, meta_targets)