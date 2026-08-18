# Read in Data ------------------------------------------------------------

repo_dir <- rprojroot::find_root(
  rprojroot::has_file_pattern("[.]Rproj$")
)

admin_file <- function(...) {
  file.path(repo_dir, "admin", ...)
}

schema_benthic = yaml::read_yaml(admin_file("file_schemas", "benthic.yml"))
df_raw_ben = read_typed(schema_benthic, \(ct)
                        get_edi_file("1036", "DWR Benthic CPUE data", match_type = "regex", col_types = ct))

schema_analytes <- yaml::read_yaml(admin_file("file_schemas", "meta_analytes.yml"))
df_analytes <- read_typed(schema_analytes, \(ct)
                          read_csv(admin_file("figures-tables", "admin", "analyte_table.csv"),
                                   locale = locale(encoding = "UTF-8"), col_types = ct, lazy = FALSE))

schema_regions <- yaml::read_yaml(admin_file("file_schemas", "meta_regions.yml"))
df_regions <- read_typed(schema_regions, \(ct)
                         read_csv(admin_file("figures-tables", "admin", "station_table.csv"),
                                  col_types = ct, lazy = FALSE))

# Create Base Benthic Object ----------------------------------------------

obj_ben <- BaseClass$new(df_raw_ben, df_analytes, df_regions)

# Create Current Year Object ----------------------------------------------

obj_ben_cur <- obj_ben$clone(deep = TRUE)
obj_ben_cur$
  filter_years(report_year, range = 'single')$
  simplify_stations()$
  remove_EZ()$
  assign_regions('Benthic')$
  add_month()

obj_ben_cur <- BenBaseClass$new(obj_ben_cur$df_raw)

obj_ben_cur$subset_cols()

obj_ben_cur$merge_grab_cols()

# Create All Years Object -------------------------------------------------

obj_ben_all <- obj_ben$clone(deep = TRUE)
obj_ben_all$filter_years(report_year, range = 'all')

obj_ben_all <- BenBaseClass$new(obj_ben_all$df_raw)

obj_ben_all$subset_cols()

obj_ben_all$merge_grab_cols()

# Create/Export Excel Workbook --------------------------------------------

wkbk_ben <- BenWkbkClass$new(obj_ben_all$df_raw)

wkbk_ben$calc_all_year('phylum', 'wkbk')

wkbk_ben$calc_all_month('phylum', 'wkbk')

wkbk_ben$calc_station_year('phylum', 'wkbk')

wkbk_ben$calc_station_month('phylum', 'wkbk')

wkbk_ben$calc_all_year('species', 'wkbk')

wkbk_ben$calc_all_month('species', 'wkbk')

wkbk_ben$calc_station_year('species', 'wkbk')

wkbk_ben$calc_station_month('species', 'wkbk')

wkbk_ben$export_wkbk(
  abs_path_data(glue('Admin/Annual Report Docs/Benthic/annual_report_{report_year}.xlsx'))
)

# Create/Export Figures ---------------------------------------------------

fig_ben_cur <- BioFigureClass$new(obj_ben_cur$df_raw)
fig_ben_all <- BioFigureClass$new(obj_ben_all$df_raw)

create_figs_benthic <- function() {
  benthic_stations <- obj_ben_all$df_raw %>%
    pull(Station) %>%
    unique()
  
  for (station in benthic_stations) {
    # determine rel height factor
    height_factor <- obj_ben_all$df_raw %>%
      filter(Station == station) %>%
      pull(Phylum) %>%
      unique() %>%
      length()
    
    exp_height <- (10 * (ceiling(height_factor / 3) * 0.5)) + 10
    
    # determine file paths
    fp_name <- gsub('2 ', '', tolower(station))
    fp_name <- gsub('&', '', fp_name)
    emp_path <- abs_path_data('Admin/Annual Report Docs/Benthic/figures')
    
    # save time series for all stations
    plt_benthic_ts_all <- fig_ben_all$plt_ben_ts(station, scope = 'historical')
    
    ggsave(
      filename = file.path(emp_path, 'timeseries_all', paste0('benthic_tsall_', fp_name, '.png')),
      plot = plt_benthic_ts_all,
      width = 25,
      height = exp_height,
      units = 'cm'
    )
    
    # save time series by station
    if (station %in% unique(obj_ben_cur$df_raw$Station)) {
      plt_benthic <- fig_ben_cur$plt_org_density(station, program = 'Benthic')
      plt_benthic_ts <- fig_ben_cur$plt_ben_ts(station, scope = 'current')
      
      ggsave(
        filename = repo_path(paste0('admin/figures-tables/benthic/benthic_bar_', fp_name, '.png')),
        plot = plt_benthic,
        width = 25,
        height = exp_height,
        units = 'cm'
      )
      
      ggsave(
        filename = file.path(emp_path, 'bargraphs', paste0('benthic_bar_', fp_name, '.png')),
        plot = plt_benthic,
        width = 25,
        height = exp_height,
        units = 'cm'
      )
      
      ggsave(
        filename = file.path(emp_path, 'timeseries', paste0('benthic_ts_', fp_name, '.png')),
        plot = plt_benthic_ts,
        width = 25,
        height = exp_height,
        units = 'cm'
      )
    }
  }
}

create_figs_benthic()