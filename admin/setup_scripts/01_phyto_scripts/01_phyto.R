# download data from EDI (assumption is all data will be downloaded for all; not great, but for now)
df_phyto_raw <- get_edi_file(1320, glue::glue('EMP_Phyto_Data_2008-{report_year}'))
df_phyto_raw <- df_phyto_raw[[1]]

df_phyto_raw$AlgalGroup[df_phyto_raw$AlgalGroup == 'Green Alga'] <- 'Green Algae'
df_phyto_raw$AlgalGroup[df_phyto_raw$AlgalGroup == 'Raphidophyte'] <- 'Raphidophytes'
df_phyto_raw$AlgalGroup[df_phyto_raw$AlgalGroup == 'Cryptophyte'] <- 'Cryptophytes'

df_phyto_year <- subset_year(df_phyto_raw, report_year)

# download data from EDI (assumption is all data will be downloaded for all; not great, but for now)
# Note: need d-wq data for chla and pheophytin
df_wq_raw <- get_edi_file(458, glue::glue('EMP_DWQ_1975_{report_year}'))
df_wq_raw <- df_wq_raw[[1]]

df_wq_year <- subset_year(df_wq_raw, report_year)


# clean data functions ----------------------------------------------------

#' Assign regions to stations
#'
#' @param df the relevant data frame
#'
assign_regions <- function(df){
  if ('Station' %in% colnames(df)){
    df <- df %>% dplyr::mutate(
      Region = dplyr::case_when(
        Station == 'D16' | Station == 'D19' | Station == 'D26' | Station == 'D28A' ~ 'Central Delta',
        Station =='D10' | Station == 'D12' | Station == 'D22' | Station == 'D4' ~ 'Confluence',
        Station =='C3A' | Station == 'NZ068' ~ 'Northern Interior Delta',
        Station =='D41' | Station == 'D41A' | Station == 'D6' | Station == 'NZ002' | Station == 'NZ004' | Station == 'NZ325' ~ 'San Pablo Bay',
        Station == 'C10A' | Station == 'C9' | Station == 'MD10A' | Station == 'P8' ~ 'Southern Interior Delta',
        Station == 'D7' | Station == 'D8' | Station == 'NZ032' | Station == 'NZS42' ~ 'Suisun & Grizzly Bays'
      )
    )    
  } else{
    df <- df %>% dplyr::mutate(
      Region = dplyr::case_when(
        StationCode == 'D16' | StationCode == 'D19' | StationCode == 'D26' | StationCode == 'D28A' ~ 'Central Delta',
        StationCode =='D10' | StationCode == 'D12' | StationCode == 'D22' | StationCode == 'D4' ~ 'Confluence',
        StationCode =='C3A' | StationCode == 'NZ068' ~ 'Northern Interior Delta',
        StationCode =='D41' | StationCode == 'D41A' | StationCode == 'D6' | StationCode == 'NZ002' | StationCode == 'NZ004' | StationCode == 'NZ325' ~ 'San Pablo Bay',
        StationCode == 'C10A' | StationCode == 'C9' | StationCode == 'MD10A' | StationCode == 'P8' ~ 'Southern Interior Delta',
        StationCode == 'D7' | StationCode == 'D8' | StationCode == 'NZ032' | StationCode == 'NZS42' ~ 'Suisun & Grizzly Bays'
      )
      )
  }
    
  return(df)
}

# clean data --------------------------------------------------------------

df_phyto <- assign_regions(df_phyto_raw)
df_wq <- assign_regions(df_wq_raw)


# basic info --------------------------------------------------------------

#' Determine all Algal Groups
#' 
#' Determine all algal groups and return either their names or the # of elements
#' 
#' @param df the relevant data frame
#'
#' @param type output type
#' 
#' @col the column that contains the groupings
#'
bio_groups <- function(df, type, col){
  groups <- unique(df[col] %>% dplyr::pull())
  
  if (type == 'groups'){
    output <- groups
  } else if (type == 'num'){
    output <- length(groups)
  }
  
  return(output)
}

