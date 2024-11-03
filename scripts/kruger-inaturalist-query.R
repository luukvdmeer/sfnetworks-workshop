library(rinat)
library(tidyverse)
krugeranimals = get_inat_obs(
  geo = TRUE,
  taxon_name = "Mammalia",
  place_id = 69020, # Kruger National Park
  maxresults = 1000,
  year = 2024
)
write_csv(krugeranimals, "data/kruger/kruger_mammalia_inaturalist.csv")
