library(tidyverse)
library(sf)


# import shapefile to get pittsburgh block groups
block_map <- st_read('raw_data/pitt_bg_hood.shp')

# get block groups
pitt_bgs <- data.frame(bgs = unique(block_map$GEOID))


# import files downloaded from Census LODES program
pa_wac <- read_csv('raw_data/pa_wac_S000_JT00_2015.csv',col_types = cols(w_geocode='c'))
pa_rac <- read_csv('raw_data/pa_rac_S000_JT00_2015.csv',col_types = cols(h_geocode='c'))

# eliminate unlimited columns
pa_wac <- pa_wac %>%
  select(w_geocode,workers=C000)

pa_rac <- pa_rac %>%
  select(h_geocode,workers=C000)

# create block group codes
pa_wac$w_bg <- substring(pa_wac$w_geocode,1,12)
pa_rac$h_bg <- substring(pa_rac$h_geocode,1,12)

# aggregate to block groups
pa_wac_bg <- pa_wac %>%
  group_by(w_bg) %>%
  summarise(workers_in_bg=sum(workers))

pa_rac_bg <- pa_rac %>%
  group_by(h_bg) %>%
  summarise(workers_from_bg=sum(workers))


# filter to Pittsburgh block groups
pitt_wac_bg <- pa_wac_bg %>%
  filter(w_bg %in% pitt_bgs$bgs)

pitt_rac_bg <- pa_rac_bg %>%
  filter(h_bg %in% pitt_bgs$bgs)

# save files
write_csv(pitt_wac_bg, 'raw_data/pitt_wac.csv')
write_csv(pitt_rac_bg, 'raw_data/pitt_rac.csv')
