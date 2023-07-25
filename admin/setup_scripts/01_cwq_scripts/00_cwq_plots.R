# Create CWQ Plots

# Assign Variables -------------------------------------------------------------

# read in data
df_wq <- readr::read_csv('admin/data/cwq/data_avg_all.csv')

# remove bottom
df_wq <- df_wq %>% dplyr::filter(!grepl('_bottom', site_code))

# add month-year col
df_wq$Monyear <- paste(df_wq$month, lubridate::year(df_wq$date), sep = ' ')
df_wq$Monyear <- lubridate::my(df_wq$Monyear)

# define unique analytes
analytes <- unique(df_wq$par)

# plot names
plt_names <- c(paste0('Specific Conductance ', '(\u03bc', 'S/cm)'),
               'Turbidity (NTU)',
               paste0('Water Temperature ','(\u00B0','C)'),
               'Dissolved Ammonia (mg/L)',
               'Dissolved Nitrate+Nitrite (mg/L)',
               'Total Phosphorus (mg/L)')

# define plot theme
blank_theme <- ggplot2::theme_bw() +
  ggplot2::theme(
    panel.grid.major.x = ggplot2::element_blank() ,
    panel.grid.minor = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),
    axis.text = ggplot2::element_text(color='black', size=5, family='sans'),
    axis.text.x = ggplot2::element_text(angle = 45, vjust = 0.5, margin = ggplot2::margin(t = 1)),
    axis.title.x = ggplot2::element_blank(),
    axis.title.y = ggplot2::element_blank(),
    plot.title = ggplot2::element_text(size=7, hjust=0.5),
    legend.position = 'top',
    legend.title = ggplot2::element_blank(),
    legend.box.margin = ggplot2::margin(-10,-10,-10,-10),
    legend.text = ggplot2::element_text(size=5),
    legend.key.size = ggplot2::unit(.3, 'lines')
  )

# determine number of sites per region
df_sitenum <- df_wq %>%
  dplyr::group_by(region) %>%
  dplyr::summarize(site_code) %>%
  dplyr::distinct() %>%
  dplyr::count() %>%
  dplyr::ungroup()

site_nums <- split(x = df_sitenum$n, f = df_sitenum$region)

rm(df_sitenum)

# plot template
plt_temp <- function(m, colors, cur_region, bottom){
  y_ftsize <- 2
  x_ftsize <- 1

  if (bottom){
    p <- ggplot2::ggplot() +
      ggplot2::geom_line(m, mapping = ggplot2::aes(date, value, group = site_code, colour = site_code), na.rm = TRUE, size = 1.1) +
      blank_theme +
      ggplot2::scale_x_date(labels = scales::date_format('%b-%y'), breaks = m$Monyear) +
      ggplot2::scale_color_manual(values=colors, guide = ggplot2::guide_legend(nrow = 1)) +
      ggplot2::ggtitle(cur_region)
  } else {
    p <- ggplot2::ggplot() +
      ggplot2::geom_line(m, mapping = ggplot2::aes(date, value, group = site_code, colour = site_code), na.rm = TRUE,  size = 1.1) +
      blank_theme +
      ggplot2::theme(
        axis.text.x = ggplot2::element_text(size = x_ftsize, color = 'white'),
        axis.ticks.x = ggplot2::element_blank()
      ) +
      ggplot2::scale_x_date(labels = scales::date_format('%b-%y'), breaks = m$Monyear) +
      ggplot2::scale_color_manual(values = colors, guide = ggplot2::guide_legend(nrow = 1)) +
      ggplot2::scale_fill_manual(values = colors) +
      ggplot2::ggtitle(cur_region)
  }
  return(p)
}

# Create Plot ---------------------------------------------------------------

for (i in seq(length(analytes))){
  df_wq_filt <- df_wq %>%
    dplyr::filter(par == analytes[i])
  
  out <- by(data = df_wq_filt, INDICES = df_wq_filt$region, FUN = function(m) {
    m <- droplevels(m)
    
    cur_region = as.character(unique(m$region[[1]]))
    
    if (cur_region == 'Central Delta'){
      colors <- rev(RColorBrewer::brewer.pal(site_nums['Central Delta'][[1]], 'Blues'))

      p <- plt_temp(m = m, colors = colors, cur_region = cur_region, bottom = FALSE)
      
    } else if (cur_region == 'Confluence'){
      colors = rev(RColorBrewer::brewer.pal(site_nums['Confluence'][[1]], 'Oranges'))
      
      p <- plt_temp(m, colors, cur_region, bottom = FALSE)
      
    } else if (cur_region == 'Northern Interior Delta'){
      colors = rev(RColorBrewer::brewer.pal(3, 'Greys'))
      
      p <- plt_temp(m, colors, cur_region, bottom = FALSE)
      
    } else if (cur_region == 'Southern Interior Delta'){
      colors = rev(RColorBrewer::brewer.pal(site_nums['Southern Interior Delta'][[1]], 'Greens'))
      
      p <- plt_temp(m, colors, cur_region, bottom = FALSE)
      
    } else if (cur_region == 'Suisun & Grizzly Bay'){
      colors = rev(RColorBrewer::brewer.pal(site_nums['Suisun & Grizzly Bay'][[1]], 'Purples'))
      
      p <- plt_temp(m, colors, cur_region, bottom = FALSE)
    }
  }
  )
  
  caption <- glue::glue('{plt_names[i]} at six regions in the San Francisco Bay-Delta estuary in {report_year}.')

  graph <- gridExtra::marrangeGrob(grobs = out, ncol=2, nrow=3, top = grid::textGrob(plt_names[i],gp = grid::gpar(fontsize=9, fontface='bold')), bottom = grid::textGrob(caption, gp = grid::gpar(fontsize=7)))
  ggplot2::ggsave(paste('admin/plots/cwq/ARGraph_',analytes[i],'.jpg', sep=''), graph, width = 4.5, height = 5.3, unit = 'in')
}


