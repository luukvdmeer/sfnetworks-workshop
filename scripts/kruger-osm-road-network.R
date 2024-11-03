library(osmdata)
library(sf)
library(tidyverse)

## Bounding box
area = "Kruger National Park, South Africa"
# Obtain Kruger NP boundary from OSM
bb = getbb(area, format_out = 'sf_polygon')

## Roads
# Download OSM data for Kruger NP, with the key=highway
roads = opq(area) |>
  add_osm_feature(key = "highway") |>
  osmdata_sf() 
# Create a LINESTRING sf object with selected columns
lines = roads |> 
  pluck("osm_lines") |> 
  st_intersection(bb) |> 
  filter(st_is(geometry, c("LINESTRING", "MULTILINESTRING"))) |> 
  st_cast("LINESTRING") |> 
  dplyr::select(
    name, 'type' = highway, 
    maxspeed, surface
  )

write_sf(lines, "data/kruger/kruger_osm_roads.gpkg")

