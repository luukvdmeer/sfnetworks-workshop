FROM rocker/geospatial:dev-osgeo

RUN R -e "remotes::install_github('r-spatial/sf')"
RUN R -e "remotes::install_github('r-spatial/lwgeom')"
RUN R -e "remotes::install_github('luukvdmeer/sfnetworks')"

RUN install2.r --error \
  dodgr \
  igraph \
  ggraph \
  mapview \
  osmdata \
  sfheaders \
  spatstat \
  spdep \
  tidygraph \
  units
  
 WORKDIR "/workspaces/sfnetworks-workshop"