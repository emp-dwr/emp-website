# Read in CWQ Tables

# station table -------------------------------------------------------------

cwq_stations <- readr::read_csv('admin/figures/cwq/table_cwq_stations.csv')


# param table -------------------------------------------------------------

table_params <- readr::read_csv('admin/figures/cwq/table_params.csv')


# region tables -----------------------------------------------------------


nid <- readr::read_csv('admin/data/cwq/sumstats_Northern Interior Delta.csv')

sid <- readr::read_csv('admin/data/cwq/sumstats_Southern Interior Delta.csv')

cid <- readr::read_csv('admin/data/cwq/sumstats_Central Delta.csv')

conf <- readr::read_csv('admin/data/cwq/sumstats_Confluence.csv')

grizzly <- readr::read_csv('admin/data/cwq/sumstats_Suisun & Grizzly Bay.csv')