#### Transforming Data Part I ####
library(purrr)
PATH <- "C:/logs/workshop/R/intro-r-2024/data/"
name_d <- c("detectors","stations","highways")
portal <- name_d %>% map(~read.csv(paste0(PATH, "portal_", .x, ".csv")))
names(portal) <- name_d

SteelBridge <- readRDS(paste0(PATH,"steel_bridge_counts_jan2013_may2024.RDS"))

agg_data <- read.csv(paste0(PATH, "agg_data.csv"))

Site_Location <- sf::st_read(paste0(PATH, "gis/Site_Location_Info.shp"))
