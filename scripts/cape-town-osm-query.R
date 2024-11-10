library(osmdata)
library(sf)
library(tidyverse)

## Bounding box
bounds = "Cape Town Ward 115, South Africa"
# Obtain Cape Town from OSM
bb = getbb(bounds, format_out = 'sf_polygon')

## Roads
# Download OSM data for Cape Town, with the key=highway
roads = opq(bounds) |>
  add_osm_feature(key = "highway") |>
  osmdata_sf() |> 
  osm_poly2line()
# Create a LINESTRING sf object with selected columns
lines = roads |> 
  pluck("osm_lines") |> 
  st_intersection(bb) |> 
  filter(st_is(geometry, c("LINESTRING", "MULTILINESTRING"))) |> 
  st_cast("LINESTRING") |> 
  dplyr::select(
    name, 'type' = highway, 
    maxspeed, surface, 
    lanes, oneway, cycleway
  ) |> 
  filter(!type %in% c("bus_stop", "elevator", "steps", "busway",
                      "corridor", "track", "living_street", NA))

write_sf(lines, "data/south-africa/cape-town/cape_town_osm_roads.gpkg", overwrite = TRUE)

