
suppressMessages({library(dplyr)
library(tidyr)
library(readr)
library(here)
library(lubridate)
library(jsonlite)})

df_stations <- read_csv(here('admin/figures-tables/special-studies/Mussel_Station_Metadata.csv'), show_col_types = FALSE)
sightings <- fromJSON(readLines(here('admin/test-data/mussel_data.json')))

sightings <- sightings %>%
  mutate(
    Date = as.Date(as.numeric(Date) - 25569, origin = '1970-01-01'),
    month_year = format(Date, '%b %Y')
  ) %>%
  select(-c('@odata.etag','After submitting this form, report the new sighting to the CDFW website')) %>%
  rename('Description' = 'Description (e_x002e_g_x002e_, found on sonde body)')

current_month <- as.Date(format(Sys.Date(), '%Y-%m-01')) - months(1)
month_starts <- sort(seq(from = current_month, by = '-1 month', length.out = 12))

month_year_index <- tibble(
  month_start = month_starts,
  month_year = format(month_start, '%b %Y'),
  month_year_idx = seq_along(month_starts)
)

# keep only the most recent sighting within each station-month
sighting_flags <- sightings %>%
  group_by(Station, month_year) %>%
  slice_max(Date, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  select(
    Station,
    Date,
    month_year,
    `Approximate Quantity`
  )

# for each displayed frame month, find the most recent sighting up to that month
last_sighting_by_frame <- crossing(
  Station = unique(df_stations$`Station Acronym`),
  month_start = month_starts
) %>%
  left_join(month_year_index, by = 'month_start') %>%
  left_join(
    sighting_flags %>%
      select(Station, sighting_date = Date),
    by = 'Station',
    relationship = 'many-to-many'
  ) %>%
  group_by(Station, month_start, month_year, month_year_idx) %>%
  summarize(
    last_sighting_date = {
      valid_dates <- sighting_date[sighting_date <= month_start + months(1) - days(1)]
      if (length(valid_dates) == 0) as.Date(NA) else max(valid_dates)
    },
    .groups = 'drop'
  )

frames_data <- crossing(
  df_stations %>% select(`Station Acronym`, `Station Name`, Latitude, Longitude),
  month_start = month_starts
) %>%
  left_join(month_year_index, by = 'month_start') %>%
  left_join(
    sighting_flags,
    by = c('Station Acronym' = 'Station', 'month_year')
  ) %>%
  left_join(
    last_sighting_by_frame,
    by = c('Station Acronym' = 'Station', 'month_start', 'month_year', 'month_year_idx')
  ) %>%
  mutate(
    rri_unknown_previous = `Station Acronym` == 'RRI' &
      month_year %in% c('Apr 2025', 'May 2025', 'Jun 2025', 'Jul 2025', 'Aug 2025', 'Sep 2025', 'Oct 2025', 'Nov 2025'),
    
    has_current_month_sighting = !is.na(`Approximate Quantity`),
    has_previous_sighting = !is.na(last_sighting_date) & !has_current_month_sighting,
    
    category = case_when(
      rri_unknown_previous ~ 'Previous Sightings',
      `Approximate Quantity` == '100+' ~ '100+ Mussels',
      `Approximate Quantity` == '50-100' ~ '50-100 Mussels',
      has_current_month_sighting ~ '1-50 Mussels',
      has_previous_sighting ~ 'Previous Sightings',
      TRUE ~ 'No Sightings'
    ),
    marker_color = case_when(
      category == '100+ Mussels' ~ '#b30000',
      category == '50-100 Mussels' ~ '#fc8d59',
      category == '1-50 Mussels' ~ '#fdd49e',
      category == 'Previous Sightings' ~ '#4C78A8',
      TRUE ~ 'lightgray'
    ),
    hover_text = case_when(
      rri_unknown_previous ~ paste0(
        `Station Name`, ' (', `Station Acronym`, ')<br>',
        'Previous Sightings<br>',
        'Last Sighting: Unknown'
      ),
      is.na(last_sighting_date) ~ paste0(
        `Station Name`, ' (', `Station Acronym`, ')<br>',
        category
      ),
      TRUE ~ paste0(
        `Station Name`, ' (', `Station Acronym`, ')<br>',
        category, '<br>',
        'Last Sighting: ', format(last_sighting_date, '%m/%d/%Y')
      )
    )
  ) %>%
  select(-month_start, -rri_unknown_previous, -has_current_month_sighting, -has_previous_sighting) %>%
  arrange(`Station Acronym`, month_year_idx)

saveRDS(list(frames_data = frames_data, df_stations = df_stations), here('admin/test-data/mussel_frames_data.rds'))