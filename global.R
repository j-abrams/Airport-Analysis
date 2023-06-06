


#### Setup

# 1. Load required packages
# 2. Store hard coded variables

#### Packages
# Standard packages
library(dplyr)  # data handling
library(ggplot2)  # plotting
library(lubridate)  # date formatting

# Markdown operations
library(httr)
library(jsonlite)
library(rvest)
library(knitr)

# Package management
library(roxygen2)
library(devtools)

#library(here)
#here()


#### Hard Coded variables

# API Key hard coded
api_key <- "dc7a7014-15b3-4c91-9825-51c82e96c8ff"

# Hard coded fields to keep (41 fields reduced to 12) for arrivals
fields_arrivals <- c("airline_iata", "airline_icao", "flight_iata", "flight_icao", "flight_number",
                     "dep_iata", "dep_icao", 
                     "arr_iata", "arr_icao", "arr_terminal", "arr_time", "delayed", "duration")

# Hard coded Fields to keep for departures
fields_departures <- c("airline_iata", "airline_icao", "flight_iata", "flight_icao", "flight_number",
                       "dep_iata", "dep_icao", "dep_terminal", "dep_time", 
                       "arr_iata", "arr_icao", "delayed", "duration")



