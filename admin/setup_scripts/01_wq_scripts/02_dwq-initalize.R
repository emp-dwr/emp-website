# Read in Data ------------------------------------------------------------

df_raw_dwq <- read_quiet_csv(here("admin/test-data/EMP_DWQ_2024_report.csv"),
  col_types = cols(
    `Lab: Quality Flag` = col_character(),
    `Validation Warnings` = col_character()
  )
)

df_analytes <- read_quiet_csv(here("admin/figures-tables/admin/analyte_table.csv"), locale = locale(encoding = "UTF-8"))

df_regions <- read_quiet_csv(here("admin/figures-tables/admin/station_table.csv"))

# Create Base DWQ Object --------------------------------------------------

obj_dwq <- BaseClass$new(df_raw_dwq, df_analytes, df_regions)

obj_dwq$
  format_aquarius()$
  remove_EZ()$
  assign_analyte_meta()$
  assign_regions("DWQ")$
  add_month()$
  replace_nondetect()

# Create Current/Previous Year Objects ------------------------------------

obj_dwq_cur <- obj_dwq$clone(deep = TRUE)
obj_dwq_cur$filter_years(report_year, range = "single")

obj_dwq_prev <- obj_dwq$clone(deep = TRUE)
obj_dwq_prev$filter_years(prev_year, range = "single")

# Create Current/Previous Year Stats --------------------------------------

stats_dwq_cur <- WQStatsClass$new(obj_dwq_cur$df_raw)

stats_dwq_prev <- WQStatsClass$new(obj_dwq_prev$df_raw)

# Create Current/Previous Year Text Strings -------------------------------

strings_dwq_cur <- WQStringClass$new(obj_dwq_cur$df_raw)

strings_dwq_prev <- WQStringClass$new(obj_dwq_prev$df_raw)

# Create Current Year Summary Table ---------------------------------------

table_dwq <- WQTableClass$new(obj_dwq_cur$df_raw)

# Create Figure Object ----------------------------------------------------

fig_dwq <- WQFigureClass$new(obj_dwq_cur$df_raw)

# Generate Figures --------------------------------------------------------

create_figs_dwq <- function() {
  dwq_analytes <- df_analytes %>%
    filter(str_detect(Program, "\\bDEMP\\b")) %>%
    pull(Analyte)

  for (param in dwq_analytes) {
    plt <- fig_dwq$wq_return_plt_gaps(param, "dwq")

    height_factor <- fig_dwq$df_raw %>%
      pull(Region) %>%
      unique() %>%
      length()

    exp_height <- ceiling(height_factor / 2) * 2

    ggsave(here(paste0("admin/figures-tables/dwq/dwq_ts_", tolower(param), ".png")),
      plt,
      width = 6 * .8, height = exp_height * .8, unit = "in"
    )
  }
}
