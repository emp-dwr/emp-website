# # WQ Avg Plot
# plt_phywq_avg <- function(df, region) {
#   df <- df %>%
#     dplyr::filter(Region == region) %>%
#     dplyr::mutate(Month = factor(months(Date), levels = month.name, labels = month.abb)) %>%
#     dplyr::select(c(Month, Station, Region, Chla_Sign, Chla, Pheophytin_Sign, Pheophytin)) %>%
#     dplyr::rename(
#       Chla_Value = Chla,
#       Pheophytin_Value = Pheophytin
#     )
#   
#   df <- df %>%
#     tidyr::pivot_longer(
#       cols = Chla_Sign:Pheophytin_Value,
#       names_to = c("Analyte", ".value"),
#       names_sep = "_"
#     )
#   
#   df <- df %>%
#     dplyr::group_by(Analyte, Region, Month) %>%
#     dplyr::mutate(
#       Sign = dplyr::case_when(
#         Sign == "=" ~ TRUE,
#         Sign == "<" ~ FALSE
#       )
#     )
#   
#   df <- df %>%
#     dplyr::group_by(Analyte, Region, Month) %>%
#     dplyr::summarize(
#       Value = median(Value),
#       Min_Count = sum(Sign) / dplyr::n() >= 0.5,
#       .groups = "drop"
#     ) %>%
#     dplyr::mutate(
#       Min_Count = dplyr::case_when(
#         Min_Count == TRUE ~ "yes",
#         Min_Count == FALSE ~ "no"
#       )
#     )
#   
#   p <-
#     ggplot2::ggplot(df, ggplot2::aes(Month, Value, group = Analyte, color = Analyte)) +
#     ggplot2::scale_color_manual(values = c("Chla" = "#5ab4ac", "Pheophytin" = "#d8b365"), labels = c(Chla = "Chlorophyll", Pheophytin = "Pheophytin")) +
#     ggplot2::geom_line(na.rm = TRUE, linewidth = .6) +
#     ggplot2::geom_point(na.rm = TRUE, size = 2) +
#     # ggpattern::geom_col_pattern(color = '#000000', pattern_fill = '#FFFFFF', pattern_alpha = 0.5, position = 'dodge') +
#     # ggpattern::scale_pattern_manual(values = c('no' = 'crosshatch', 'yes' = 'none'), guide = 'none') +
#     # ggplot2::scale_linetype_manual(values = c('no' = 'longdash', 'yes' = 'solid'), guide = 'none') +
#     # ggplot2::scale_alpha_manual(values = c('no' = 0.4, 'yes' = 1), guide = 'none') +
#     ggplot2::theme_bw() +
#     # ggplot2::guides(
#     #   fill = ggplot2::guide_legend(
#     #     title = ggplot2::element_blank(),
#     #     override.aes = list(pattern = c('none', 'none')))
#     #   ) +
#     ggplot2::labs(title = glue::glue("{region} Monthly Averages (WQ)"), y = "Pigment Concentration (\U03BCg/L)", x = ggplot2::element_blank()) +
#     ggplot2::theme(legend.position = "bottom", legend.margin = ggplot2::margin(-1, 0, -1, 0), plot.title = ggplot2::element_text(hjust = 0.5))
#   
#   return(p)
# }