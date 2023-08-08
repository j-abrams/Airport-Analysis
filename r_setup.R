


#### Setup

# 1. Load required packages
# 2. Store hard coded variables

#### Packages
# Standard packages
library(dplyr)  # data handling
library(ggplot2)  # plotting
library(lubridate)  # date formatting
library(stats)
library(tidyr)
library(stringr)  # str_detect

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
#api_key <- "46ef7ea8-4b01-48a3-8377-f621ae7c0b60"

api_key <- "ab78f260-9737-4847-9ee8-d663e76f23c9"

# Hard coded fields to keep (41 fields reduced to 12) for arrivals
fields_arrivals <- c("airline_iata", "airline_icao", "flight_iata", "flight_icao", "flight_number",
                     "dep_iata", "dep_icao", 
                     "arr_iata", "arr_icao", "arr_terminal", "arr_time", "arr_actual", "delayed", "duration")

# Hard coded Fields to keep for departures
fields_departures <- c("airline_iata", "airline_icao", "flight_iata", "flight_icao", "flight_number",
                       "dep_iata", "dep_icao", "dep_terminal", "dep_time", "dep_actual",
                       "arr_iata", "arr_icao", "delayed", "duration")


# Rolling updates allegedly. Test tonight please.
# Your code to be executed every 30 minutes
my_code <- function() {
  departures_dd <- get_live_flight_data("departures", "YYZ") 
  arrivals_dd <- get_live_flight_data("arrivals", "YYZ")
}

# Function to run the code every 20 minutes
run_every_30_minutes <- function() {
  while (TRUE) {
    my_code()  # Execute your code
    
    # Sleep for 20 minutes
    Sys.sleep(30 * 60)
  }
}





