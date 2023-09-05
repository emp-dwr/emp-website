
# Print Lists -------------------------------------------------------------

#' Algal Group List
#' 
#' Create the bullet point 'top algal groups' list
#' 

alg_list_txt <- function(){
  alg_num <- bio_groups(df_phyto_year, 'num', 'AlgalGroup')
  alg_group <- bio_groups(df_phyto_year, 'groups', 'AlgalGroup')
  
  # concatenate diatoms
  if (('Pennate Diatoms' %in% alg_group) & ('Centric Diatoms' %in% alg_group)){
    alg_group <- alg_group[!alg_group %in% c('Pennate Diatoms','Centric Diatoms')]
    alg_group <- c('Diatoms (Pennate and Centric)', alg_group)
  }
  
  # sort list
  alg_group <- sort(alg_group)

  # create list  
  alg_list <- bullet_list(alg_group)
  
  output <- glue::glue('All organisms collected in {report_year} fell into these {alg_num} algal groups:<br />
                          {alg_list}<br />')
  
  return(output)
}

#' Genus Group List
#' TODO: fill out
#'

#' Top Genus List
#' TODO: later
#' 
gen_list_txt <- function(){
  df_genus <- top_genus(df_phyto_year)
  
  gen_group <- bio_groups(df_genus, 'groups', 'Genus')
  alg_group <- bio_groups(df_genus, 'groups', 'AlgalGroup')
  comb_group <- paste0(gen_group,' (', alg_group, ')')
  alg_list <- bullet_list(comb_group)
  
  output <- glue::glue('The 10 most common genera collected in {report_year} were, in order:<br />{alg_list}<br />')
  
  return(output)
}

#' Algal Percent Text
#' TODO: later
#' 

alg_per_txt <- function() {
  alg_num <- bio_groups(df_phyto_year, 'num', 'AlgalGroup')
  
  df_alg_per <- alg_dfs(df_phyto_year, 'main') %>%
    dplyr::filter(!c(AlgalGroup == 'Other'))
  
  alg_per <- df_alg_per %>%
    dplyr::summarize(per = sum(per))
  alg_per <- round(alg_per[[1]], 1)
  
  alg_str <- knitr::combine_words(tolower(df_alg_per$AlgalGroup))
  
  output <-
    glue::glue(
      'Of the {alg_num} groups identified, {alg_str} constituted the vast majority ({alg_per}%) of the organisms collected.'
    )
  
  return(output)
}

# Chla Texts --------------------------------------------------------------

#' low chla text
#' TODO: fill out
#' 

low_chla_txt <- function() {
  sample_num <- sample_number(df_phyto_year)
  percent <- low_chla(df_wq_year, 'percent')
  count <- low_chla(df_wq_year, 'count')
  output <- glue::glue('Of the {sample_num} samples taken in {report_year}, {percent}% ({count} samples) had chlorophyll a levels below 10 \U03BCg/L.')
  return(output)
}


high_chla_txt <- function() {
  count <- low_chla(df_wq_year, 'inverse')
  high_chla_suffix <- high_chla_stations()
  output <- glue::glue('Of the {count} samples with chlorophyll a concentrations equal to or above 10 \U03BCg/L, {high_chla_suffix}')
  return(output)
}

chla_txt_pre <- function(){
  low_txt <- low_chla_txt()
  high_txt <- high_chla_txt()
  output <- glue::glue('{low_txt} Chlorophyll a levels below 10 \U03BCg/L are considered limiting for zooplankton growth (M\U00FCller-Solger et al., 2002). {high_txt}')
  return(output)
}

chla_txt <- function(){
  color = ifelse(autogen_color, 'red', '#585858')
  kableExtra::text_spec(chla_txt_pre(), color = color)
}
  
#' Computes various statistics and creates a string for use in reports
#'
#' @param df the relevant data frame
#' @param nutrient the nutrient column name (as string) to pull data from
#' @param stat the function to apply to the data. choices are: min, max, etc.
#' @param output the type of output string desired. choices are: min, max, etc.
#'

chlapheo_stats_report <- function(df, nutrient, year, statistic){
  df_vari <- chlapheo_stats(df, nutrient, year, statistic)
  
  vari_num <- chlapheo_output(df_vari, nutrient, year, 'value')
  vari_meta <- chlapheo_output(df_vari, nutrient, year, 'metadata')
  
  if (year == report_year){
    output <- paste0(vari_num,' \U03BC/L ',vari_meta)
  } else {
    output <- vari_num
  }
  
  return(output)
}

#' yeah
#' TODO: later
#' 

chlapheo_sumstats <- function(nutr, stat) {
  if (stat == 'below rl') {
    nrow_below <- nrow(chlapheo_stats(df_wq_raw, nutr, report_year, 'under rl'))
    out <- glue::glue('{nrow_below} samples were below the reporting limit.')
  } else {
    if (stat == 'median all') {
      ry_num <- chlapheo_stats(df_wq_raw, nutr, report_year, stat)
      ry_num <- paste(ry_num, '\U03BCg/L.')
      comp_txt <- stat_compare(nutr, stat)
      py_num <- chlapheo_stats(df_wq_raw, nutr, prev_year, stat)
    } else {
      ry_num <- chlapheo_stats_report(df_wq_raw, nutr, report_year, stat)
      comp_txt <- stat_compare(nutr, stat)
      py_num <- chlapheo_stats_report(df_wq_raw, nutr, prev_year, stat)
    }
    
    if (stat == 'median all') {
      stat_name <- 'median'
    } else if (stat == 'max') {
      stat_name <- 'max'
    } else if (stat == 'min') {
      stat_name <- 'min'
    }
    
    out <- glue::glue('{ry_num} This is {comp_txt} ({stat_name} = {py_num} \U03BCg/L)')
  }
  
  return(out)
}

#' yeah
#' TODO: later
#'

stat_txt_pre <- function(nutr){
  if(nutr == 'Chla'){
    cur_nutr <- 'chlorophyll a'
  } else if (nutr == 'Pheophytin'){
    cur_nutr <- 'pheophytin a'
  }
  
  med_val <- chlapheo_sumstats(nutr,'median all')
  med_out <- glue::glue('The median {cur_nutr} concentration for all samples in {report_year} was {med_val}.')
  
  max_val <- chlapheo_sumstats(nutr,'max')
  max_out <- glue::glue('The maximum {cur_nutr} concentration in {report_year} was {max_val}.')
  
  min_val <- chlapheo_sumstats(nutr, 'min')
  min_out <- glue::glue('The minimum {cur_nutr} concentration in {report_year} was {min_val}.')
  
  bel_out <- chlapheo_sumstats(nutr,'below rl')
  
  out <- glue::glue('{med_out} {max_out} {min_out} {bel_out}')
  
  return(out)
}


stat_txt <- function(nutr){
  color = ifelse(autogen_color, 'red', '#585858')
  kableExtra::text_spec(stat_txt_pre(nutr), color = color)
}