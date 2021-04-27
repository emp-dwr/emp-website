--- 
site: bookdown::bookdown_site
output: pdf_document
title: 'EMP Annual Reports'
number_sections: FALSE
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: emp-des/emp-reports
description: 'These reports shows trends in discrete water quality, benthic invertebrates, phytoplankton, and zooplankton collected by EMP.'
---


<img src="figures/general/emp-pic-1.png" width="20%" height="20%" style="display: block; margin: auto;" /><img src="figures/general/emp-pic-2.png" width="20%" height="20%" style="display: block; margin: auto;" /><img src="figures/general/emp-pic-3.jpg" width="20%" height="20%" style="display: block; margin: auto;" />

## Program Information
<b>THIS IS A TEST SITE!</b> For official annual EMP reports, please contact Sarah Perry at sarah.perry@water.ca.gov.

The State Water Resources Control Board (SWRCB) sets water quality objectives to protect beneficial uses of water in the Sacramento-San Joaquin Delta and Suisun and San Pablo Bays. These objectives are met by establishing standards mandated in water right permits issued to the Department of Water Resources and U.S. Bureau of Reclamation by the SWRCB. The standards include minimum Delta outflows, limits to Delta water export by the State Water Project (SWP) and the Central Valley Project (CVP), and maximum allowable salinity levels. 

In 1971, the State Water Resources Control Board (SWRCB) established Water Right Decision 1379 (D-1379). This Decision contained new water quality requirements for the San Francisco Bay-Delta Estuary. D-1379 was also the first water right decision to provide terms and conditions for a comprehensive monitoring program to routinely determine water quality conditions and changes in environmental conditions within the estuary. The monitoring program described in D-1379 was developed by the Stanford Research Institute through a contract with the SWRCB. Implementation of the monitoring program began in 1972, as SWRCB, DWR, and USBR met to define their individual responsibilities for various elements of the monitoring program. In 1978, amendments to water quality standards were implemented and resulted in Water Right Decision 1485 (D-1485). These standards were again amended under the 1995 Water Quality Control Plan and Water Right Decision 1641 (D-1641) established in 1999. The SWP and CVP are currently operated to comply with the monitoring and reporting requirements described in D-1641. D-1641 requires DWR and USBR to conduct a comprehensive environmental monitoring program to determine compliance with the water quality standards and also to submit an annual report to the SWRCB discussing data collected. 