#' Determine all 10 most common genera
#' 
#' @param df the relevant data frame
#'
top_genus <- function(df){
  df <- subset_year(df, report_year)
  
  # add and arrange by count data
  df <- df %>%
    dplyr::group_by(Genus) %>%
    dplyr::add_count() %>%
    dplyr::rename(Count = n) %>%
    dplyr::distinct(Genus, AlgalGroup, Count) %>%
    dplyr:: relocate(Genus, AlgalGroup, Count) %>%
    dplyr::arrange(desc(Count)) %>%
    dplyr::ungroup()
  
  # remove unknown from list
  df <- df %>%
    dplyr::filter(!grepl('Unknown', Genus))
  
  # cut off at top 10
  df <- df[1:10,]
  
  return(df)
}

#' Determine number of samples
#'
#' @param df the relevant data frame
#'
sample_number <- function(df) {
  df <- subset_year(df, report_year)

  df <- df %>%
    dplyr::group_by(SampleDate, StationCode) %>%
    dplyr::summarize() %>%
    dplyr::distinct()
  
  return(nrow(df))
}


# Plots ------------------------------------------------------
#' Create Main Algal Group df
#' TODO: later
#' 
alg_dfs <- function(df, type){
  df_comp <- df %>%
    dplyr::mutate(
      AlgalGroup =
        dplyr::case_when(grepl('Diatoms', AlgalGroup) ~ 'Diatoms',
                         TRUE ~ AlgalGroup)
    ) %>%
    dplyr::group_by(AlgalGroup) %>%
    dplyr::summarise(tot = nrow(.),
                     count = dplyr::n(),
                     per = 100*(dplyr::n() / nrow(.))) %>%
    dplyr::distinct()
  
  if(type == 'raw'){
    df_return <- df_comp
  
  } else if (type == 'main'){
    df_comp_main <- df_comp %>%
      dplyr::mutate(
        AlgalGroup = dplyr::case_when(per < 5 ~ 'Other',
                                      TRUE ~ AlgalGroup)
      ) %>%
      dplyr::group_by(AlgalGroup) %>%
      dplyr::summarise(per = sum(per)) %>%
      dplyr::distinct()
    
    df_return <- df_comp_main
    
  } else if (type == 'other'){
    few_taxa <- df_comp$AlgalGroup[df_comp$per < 5]
    
    df_comp_sub <- df %>%
      dplyr::filter(AlgalGroup %in% few_taxa) %>%
      dplyr::group_by(AlgalGroup) %>%
      dplyr::summarise(tot = nrow(.),
                       count = dplyr::n(),
                       per_other = 100*(dplyr::n() / nrow(.))) %>%
      dplyr::distinct() %>%
      dplyr::left_join(., df_comp, by = c('AlgalGroup','count'))
    
    df_return <- df_comp_sub
  }
  
  return(df_return)
}


#' Create Algal Plots
#' TODO: fill in later
#' 
algal_plts <- function(type){
  if (type == 'main'){
    df_comp_main <- alg_dfs(df_phyto_year, 'main')
    
    p <- ggplot2::ggplot(df_comp_main, ggplot2::aes(area = per, fill = AlgalGroup, label = paste0(AlgalGroup,'\n',round(per,1),'%'), subgroup = AlgalGroup))+
      treemapify::geom_treemap(layout = 'squarified') +
      treemapify::geom_treemap_text(place = 'center', size = 14)+
      ggplot2::scale_fill_brewer(palette = 'Set2') +
      treemapify::geom_treemap_subgroup_border(color = 'black', size = 1) +
      ggplot2::ggtitle('Main Algal Groups') +
      ggplot2::theme(legend.position = 'none', plot.title = ggplot2::element_text(face = 'bold', size = 16, hjust = 0.5))
    
  } else if (type == 'other'){
    df_comp_sub <- alg_dfs(df_phyto_year, 'other')
    
    p <- ggplot2::ggplot(df_comp_sub, ggplot2::aes(area = per_other, fill = AlgalGroup, label = paste0(AlgalGroup,'\n',round(per,2),'%'), subgroup = AlgalGroup))+
      treemapify::geom_treemap(layout = 'squarified') +
      treemapify::geom_treemap_text(place = 'center', size = 14, color = 'white')+
      ggplot2::theme(legend.position = 'none') +
      ggplot2::scale_fill_brewer(palette = 'Dark2') +
      treemapify::geom_treemap_subgroup_border(color = 'black', size = 1) +
      ggplot2::ggtitle('"Other" Algal Groups') +
      ggplot2::theme(legend.position = 'none', plot.title = ggplot2::element_text(face = 'bold', size = 16, hjust = 0.5))
  }
return(p)
}

