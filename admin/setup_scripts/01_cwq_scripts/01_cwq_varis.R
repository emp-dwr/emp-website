# random variables --------------------------------------------------------

# read in data
df_cwq_raw <- readr::read_csv('admin/data/cwq/data_avg_all.csv', show_col_types = FALSE)

# number of sites
site_number <- length(unique(df_cwq_raw$site))

# summary statistics
df_sumstats <- calc_sumstats(df_cwq_raw)
