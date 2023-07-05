# download data from EDI (assumption is all data will be downloaded for all; not great, but for now)
df_raw <- get_edi_file(1036, glue::glue('DWR Benthic CPUE data 1975-{report_year}'))
df_rawcount <- df_raw[[1]]
df_cpue <- df_raw[[1]]
