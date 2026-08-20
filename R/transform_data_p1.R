#### Transforming Data Part I ####
library(dplyr)
library(purrr)
PATH <- "data/"
name_d <- c("detectors", "stations", "highways")
portal <- name_d  |>
  map( ~ read.csv(paste0(PATH, "portal_", .x, ".csv")))
names(portal) <- name_d

library(lubridate)
portal$detectors$end_date <- ymd_hms(portal$detectors$end_date,tz="US/Pacific" ) # |> with_tz("US/Pacific")

temp <- portal$detectors |> mutate(date= floor_date(end_date,unit = "day"),
                           Date= date(end_date),
                           Day= day(end_date))


SteelBridge <-
  readRDS(paste0(PATH, "steel_bridge_counts_jan2013_may2024.RDS"))

agg_data <- read.csv(paste0(PATH, "agg_data.csv"))

Site_Location <-
  sf::st_read(paste0(PATH, "gis/Site_Location_Info.shp"))

mapview::mapview(Site_Location)

# rows <- split(df, seq(nrow(df)))
# lines <- lapply(rows, function(row) {
#   lmat <- matrix(unlist(row[2:5]), ncol = 2, byrow = TRUE)
#   st_linestring(lmat)
# })
# lines <- st_sfc(lines)
# lines_sf <- st_sf('ID' = df$ID, 'geometry' = lines)

##############################################################
# Piecewise Linear Segmentation by Dynamic Programming
# https://cran.r-project.org/web/packages/dpseg/vignettes/dpseg.html


###### Linear Reference System ##############################
# devtools:::install_github("gearslaboratory/gdalUtils")
# ogrlineref()


library(sf)
xy <- portal$stations |> filter(highwayid==1, lat>1) |> select(lon,lat) |> unique() |> arrange(lat)  |> 
  as.matrix() |> st_linestring()

mp <- portal$stations |> filter(highwayid==1, lat>1) |> select(milepost) |> unique() |> arrange(milepost)  |> 
  mutate(y=0) |> 
  as.matrix() |> st_linestring()

st_node()
st_length(geom)
st_linesubstring()
st_line_merge()
st_line_project(st_as_sfc("LINESTRING (0 0, 10 10)"), st_as_sfc(c("POINT (0 0)", "POINT (5 5)")))
st_line_project(st_as_sfc("LINESTRING (0 0, 10 10)"), st_as_sfc("POINT (5 5)"), TRUE)
st_line_interpolate(st_as_sfc("LINESTRING (0 0, 1 1)"), c(.5,1))
st_line_interpolate(st_as_sfc("LINESTRING (0 0, 1 1)"), 1, TRUE)
st_segmentize(sf, units::set_units(100, km))


library(lwgeom)
# https://r-spatial.github.io/lwgeom/index.html
st_geod_segmentize(st_transform(shpObject[1,],crs=4326), units::set_units(10, km))


# https://cran.r-project.org/web/packages/rLFT/vignettes/rLFT_Introduction.html
library(rLFT)
data("shpObject")
mapview::mapview(shpObject)
shpObject$RID |> map(~ shpObject |> filter(RID==.x) |> st_coordinates() |> as.data.frame() |> reframe(id=.,node=n()),
          ) |> list_rbind()  

bct(shpObject[1,],step=600,window = 1000)
bct(shpObject[2,],step=30,window = 50, ridName = "RID")
outputTable <- bct(shpObject, step = 50, window = 100, ridName = "RID")
outSF<- st_as_sf(outputTable, coords = c("Midpoint_X", "Midpoint_Y"), crs = st_crs(shpObject), stringsAsFactors = FALSE)

# The M Values are calculated by using the euclidean distance between the sf objects x and y coordinates
monly <- addMValues(shpObject)

