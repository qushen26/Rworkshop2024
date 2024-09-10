#### Transforming Data Part I ####
library(purrr)
name_d <- c("detectors","stations","highways")

portal <- name_d %>% map(~read.csv(paste0("C:/logs/workshop/R/intro-r-2024/data/portal_", .x, ".csv")))

