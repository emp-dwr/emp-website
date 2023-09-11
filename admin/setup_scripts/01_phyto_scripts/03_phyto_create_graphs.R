if(create_phyto_graphs){
  uni_regions <- unique(df_phyto$Region)[!is.na(unique(df_phyto$Region))]
  for (region in uni_regions){
    region_wq_plts(region)
    region_phyto_plts(region)
  }
}