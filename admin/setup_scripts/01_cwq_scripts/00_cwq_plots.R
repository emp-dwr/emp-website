# Create CWQ Plots

# Assign Variables -------------------------------------------------------------

# read in data
df_wq <- readr::read_csv('admin/data/cwq/data_avg_all.csv')

# add month-year col
df_wq$Monyear <- paste(df_wq$month, lubridate::year(df_wq$date), sep = ' ')
df_wq$Monyear <- lubridate::my(df_wq$Monyear)

# define unique analytes
analytes <- unique(df_wq$par)

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
  dplyr::summarize(site) %>%
  dplyr::distinct() %>%
  dplyr::count() %>%
  dplyr::ungroup()

site_nums <- split(x = df_sitenum$region, f = df_sitenum$n)

rm(df_sitenum)

# plot template
plt_temp <- function(cur_region, bottom){
  if (bottom){
    p <- ggplot2::ggplot() +
      ggplot2::geom_line(m, mapping = ggplot2::aes(Monyear, Val, group = Station, colour = Station), na.rm = TRUE, size = 1.1) +
      ggplot2::geom_point(m, mapping = ggplot2::aes(Monyear, Val, group = Station, colour = Station, shape = Station), na.rm = TRUE, size = 3) +
      blank_theme +
      ggplot2::scale_x_date(labels = date_format('%b-%y'), breaks = m$Monyear) +
      ggplot2::scale_color_manual(values=colors, guide = guide_legend(nrow = 1)) +
      ggplot2::scale_fill_manual(values=colors) +
      ggplot2::ggtitle(cur_region)
  } else {
    p <- ggplot() +
      ggplot2::geom_line(m, mapping = ggplot2::aes(Monyear, Val, group = Station, colour = Station), na.rm = TRUE,  size = 1.1) +
      ggplot2::geom_point(m, mapping = ggplot2::aes(Monyear, Val, group = Station, colour = Station, shape = Station), na.rm = TRUE, size = 3) +
      blank_theme +
      theme(
        axis.text.x = element_text(size = x_ftsize, color = 'white'),
        axis.ticks.x = element_blank()
      ) +
      ggplot2::scale_x_date(labels = date_format('%b-%y'), breaks = m$Monyear) +
      ggplot2::scale_color_manual(values = colors, guide = guide_legend(nrow = 1)) +
      ggplot2::scale_fill_manual(values = colors) +
      ggplot2::ggtitle(cur_region)
  }
}

# Create Plot ---------------------------------------------------------------

for (i in seq(length(analytes))){
  df_wq_filt <- df_wq %>%
    dplyr::filter(par == analytes[i])
  
  out <- by(data = df_wq_filt, INDICES = df_wq_filt$region, FUN = function(m) {
    m <- droplevels(m)
    cur_region = as.character(unique(m$region[[1]]))
    
    if (cur_region == 'Central Delta'){
      colors = rev(RColorBrewer::brewer.pal(site_nums['Central Delta'][[1]], 'Blues'))
      
      p <- plt_temp(cur_region, FALSE)
      
    } else if (cur_region == 'Confluence'){
      colors = rev(RColorBrewer::brewer.pal(site_nums['Confluence'][[1]], 'Oranges'))
      
      p <- plt_temp(cur_region, FALSE)
      
    } else if (cur_region == 'Northern Interior Delta'){
      colors = rev(RColorBrewer::brewer.pal(site_nums['Northern Interior Delta'][[1]], 'Greys'))
      
      p <- plt_temp(cur_region, FALSE)
      
    } else if (cur_region == 'Southern Interior Delta'){
      colors = rev(RColorBrewer::brewer.pal(site_nums['Southern Interior Delta'][[1]], 'Greens'))
      
      p <- plt_temp(cur_region, FALSE)
      
    } else if (cur_region == 'Suisun & Grizzly Bays'){
      colors = rev(RColorBrewer::brewer.pal(site_nums['Suisun & Grizzly Bays'][[1]], 'Purples'))
      
      p <- plt_temp(cur_region, TRUE)
      
    }
  }
  )
  
  my_grobs = lapply(out, ggplotGrob)
  
  graph <- marrangeGrob(grobs = out, ncol=2, nrow=3, top=textGrob(plt_names[i],gp=gpar(fontsize=16, fontface='bold')))
  # ggsave(paste('01_WaterQuality/annual-reports/Graphs/ARGraph_',analytes[i],'.jpg', sep=''), graph, width = 9.5, height = 10.5, unit = 'in') #4.7, 19
}


