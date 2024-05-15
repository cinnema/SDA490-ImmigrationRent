rm(list = ls())
library(bcmaps)
library(canadamaps)
library(colorspace)
library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(leaflet)
library(lwgeom)
library(mapview)
library(readxl)
library(RColorBrewer)
library(rsconnect)
library(sf)
library(scales)
library(shiny)
library(shinyjs)
library(tidyr)
library(tidyverse)
library(viridis)
library(leafem)
library(cancensus)
library(reshape2)
library(patchwork)
library(plotly)
library(fixest)
library(modelsummary)
library(webshot2)
library(marginaleffects)
library(shinydashboard)
library(shinydashboardPlus)

set_cancensus_api_key("CensusMapper_0f7c838eaa9ea580142980c262c0d9c0")

read_and_assign <- function(directory_path, file_names) {
  file_paths <- file.path(directory_path, file_names)
  
  dfs <- list()
  for (path in file_paths) {
    ext <- tools::file_ext(path)
    dataset_name <- paste0(basename(tools::file_path_sans_ext(path)), "_data")
    if (ext == "xlsx") {
      dfs[[dataset_name]] <- readxl::read_xlsx(path)
    } else if (ext == "csv") {
      dfs[[dataset_name]] <- read.csv(path, stringsAsFactors = FALSE)
    } 
  }
  return(dfs)
}

directory_path <- "Datasets" 
file_names <- c(
  "Data_Pop_Growth_filtered.csv",
  "RentPrices.csv",
  "ImmigrantEstimates.csv",
  "naturalIncrease.csv",
  "Rental price.csv",
  "Turnover Van Tor.csv",
  "complete_data.csv"
)

dfs <- read_and_assign(directory_path, file_names)

for (name in names(dfs)) {
  assign(name, dfs[[name]])
}

print("dataloading is completed")