More information about EMP and its connection to the Interagency Ecological Program (IEP) can be found [here](https://water.ca.gov/Programs/Environmental-Services/Interagency-Ecological-Program).

<div class="figure" style="text-align: center">
<img src="figures/general/deltamap.jpg" alt="Map of the Sacramento-San Joaquin Delta. Source: DWR" width="400px" />
<p class="caption">(\#fig:unnamed-chunk-3)Map of the Sacramento-San Joaquin Delta. Source: DWR</p>
</div>



<!--chapter:end:index.Rmd-->

---
  html_document: 
    code_folding: hide
    toc: true
    toc_depth: 1
    toc_float:
      collapsed: true
editor_options: 
  chunk_output_type: console
---

# Discrete Water Quality {#dwq}

### Background
There are 24 fixed discrete stations within the San Francisco Estuary that are monitored at high water slack tide. The stations are primarily accessed by the Research Vessel Sentinel, or vehicle transport. Discrete sampling is completed once a month due to the intensity of collecting a wide collection of physical parameters (e.g. water temperature) and grab samples for laboratory analysis (e.g. nitrogen and phosphorous). The data from the discrete sampling is helpful to document long-term changes within the estuary.  

### Analytes {.unlisted .unnumbered}
EMP collects data on x different analytes. The ones highlighted in this report are:

  * Specific Conductance
  * Turbidity
  * Dissolved Ammonia
  * Chlorophyll a
  * Dissolved Nitrate+Nitrite
  * Total Phosphorus

### Sites {.unlisted .unnumbered}
To analyze discrete water quality trends from 2019, the EMP stations were grouped into six regions of the San Francisco Bay-Delta estuary: San Pablo Bay, Suisun and Grizzly Bay, Confluence, Central Delta, Southern Interior Delta, and Northern Interior Delta. Their locations are displayed below.  

<div class="figure" style="text-align: center">
<img src="figures/wq_graphs/d-wq_station_map.jpg" alt="Map of EMP's field sites." width="1650" />
<p class="caption">(\#fig:unnamed-chunk-4)Map of EMP's field sites.</p>
</div>

<!--chapter:end:01-dwq-intro.Rmd-->

---
  html_document: 
    code_folding: hide
    toc: true
    toc_depth: 1
    toc_float:
      collapsed: false
editor_options: 
  chunk_output_type: console
---

## Current Report {#dwq-report}

### Introduction {.unlisted .unnumbered}

Water year 2019 was classified as Above Average in the Sacramento Valley and San Joaquin Valley, unlike the previous year, which was classified as Below Average. More information about water year types can be found on the hydrology page. The 2018-2019 data from all stations within the same region were plotted on one graph and then combined with the graphs from other regions to make a facet graph for each parameter. The minimum and maximum values in 2019 were determined for each field parameter or laboratory analyte to show the range within a single year. The instances when a result fell below the reporting limit were excluded from these minimum and maximum calculations. When this occurred, a vertical dashed line capped at the reporting limit was added to the graph to represent the presence of a non-detect. 


***
### Specific Conductance

Specific conductance varied greatly in 2019 across the sampling regions with the highest levels occurring in the western regions (San Pablo Bay, Suisun Bay and Grizzly Bay and Confluence) where water from the Pacific Ocean has the strongest influence. Specific conductance ranged from 77.8 µS/cm (C10A in Southern Interior Delta, June) to 41,956 µS/cm (D41 in San Pablo Bay, November) during 2019. Lower specific conductance values were seen in 2019 than compared to 2018, which was likely due to increased precipitation and runoff during a wet year, keeping the San Francisco Estuary fresher throughout the year. 

<div class="figure" style="text-align: center">
<img src="figures/wq_graphs/ARGraph_SpCndSurface.jpg" alt="Surface specific conductance in µS/cm at six regions in the San Francisco Bay-Delta estuary during 2018-2019." width="1425" />
<p class="caption">(\#fig:unnamed-chunk-6)Surface specific conductance in µS/cm at six regions in the San Francisco Bay-Delta estuary during 2018-2019.</p>
</div>
***
### Turbidity

Turbidity values ranged from 0.3 NTU (MD10A in Southern Interior Delta, April) to 142.3 NTU (NZ325 in San Pablo Bay, February) during 2019.  The year 2019 had much higher levels of turbidity than in 2018, especially during the winter months in the northern and western regions when rain and snowpack runoff occurred more frequently and to a much larger degree in the watershed. All six regions experienced a spike in turbidity in February 2019 when the first set of big storms hit, causing higher flows throughout the estuary and therefore a higher likelihood of increased sediment disturbance.   

<div class="figure" style="text-align: center">
<img src="figures/wq_graphs/ARGraph_TurbiditySurface.jpg" alt="Surface turbidity in NTU at six regions in the San Francisco Bay-Delta estuary during 2018-2019." width="1425" />
<p class="caption">(\#fig:unnamed-chunk-7)Surface turbidity in NTU at six regions in the San Francisco Bay-Delta estuary during 2018-2019.</p>
</div>
***
### Dissolved Ammonia

Dissolved ammonia levels in 2019 ranged from ≤ 0.05 mg/L (which is the reporting limit) to 0.75 mg/L (C3A in Northern Interior Delta, November). Dissolved ammonia levels are typically higher at C3A in the Northern Interior Delta due to its location downstream of the effluent discharge from Sacramento Regional Sanitation District. Ammonia levels are typically lower throughout the Delta and Bays, likely due to dilution and nitrification. More non-detects were seen in 2019 compared to 2018, but this was in fact due to the reporting limit increasing from 0.01 mg/L to 0.05 mg/L and was not necessarily a product of lower concentrations.  

<div class="figure" style="text-align: center">
<img src="figures/wq_graphs/ARGraph_DissAmmonia.jpg" alt="Dissolved ammonia concentrations in mg/L at six regions in the San Francisco Bay-Delta estuary during 2018-2019. Dashed lines represent the range of possible values for months where the raw value was a non-detect." width="1425" />
<p class="caption">(\#fig:unnamed-chunk-8)Dissolved ammonia concentrations in mg/L at six regions in the San Francisco Bay-Delta estuary during 2018-2019. Dashed lines represent the range of possible values for months where the raw value was a non-detect.</p>
</div>
***
### Chlorophyll a

Chlorophyll a values in 2019 ranged from ≤ 0.5 µg/L (which is the reporting limit) to 38.1 µg/L (C10A in Southern Interior Delta, July). The highest levels of chlorophyll a were seen in the Southern Interior Delta region during the summer months in 2019. This was mostly due to elevated levels at station C10A, which is known for being shallow during dry periods of the year (as low as 3.5 feet in 2019), with increased temperatures and lower flows allowing for increased phytoplankton production. These elevated chlorophyll a levels in the summer at C10A also align with the continuous fluorescence data collected at this station. More information about the phytoplankton genera is described in the phytoplankton section. Chlorophyll levels were consistently lower in 2019 than 2018 for all regions, as most regions saw a spike in chlorophyll in Spring 2018 that did not occur in 2019.  

<div class="figure" style="text-align: center">
<img src="figures/wq_graphs/ARGraph_Chla.jpg" alt="Chlorophyll a concentrations in µg/L at six regions in the San Francisco Bay-Delta estuary during 2018-2019. Dashed lines represent the range of possible values for months where the raw value was a non-detect." width="1425" />
<p class="caption">(\#fig:unnamed-chunk-9)Chlorophyll a concentrations in µg/L at six regions in the San Francisco Bay-Delta estuary during 2018-2019. Dashed lines represent the range of possible values for months where the raw value was a non-detect.</p>
</div>
***
### Dissolved Nitrate + Nitrite

Dissolved nitrate + nitrite values ranged from ≤ 0.05 mg/L (which is the lowest reporting limit) to 3.6 mg/L (P8 in Southern Interior Delta, January) in 2019. The Southern Interior Delta region had the highest fluctuation of dissolved nitrate + nitrite concentrations and had the highest levels compared to the rest of the estuary, likely due to influence from nearby agricultural land use and wastewater treatment effluent. Most regions saw a spike in dissolved nitrate + nitrite in late 2018 to early 2019, but all regions saw less variability in 2019 compared to 2018. Reporting limits for dissolved nitrate + nitrate were as high as 7.5 and 15 mg/L for western regions in late 2019 due to chloride influence on the analytical method. These reporting limits were cropped out of graphs for scale. The dissolved nitrate + nitrite values for D4 in January and D10 in November were removed from the graphs because they were outliers. 

<div class="figure" style="text-align: center">
<img src="figures/wq_graphs/ARGraph_DissNitrateNitrite.jpg" alt="Dissolved nitrate and nitrite concentrations in mg/L at six regions in the San Francisco Bay-Delta estuary during 2018-2019. Dashed lines represent the range of possible values for months where the raw value was a non-detect." width="1425" />
<p class="caption">(\#fig:unnamed-chunk-10)Dissolved nitrate and nitrite concentrations in mg/L at six regions in the San Francisco Bay-Delta estuary during 2018-2019. Dashed lines represent the range of possible values for months where the raw value was a non-detect.</p>
</div>
***
### Total Phosphorus

In 2019, total phosphorous levels ranged from 0.04 mg/L (C3A in Northern Interior Delta-June, NZ068 in Northern Interior Delta-May, and D19 in Central Delta-May, D22 in Confluence-July) to 0.37 mg/L (P8 in Southern Interior Delta, January). Total phosphorus concentrations were similar in 2019 compared to 2018 in most regions except for the Southern Interior Delta, which experienced lower levels in 2019. This was likely due to increased precipitation and more water moving through the system causing dilution.  The total phosphorus value for NZ002 in April was removed from the graph because it was an outlier.

<div class="figure" style="text-align: center">
<img src="figures/wq_graphs/ARGraph_TotPhos.jpg" alt="Total phosphorous concentrations in mg/L at six regions in the San Francisco Bay-Delta estuary during 2018-2019. Dashed lines represent the range of possible values for months where the raw value was a non-detect." width="1425" />
<p class="caption">(\#fig:unnamed-chunk-11)Total phosphorous concentrations in mg/L at six regions in the San Francisco Bay-Delta estuary during 2018-2019. Dashed lines represent the range of possible values for months where the raw value was a non-detect.</p>
</div>

<!--chapter:end:02-dwq-report.Rmd-->

## Data and Contact Info

### Data {.unlisted .unnumbered}
EMP's discrete water quality data sets are available publically via the Environmental Data Initiative (EDI) [here](https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier=458&revision=3).

### Archived Reports {.unlisted .unnumbered}
Archived annual reports can be found [here]() (link currently broken).

### Contact Information {.unlisted .unnumbered}
For questions related to EMP's discrete water quality data sets, please contact Morgan Martinez at morgan.martinez@water.ca.gov.


<!--chapter:end:03-dwq-data.Rmd-->

---
  html_document: 
    code_folding: hide
    toc: true
    toc_depth: 1
    toc_float:
      collapsed: true
editor_options: 
  chunk_output_type: console
---

# Benthic {#benthic}

### Background
Benthic organisms are creatures that live at the bottom of water bodies. This includes invertebrates (animals without backbones) like clams, shrimp, crabs, worms, aquatic insects, and small crustaceans called amphipods.  Some benthic organisms live in or on the soft mud of the San Francisco Estuary, while others attach themselves to rocks and other hard surfaces. There are also benthic vertebrates (animals with backbones) that include various fish species.

Benthic organisms are a central part of the estuarine food web, consuming and consumed by other creatures. Every winter during low-tides, thousands of migrating shorebirds feast upon uncovered clams, crabs, and worms found in the mudflats. Humans can also take advantage of the low tides to harvest these organisms. Certain fish species, including juvenile salmon, striped bass, and sturgeon, also consume many types of benthic organisms.

A large percentage of the benthic organisms found in the San Francisco Estuary are non-native, and some of these species can have negative effects on the health of the estuary. For example, non-native clams can filter out much of the available phytoplankton, outcompeting the zooplankton who in turn are major sources of fish food.  Historically, shrimp supported a large commercial fishery in San Francisco Estuary, and California’s commercial Dungeness crab fishery still depends upon crabs that spend the first two years of their life growing in the San Francisco Estuary.

Changes in benthic organisms’ populations can be indications of larger changes in the physical conditions and water quality of the San Francisco Estuary, including alterations in pollution levels, freshwater inflows, salinity, and sediment composition.

### Monitoring {.unlisted .unnumbered}
The Environmental Monitoring Program (EMP) has been sampling benthic invertebrates in the San Francisco Estuary since 1975.  The benthic monitoring program is one element of DWR’s and USBR’s Environmental Monitoring Program (EMP) conducted under the Interagency Ecological Program (IEP) umbrella. The EMP also includes monitoring of water quality, zooplankton and phytoplankton. The overall objective of the benthic monitoring program is to determine the impacts of water project operations on the estuary. These impacts are interpreted by changes in benthic fauna presence, abundance and distribution associated physical factors in the estuary. Data collected from the benthic monitoring program is also used to detect newly introduced species in the estuary. 

Geographic coverage of the sampling sites ranges from San Pablo Bay east through the upper Estuary to the mouths of the Sacramento, Mokelumne and San Joaquin rivers (see Figure 1). The study area currently comprises ten sites that are sampled monthly. These sites represent a wide variety of habitats that vary in size and physical make-up as well as water quality and sediment composition. The aquatic habitats sampled range from narrow, freshwater channels in the Delta to broad, estuarine bays. The mixing of river water with tidal water creates a wide range of water quality conditions. For example, salinity ranges from freshwater to around 29 ppt in the most western sites. 

A 0.052 m2 Ponar dredge is used to sample the benthic sediment, and all organisms larger than 0.5 mm are identified and enumerated by taxonomy contractors.  To date, 414 species in ten phyla (Cnidaria, Platyhelminthes, Nemertea, Nematoda, Annelida, Arthropoda, Mollusca, Chordata, Phoronida and Echinodermata) have been collected from the study area. Sediment composition data are also collected as part of the benthic monitoring program to document general trends in sediment composition for all sites where benthic samples are collected. 

### All Sites {.unlisted .unnumbered}
EMP has been collecting benthos data since 1975. The locations of all sites, current and historic, are displayed below.  

<div class="figure" style="text-align: center">
<img src="figures/benthic/Benthic_Historic_Map.png" alt="Map of EMP's benthic field sites (past and current)." width="90%" />
<p class="caption">(\#fig:unnamed-chunk-12)Map of EMP's benthic field sites (past and current).</p>
</div>

<!--chapter:end:04-benthic-intro.Rmd-->

---
  html_document: 
    code_folding: hide
    toc: true
    toc_depth: 1
    toc_float:
      collapsed: true
editor_options: 
  chunk_output_type: console
---

## Current Report {#benthic-report}

### Introduction {.unlisted .unnumbered}

Benthic monitoring by the Environmental Monitoring Program is conducted monthly at 10 sampling sites distributed throughout several estuarine regions from San Pablo Bay upstream through the Sacramento-San Joaquin Delta.  2019 was designated a “Wet” water year for both the Sacramento Valley and San Joaquin Valley. Benthic communities in 2019 were expected be similar to previous “Wet” years (2011 and 2017) and differ from drier years both in species composition and in species abundances. 

<div class="figure" style="text-align: center">
<img src="figures/benthic/Benthic_Active_Map.png" alt="Map of EMP's current benthic field sites." width="80%" />
<p class="caption">(\#fig:unnamed-chunk-13)Map of EMP's current benthic field sites.</p>
</div>
***
### San Pablo Bay

The most saline of our sites, D41 and D41A, are polyhaline sites in San Pablo Bay. At D41 in 2019, the most numerous species was the non-native clam Potamocorbula amurensis, whose density peaked in July to 12,587 individuals per square meter, in a pattern seen primarily in wet years.  Site D41 was also notable as the only site where we saw phoronids, also known as horseshoe worms, which are only found in this higher-salinity site.

At D41A, there were high densities of the non-native amphipod Ampelisca abdita, which had a high of 9,846 individuals/m2 in December 2019, as well as Potamocorbula amurensis with an average annual density of 1,686 individuals/m2.

<div class="figure" style="text-align: center">
<img src="figures/benthic/Fig2_D24.png" alt="Density of benthic organisms, by month, collected at station (left) D41 and (right) D41A in 2019." width="50%" /><img src="figures/benthic/Fig11_D41A.png" alt="Density of benthic organisms, by month, collected at station (left) D41 and (right) D41A in 2019." width="50%" />
<p class="caption">(\#fig:unnamed-chunk-14)Density of benthic organisms, by month, collected at station (left) D41 and (right) D41A in 2019.</p>
</div>
***
### Suisun and Grizzly Bay

In Suisun Bay and Grizzly Bay in 2019, our mesohaline sites D6 and D7 both saw high numbers of the invasive clam P. amurensis, which had an average density of 9,891 individuals/m2 and comprised 97% of all organisms at D6 in 2019, similar to other recent years.  At D7, P. amurensis had a September peak of 12,471 individuals/m2, and the non-native amphipod Corophium alienense had a November peak of 10,428 individuals/m2.  These two species together made up 94% of all organisms at D7 in 2019.

<div class="figure" style="text-align: center">
<img src="figures/benthic/Fig8_D6.png" alt="Density of benthic organisms, by month, collected at station (left) D6 and (right) D7 in 2019." width="50%" /><img src="figures/benthic/Fig9_D7.png" alt="Density of benthic organisms, by month, collected at station (left) D6 and (right) D7 in 2019." width="50%" />
<p class="caption">(\#fig:unnamed-chunk-15)Density of benthic organisms, by month, collected at station (left) D6 and (right) D7 in 2019.</p>
</div>
***
### Confluence

At the confluence of the Sacramento and San Joaquin rivers, site D4’s oligohaline community was comprised in 2019 largely of the amphipods Americorophium spinicorne and Gammarus daiberi, which each had high variability through the year.  The oligochaete worm Varichaetadrilus angustipenis also had high density in the second half of the year. 

<div class="figure" style="text-align: center">
<img src="figures/benthic/Fig7_D4.png" alt="Density of benthic organisms, by month, collected at station D4 in 2019." width="50%" />
<p class="caption">(\#fig:unnamed-chunk-16)Density of benthic organisms, by month, collected at station D4 in 2019.</p>
</div>
***
### Central Delta

In the Sacramento River, freshwater site D24 was dominated by the non-native clam Corbicula fluminea, whose numbers averaged 3,016 per square meter over the course of 2019, similar to the very high densities of 2018. There was also a significant seasonal increase in densities of the amphipod Gammarus daiberi between September and December.

In the San Joaquin River, freshwater site D16 (at Twitchell Island) was dominated in 2019 by the amphipod Gammarus daiberi, which demonstrated an impressive density peak in May, as well as the clam Corbicula fluminea and the oligochaete worm V. angustipenis.  

In Old River, freshwater site D28A had a diverse community in 2019. There were high densities of the ostracod crustacean Cyprideis sp. A and the sabellid worm Manayunkia speciosa at the beginning of the year and lower densities for most of the rest of 2019.  There were also seasonal peaks of the oligochaete worm V. angustipenis and the amphipods G. daiberi and A. spinicorne.

<div class="figure" style="text-align: center">
<img src="figures/benthic/Fig2_D24.png" alt="Density of benthic organisms, by month, collected at station (left) D24, (center) D16 and (right) D28A in 2019." width="50%" /><img src="figures/benthic/Fig3_D16.png" alt="Density of benthic organisms, by month, collected at station (left) D24, (center) D16 and (right) D28A in 2019." width="50%" /><img src="figures/benthic/Fig4_D28A.png" alt="Density of benthic organisms, by month, collected at station (left) D24, (center) D16 and (right) D28A in 2019." width="50%" />
<p class="caption">(\#fig:unnamed-chunk-17)Density of benthic organisms, by month, collected at station (left) D24, (center) D16 and (right) D28A in 2019.</p>
</div>
***
### Southern Interior Delta

Further upstream in the San Joaquin River, site P8 at Buckley Cove was dominated by the sabellid worm M. speciosa which saw peaks in October and March. In addition to this species, which accounted for 59% of all organisms, site P8 saw a diverse community of freshwater oligochaetes, aquatic insects, and amphipods in addition to the non-native clam C. fluminea.

At Clifton Court Forebay, freshwater site C9 was dominated by a number of annelid species in 2019. Varichaetadrilus angustipenis, Limnodrilus hoffmeisteri,and Ilyodrilus frantzi were present at high densities throughout the year, at moderately higher levels than in 2018. The amphipod Hyalalla sp. A experienced a dramatic peak in density in November and December (Figure 11).  Site C9 is regularly one of our most biodiverse sites, with an additional large number of species present at low densities.

<div class="figure" style="text-align: center">
<img src="figures/benthic/Fig5_P8.png" alt="Density of benthic organisms, by month, collected at station (left) P8 and (right) C9 in 2019." width="50%" /><img src="figures/benthic/Fig6_C9.png" alt="Density of benthic organisms, by month, collected at station (left) P8 and (right) C9 in 2019." width="50%" />
<p class="caption">(\#fig:unnamed-chunk-18)Density of benthic organisms, by month, collected at station (left) P8 and (right) C9 in 2019.</p>
</div>
***
### Summary {.unlisted .unnumbered}

In summary, 2019 saw an overall decrease in invasive clam density from 2018 (13% for P. amurensis and 10% for C. fluminea). Other notable features of 2019 were the sharp decrease in overall density of the amphipod A. abdita in Grizzly Bay, after reaching a decadal peak in 2018, likely due to 2019’s decreased salinity, as well as the 2019 increase in the annelid M. speciosa, after its steady decrease from 2015 – 2018.
 Our ability to recognize these changes highlights the importance of monitoring benthic invertebrates to a high taxonomic resolution across the entire estuarine salinity gradient since the community has important interactions with various abiotic conditions as well as key parts of the estuarine food web.

<!--chapter:end:05-benthic-report.Rmd-->

---
  html_document: 
    code_folding: hide
    toc: true
    toc_depth: 1
    toc_float:
      collapsed: true
editor_options: 
  chunk_output_type: console
---

## Metadata

### Period of Record {.unlisted .unnumbered}
Benthic monitoring began in 1975. From 1975 through 1979 the program collected samples biannually from 18 to 35 stations, for a total of 48 stations over the period. In reviewing data collected between 1975 and 1979, it became evident that semi annual monitoring was insufficient to reveal long term ecological changes as mandated by Water Right Decision 1485. In 1980, DWR revised the benthic monitoring program and began monthly sampling at nine stations. In 1995, major program revisions were implemented to the program. A review of the data collected from 1980 to 1990 recommended that across-channel sampling be reduced to a single station per location in the Delta so that the geographic coverage could be widened. These revisions included increasing the number of sites sampled each month from nine to ten and increasing the number of grab sample replicates from three to four. Detailed information about location, number and characteristics of the historical sites can be found in IEP Technical Report 12 (Markmann, 1986) and IEP Technical Report 38 (Hymanson, et al., 1994). 
A programmatic review of the EMP in 2001-2002 found that the benthos monitoring element was particularly in need of fundamental and comprehensive consideration through intense special studies and study design examination. Reviewers recommended a temporary reduction in sampling frequency to free up EMP resources to conduct the more spatially intense sampling without requiring additional resources. October 2003 was the last of the monthly sampling events and sampling continued quarterly (in October, January, April, July) at the stations sampled through October 2005 when monthly sampling resumed. 

### Sampling Frequency {.unlisted .unnumbered}
Biannual sampling was conducted in late spring and fall, from 1975 to 1979. Monthly sampling started in June 1980 and ended in October 2003. Samples were collected quarterly from October 2003 through October 2005. Currently samples are collected monthly. 

### Sample Sites {.unlisted .unnumbered}
A list of the stations at which benthic invertebrate sampling has occurred is available
<!--html_preserve--><a href="data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,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" download="benthic_site_locs.xslx">here.</a><!--/html_preserve-->
Note: Coordinates are in decimal degrees, and channel position is determined while facing downstream.

### Field Collection Methods {.unlisted .unnumbered}
| Benthos {.unlisted .unnumbered} 
All samples are collected using a hydraulic winch and Ponar dredge. The Ponar dredge samples a bottom area of about 0.052 m2 to a depth that varies with the type of sediment and the ability of the dredge to penetrate it. Under the current program four replicate sample grabs are collected at each sampling site. The contents of the dredge are brought to the surface and placed in a large plastic bucket. Water is then added to the sample to create slurry. The contents of each grab sample bucket are washed over Standard No. 30 stainless steel mesh screen (0.595 mm openings). Each sample is carefully washed with a fine spray to remove as much of the substrate as possible. All material remaining on the screen after washing is preserved in a solution of approximately 20% buffered formaldehyde containing Rose Bengal dye for laboratory analysis. The benthic macroinvertebrate sampling methodology used in this program is described in Standard Methods for the Examination of Water and Wastewater, 20th ed. 1998 American Public Health Association, Washington D.C. (See pages 10-60 through 10-74.) 
| #### Sediment {.unlisted .unnumbered} 
Sediment samples are also collected as part of the benthic monitoring program. Samples are collected using the same hydraulic winch and Ponar dredge as the infaunal sampling. A single sediment grab is taken at each sampling site. The contents of the Ponar dredge are emptied into a plastic tub and a random subsample is placed into a 1-liter plastic jar for storage and transport to the DWR Soils Laboratory for analysis. 

### Lab Processing Methods {.unlisted .unnumbered}
<b>Benthos</b>

At the laboratory, the volume of settleable substrate in each sample jar is estimated and recorded. The formalin fixative is poured off and the sample is thoroughly washed on a 30-mesh (0.6 mm) screen. The composition of the substrate is estimated and recorded noting the relative percentages of peat, sand, mica, organic detritus, and other materials. The substrate is hand picked for organisms under a three diopter illuminated magnifier. Organisms are placed in 70% ethyl alcohol for subsequent identification. A stereoscopic dissecting microscope (70-120x) is used to identify most organisms. When taxonomic features are too small for identification under the dissecting scope, the organism is permanently mounted on a slide and examined under a compound microscope. If more than four hours of picking is required, and a sample contains many organisms but few species, a one-fourth subsample is chosen at random. The subsample is picked and the results are multiplied by four to represent the total sample. The remainder of the sample is inspected to make sure no other taxa were overlooked. Laboratory identification and enumeration of macro-benthic organisms in each sample is performed under contract by Hydrozoology Laboratory, P.O. Box 682 Newcastle, CA 95658. Analysis has been done by Hydrozoology for the program's entire period of record.

<b>Sediment</b>

All sediment samples are analyzed by the DWR Soils Laboratory, West Sacramento, CA. Analysis of a sediment sample involves determining the percent size fractions with the use of a mechanical sieve. The sieves sizes are as follow: 75, 37.5, 19, 9.5, 4.75, 2.36, 1.18, 0.6, 0.3, 0.15, 0.075, 0.005, 0.002, 0.001 mm. All particle sizes are found on a regular basis in the samples with the exception of gravel (particles greater than 4.76 mm in diameter). The percent organic content of each sediment sample is also determined from the loss in weight of an oven-dried sample burned at 440 degrees Celsius for 8 hours. All laboratory analysis procedures follow the American Society for Testing Methods, D-2974, "Moisture, Ash, and Organic Matter "and D-422-63, "Particle-Size Analysis of Soil". 

### Works Cited {.unlisted .unnumbered}

Hymanson, Z., D. Mayer and J. Steinbeck. 1994. Long-Term Trends in Benthos Abundance and Persistence in the Upper Sacramento-San Joaquin Estuary, Summary Report: 1980-1990. IEP Technical Report 38. 68 pp.

Markmann, C. 1986. Benthic Monitoring in the Sacramento-San Joaquin Delta. Results from 1975 through 1981. IEP Technical Report 12. 51 pp. 

<!--chapter:end:06-benthic-meta.Rmd-->

---
  html_document: 
    code_folding: hide
    toc: true
    toc_depth: 1
    toc_float:
      collapsed: true
editor_options: 
  chunk_output_type: console
---

## Data and Contact Info

### Data {.unlisted .unnumbered}
EMP's benthos data sets are available to download
<!--html_preserve--><a href="data:text/csv;base64,77u/dGhpcyxpcw0KYSx0ZXN0DQo=" download="test.csv">here.</a><!--/html_preserve-->

<!-- Metadata (station locations, visitis per year, grabs per year) is available  -->
<!-- ```{r echo=FALSE} -->
<!-- xfun::embed_file(path = 'data/benthic/EMP_Benthic_1975-19_Metadata.xlsx', name = 'EMP_Benthic_1975-19_Metadata.xlsx', text = 'here.') -->
<!-- ``` -->

### Archived Reports {.unlisted .unnumbered}
Archived annual reports can be found [here]() (link currently broken).

### Contact Information {.unlisted .unnumbered}
For questions related to EMP's benthos data sets, please contact Betsy Wells at elizabeth.wells@water.ca.gov.


<!--chapter:end:07-benthic-data.Rmd-->

# Metadata

Placeholder.


<!--chapter:end:08-refs.Rmd-->

---
  html_document: 
    code_folding: hide
    toc: true
    toc_depth: 1
    toc_float:
      collapsed: true
editor_options: 
  chunk_output_type: console
---

# Examples

### Shiny App {.unlisted .unnumbered}
<iframe src="https://deltascience.shinyapps.io/ZoopSynth/?showcase=0" width="672" height="600px"></iframe>

### Interactive Scatterplot {.unlisted .unnumbered}

<!--html_preserve--><div id="htmlwidget-50e38af9667155d48776" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-50e38af9667155d48776">{"x":{"visdat":{"1d1838e964d9":["function () ","plotlyVisDat"]},"cur_data":"1d1838e964d9","attrs":{"1d1838e964d9":{"x":{},"y":{},"marker":{"size":10,"color":"rgba(255, 182, 193, .9)","line":{"color":"rgba(152, 0, 0, .8)","width":2}},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20]}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"Example Scatterplot","yaxis":{"domain":[0,1],"automargin":true,"zeroline":false,"title":"Petal.Length"},"xaxis":{"domain":[0,1],"automargin":true,"zeroline":false,"title":"Sepal.Length"},"hovermode":"closest","showlegend":false},"source":"A","config":{"showSendToCloud":false},"data":[{"x":[5.1,4.9,4.7,4.6,5,5.4,4.6,5,4.4,4.9,5.4,4.8,4.8,4.3,5.8,5.7,5.4,5.1,5.7,5.1,5.4,5.1,4.6,5.1,4.8,5,5,5.2,5.2,4.7,4.8,5.4,5.2,5.5,4.9,5,5.5,4.9,4.4,5.1,5,4.5,4.4,5,5.1,4.8,5.1,4.6,5.3,5,7,6.4,6.9,5.5,6.5,5.7,6.3,4.9,6.6,5.2,5,5.9,6,6.1,5.6,6.7,5.6,5.8,6.2,5.6,5.9,6.1,6.3,6.1,6.4,6.6,6.8,6.7,6,5.7,5.5,5.5,5.8,6,5.4,6,6.7,6.3,5.6,5.5,5.5,6.1,5.8,5,5.6,5.7,5.7,6.2,5.1,5.7,6.3,5.8,7.1,6.3,6.5,7.6,4.9,7.3,6.7,7.2,6.5,6.4,6.8,5.7,5.8,6.4,6.5,7.7,7.7,6,6.9,5.6,7.7,6.3,6.7,7.2,6.2,6.1,6.4,7.2,7.4,7.9,6.4,6.3,6.1,7.7,6.3,6.4,6,6.9,6.7,6.9,5.8,6.8,6.7,6.7,6.3,6.5,6.2,5.9],"y":[1.4,1.4,1.3,1.5,1.4,1.7,1.4,1.5,1.4,1.5,1.5,1.6,1.4,1.1,1.2,1.5,1.3,1.4,1.7,1.5,1.7,1.5,1,1.7,1.9,1.6,1.6,1.5,1.4,1.6,1.6,1.5,1.5,1.4,1.5,1.2,1.3,1.4,1.3,1.5,1.3,1.3,1.3,1.6,1.9,1.4,1.6,1.4,1.5,1.4,4.7,4.5,4.9,4,4.6,4.5,4.7,3.3,4.6,3.9,3.5,4.2,4,4.7,3.6,4.4,4.5,4.1,4.5,3.9,4.8,4,4.9,4.7,4.3,4.4,4.8,5,4.5,3.5,3.8,3.7,3.9,5.1,4.5,4.5,4.7,4.4,4.1,4,4.4,4.6,4,3.3,4.2,4.2,4.2,4.3,3,4.1,6,5.1,5.9,5.6,5.8,6.6,4.5,6.3,5.8,6.1,5.1,5.3,5.5,5,5.1,5.3,5.5,6.7,6.9,5,5.7,4.9,6.7,4.9,5.7,6,4.8,4.9,5.6,5.8,6.1,6.4,5.6,5.1,5.6,6.1,5.6,5.5,4.8,5.4,5.6,5.1,5.1,5.9,5.7,5.2,5,5.2,5.4,5.1],"marker":{"color":"rgba(255, 182, 193, .9)","size":10,"line":{"color":"rgba(152, 0, 0, .8)","width":2}},"type":"scatter","mode":"markers","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

### Interactive Map {.unlisted .unnumbered}
<!--html_preserve--><div id="htmlwidget-23466ff1e593f2ace246" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-23466ff1e593f2ace246">{"x":{"visdat":{"1d185bc45c3c":["function () ","plotlyVisDat"]},"cur_data":"1d185bc45c3c","attrs":{"1d185bc45c3c":{"locationmode":"USA-states","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"z":{},"text":{},"locations":{},"color":{},"colors":"Purples","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"mapType":"geo","scene":{"zaxis":{"title":"total.exports"}},"geo":{"domain":{"x":[0,1],"y":[0,1]},"scope":"usa","projection":{"type":"albers usa"},"showlakes":true,"lakecolor":"rgba(255,255,255,1)"},"hovermode":"closest","showlegend":false,"legend":{"yanchor":"top","y":0.5},"title":"2011 US Agriculture Exports by State<br>(Hover for breakdown)"},"source":"A","config":{"showSendToCloud":false},"data":[{"colorbar":{"title":"Millions USD","ticklen":2,"len":0.5,"lenmode":"fraction","y":1,"yanchor":"top"},"colorscale":[["0","rgba(252,251,253,1)"],["0.0416666666666667","rgba(248,246,250,1)"],["0.0833333333333333","rgba(243,242,248,1)"],["0.125","rgba(239,237,245,1)"],["0.166666666666667","rgba(232,231,242,1)"],["0.208333333333333","rgba(225,224,238,1)"],["0.25","rgba(218,218,235,1)"],["0.291666666666667","rgba(208,208,230,1)"],["0.333333333333333","rgba(198,199,225,1)"],["0.375","rgba(188,189,220,1)"],["0.416666666666667","rgba(178,177,213,1)"],["0.458333333333333","rgba(168,166,207,1)"],["0.5","rgba(158,154,200,1)"],["0.541666666666667","rgba(148,144,195,1)"],["0.583333333333333","rgba(138,135,191,1)"],["0.625","rgba(128,125,186,1)"],["0.666666666666667","rgba(121,110,178,1)"],["0.708333333333333","rgba(114,96,171,1)"],["0.75","rgba(106,81,163,1)"],["0.791666666666667","rgba(99,67,156,1)"],["0.833333333333333","rgba(92,54,150,1)"],["0.875","rgba(84,39,143,1)"],["0.916666666666667","rgba(77,28,137,1)"],["0.958333333333333","rgba(70,16,131,1)"],["1","rgba(63,0,125,1)"]],"showscale":true,"locationmode":"USA-states","z":[1390.63,13.31,1463.17,3586.02,16472.88,1851.33,259.62,282.19,3764.09,2860.84,401.84,2078.89,8709.48,5050.23,11273.76,4589.01,1889.15,1914.23,278.37,692.75,248.65,3164.16,7192.33,2170.8,3933.42,1718,7114.13,139.89,73.06,500.4,751.58,1488.9,3806.05,3761.96,3979.79,1646.41,1794.57,1969.87,31.59,929.93,3770.19,1535.13,6648.22,453.39,180.14,1146.48,3894.81,138.89,3090.23,349.69],"text":["Alabama <br> Beef 34.4 Dairy 4.06 <br> Fruits 25.11 Veggies 14.33 <br> Wheat 70 Corn 34.9","Alaska <br> Beef 0.2 Dairy 0.19 <br> Fruits 0 Veggies 1.56 <br> Wheat 0 Corn 0","Arizona <br> Beef 71.3 Dairy 105.48 <br> Fruits 60.27 Veggies 386.91 <br> Wheat 48.7 Corn 7.3","Arkansas <br> Beef 53.2 Dairy 3.53 <br> Fruits 6.88 Veggies 11.45 <br> Wheat 114.5 Corn 69.5","California <br> Beef 228.7 Dairy 929.95 <br> Fruits 8736.4 Veggies 2106.79 <br> Wheat 249.3 Corn 34.6","Colorado <br> Beef 261.4 Dairy 71.94 <br> Fruits 17.99 Veggies 118.27 <br> Wheat 400.5 Corn 183.2","Connecticut <br> Beef 1.1 Dairy 9.49 <br> Fruits 13.1 Veggies 11.16 <br> Wheat 0 Corn 0","Delaware <br> Beef 0.4 Dairy 2.3 <br> Fruits 1.53 Veggies 20.03 <br> Wheat 22.9 Corn 26.9","Florida <br> Beef 42.6 Dairy 66.31 <br> Fruits 1371.36 Veggies 450.86 <br> Wheat 1.8 Corn 3.5","Georgia <br> Beef 31 Dairy 38.38 <br> Fruits 233.51 Veggies 154.77 <br> Wheat 65.4 Corn 57.8","Hawaii <br> Beef 4 Dairy 1.16 <br> Fruits 55.51 Veggies 24.83 <br> Wheat 0 Corn 0","Idaho <br> Beef 119.8 Dairy 294.6 <br> Fruits 21.64 Veggies 319.19 <br> Wheat 568.2 Corn 24","Illinois <br> Beef 53.7 Dairy 45.82 <br> Fruits 12.53 Veggies 39.95 <br> Wheat 223.8 Corn 2228.5","Indiana <br> Beef 21.9 Dairy 89.7 <br> Fruits 12.98 Veggies 37.89 <br> Wheat 114 Corn 1123.2","Iowa <br> Beef 289.8 Dairy 107 <br> Fruits 3.24 Veggies 7.1 <br> Wheat 3.1 Corn 2529.8","Kansas <br> Beef 659.3 Dairy 65.45 <br> Fruits 3.11 Veggies 9.32 <br> Wheat 1426.5 Corn 457.3","Kentucky <br> Beef 54.8 Dairy 28.27 <br> Fruits 6.6 Veggies 0 <br> Wheat 149.3 Corn 179.1","Louisiana <br> Beef 19.8 Dairy 6.02 <br> Fruits 17.83 Veggies 17.25 <br> Wheat 78.7 Corn 91.4","Maine <br> Beef 1.4 Dairy 16.18 <br> Fruits 52.01 Veggies 62.9 <br> Wheat 0 Corn 0","Maryland <br> Beef 5.6 Dairy 24.81 <br> Fruits 12.9 Veggies 20.43 <br> Wheat 55.8 Corn 54.1","Massachusetts <br> Beef 0.6 Dairy 5.81 <br> Fruits 80.83 Veggies 21.13 <br> Wheat 0 Corn 0","Michigan <br> Beef 37.7 Dairy 214.82 <br> Fruits 257.69 Veggies 189.96 <br> Wheat 247 Corn 381.5","Minnesota <br> Beef 112.3 Dairy 218.05 <br> Fruits 7.91 Veggies 120.37 <br> Wheat 538.1 Corn 1264.3","Mississippi <br> Beef 12.8 Dairy 5.45 <br> Fruits 17.04 Veggies 27.87 <br> Wheat 102.2 Corn 110","Missouri <br> Beef 137.2 Dairy 34.26 <br> Fruits 13.18 Veggies 17.9 <br> Wheat 161.7 Corn 428.8","Montana <br> Beef 105 Dairy 6.82 <br> Fruits 3.3 Veggies 45.27 <br> Wheat 1198.1 Corn 5.4","Nebraska <br> Beef 762.2 Dairy 30.07 <br> Fruits 2.16 Veggies 53.5 <br> Wheat 292.3 Corn 1735.9","Nevada <br> Beef 21.8 Dairy 16.57 <br> Fruits 1.19 Veggies 27.93 <br> Wheat 5.4 Corn 0","New Hampshire <br> Beef 0.6 Dairy 7.46 <br> Fruits 7.98 Veggies 4.5 <br> Wheat 0 Corn 0","New Jersey <br> Beef 0.8 Dairy 3.37 <br> Fruits 109.45 Veggies 56.54 <br> Wheat 6.7 Corn 10.1","New Mexico <br> Beef 117.2 Dairy 191.01 <br> Fruits 101.9 Veggies 43.88 <br> Wheat 13.9 Corn 11.2","New York <br> Beef 22.2 Dairy 331.8 <br> Fruits 202.56 Veggies 143.37 <br> Wheat 29.9 Corn 106.1","North Carolina <br> Beef 24.8 Dairy 24.9 <br> Fruits 74.47 Veggies 150.45 <br> Wheat 200.3 Corn 92.2","North Dakota <br> Beef 78.5 Dairy 8.14 <br> Fruits 0.25 Veggies 130.79 <br> Wheat 1664.5 Corn 236.1","Ohio <br> Beef 36.2 Dairy 134.57 <br> Fruits 27.21 Veggies 53.53 <br> Wheat 207.4 Corn 535.1","Oklahoma <br> Beef 337.6 Dairy 24.35 <br> Fruits 9.24 Veggies 8.9 <br> Wheat 324.8 Corn 27.5","Oregon <br> Beef 58.8 Dairy 63.66 <br> Fruits 315.04 Veggies 126.5 <br> Wheat 320.3 Corn 11.7","Pennsylvania <br> Beef 50.9 Dairy 280.87 <br> Fruits 89.48 Veggies 38.26 <br> Wheat 41 Corn 112.1","Rhode Island <br> Beef 0.1 Dairy 0.52 <br> Fruits 2.83 Veggies 3.02 <br> Wheat 0 Corn 0","South Carolina <br> Beef 15.2 Dairy 7.62 <br> Fruits 53.45 Veggies 42.66 <br> Wheat 55.3 Corn 32.1","South Dakota <br> Beef 193.5 Dairy 46.77 <br> Fruits 0.8 Veggies 4.06 <br> Wheat 704.5 Corn 643.6","Tennessee <br> Beef 51.1 Dairy 21.18 <br> Fruits 6.23 Veggies 24.67 <br> Wheat 100 Corn 88.8","Texas <br> Beef 961 Dairy 240.55 <br> Fruits 99.9 Veggies 115.23 <br> Wheat 309.7 Corn 167.2","Utah <br> Beef 27.9 Dairy 48.6 <br> Fruits 12.34 Veggies 6.6 <br> Wheat 42.8 Corn 5.3","Vermont <br> Beef 6.2 Dairy 65.98 <br> Fruits 8.01 Veggies 4.05 <br> Wheat 0 Corn 0","Virginia <br> Beef 39.5 Dairy 47.85 <br> Fruits 36.48 Veggies 27.25 <br> Wheat 77.5 Corn 39.5","Washington <br> Beef 59.2 Dairy 154.18 <br> Fruits 1738.57 Veggies 363.79 <br> Wheat 786.3 Corn 29.5","West Virginia <br> Beef 12 Dairy 3.9 <br> Fruits 11.54 Veggies 0 <br> Wheat 1.6 Corn 3.5","Wisconsin <br> Beef 107.3 Dairy 633.6 <br> Fruits 133.8 Veggies 148.99 <br> Wheat 96.7 Corn 460.5","Wyoming <br> Beef 75.1 Dairy 2.89 <br> Fruits 0.17 Veggies 10.23 <br> Wheat 20.7 Corn 9"],"locations":["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"],"type":"choropleth","marker":{"line":{"colorbar":{"title":"","ticklen":2},"cmin":13.31,"cmax":16472.88,"colorscale":[["0","rgba(252,251,253,1)"],["0.0416666666666667","rgba(248,246,250,1)"],["0.0833333333333333","rgba(243,242,248,1)"],["0.125","rgba(239,237,245,1)"],["0.166666666666667","rgba(232,231,242,1)"],["0.208333333333333","rgba(225,224,238,1)"],["0.25","rgba(218,218,235,1)"],["0.291666666666667","rgba(208,208,230,1)"],["0.333333333333333","rgba(198,199,225,1)"],["0.375","rgba(188,189,220,1)"],["0.416666666666667","rgba(178,177,213,1)"],["0.458333333333333","rgba(168,166,207,1)"],["0.5","rgba(158,154,200,1)"],["0.541666666666667","rgba(148,144,195,1)"],["0.583333333333333","rgba(138,135,191,1)"],["0.625","rgba(128,125,186,1)"],["0.666666666666667","rgba(121,110,178,1)"],["0.708333333333333","rgba(114,96,171,1)"],["0.75","rgba(106,81,163,1)"],["0.791666666666667","rgba(99,67,156,1)"],["0.833333333333333","rgba(92,54,150,1)"],["0.875","rgba(84,39,143,1)"],["0.916666666666667","rgba(77,28,137,1)"],["0.958333333333333","rgba(70,16,131,1)"],["1","rgba(63,0,125,1)"]],"showscale":false,"color":[1390.63,13.31,1463.17,3586.02,16472.88,1851.33,259.62,282.19,3764.09,2860.84,401.84,2078.89,8709.48,5050.23,11273.76,4589.01,1889.15,1914.23,278.37,692.75,248.65,3164.16,7192.33,2170.8,3933.42,1718,7114.13,139.89,73.06,500.4,751.58,1488.9,3806.05,3761.96,3979.79,1646.41,1794.57,1969.87,31.59,929.93,3770.19,1535.13,6648.22,453.39,180.14,1146.48,3894.81,138.89,3090.23,349.69]}},"geo":"geo","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


<!--chapter:end:09-examples.Rmd-->

