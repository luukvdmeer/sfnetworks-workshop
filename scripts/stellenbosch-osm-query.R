library(osmdata)
library(sf)
library(tidyverse)

## Bounding box
city = "Stellenbosch, South Africa"
# Obtain Stellenbosch from OSM
bb = getbb(city, format_out = 'sf_polygon')

## Roads
# Download OSM data for Stellenbosch, with the key=highway
roads = opq(city) |>
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
    maxspeed, surface, 
    lanes, oneway, cycleway
  )

write_sf(lines, "data/stellenbosch/stellenbosch_osm_roads.gpkg")


## POIs
# Download OSM data for Stellenbosch, 
# with the amenity:restaurant and amenity:cafe
amenities = opq(city) |>
  add_osm_feature(
    key = "amenity", 
    value = c(
      "cafe", "restaurant"
    )
  ) |>
  osmdata_sf() 
# Create a POINTS sf object with selected columns 
pois = amenities |> 
  pluck("osm_points") |> 
  st_intersection(bb) |> 
  select(
    name, amenity
  ) 

ggplot() + 
  geom_sf(data = lines, color = "grey") +
  geom_sf(data = pois, color = "red", size = 0.5) +
  geom_sf(data = venue_cent, color = "blue", size = 3, shape = 8) +
  theme_bw()

## VENUE
# Get venue location from OSM
venue = opq("Protea Hotel Stellenbosch") |> 
  add_osm_feature(key = "building", value = "hotel") |> 
  osmdata_sf()
venue_cent = venue |> 
  pluck("osm_polygons") |> 
  st_centroid()

