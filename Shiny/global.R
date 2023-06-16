


library(rsconnect)

#rsconnect::deployApp(appDir = "path_to_your_app_directory")

#install.packages("MASS", version = "7.3-58.3")
library(MASS)

#library(AirportAnalysis)
library(shinyWidgets)
library(DT)
library(shinyjs)
library(shinycssloaders)
library(shinydashboard)


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

source("shiny_functions.R")

library(conflicted)
conflict_prefer("select", "dplyr")
conflicts_prefer(DT::dataTableOutput)
conflicts_prefer(DT::renderDataTable)
conflicts_prefer(dplyr::filter)
conflicts_prefer(dplyr::lag)

#### Hard Coded variables

# API Key hard coded
api_key <- "46ef7ea8-4b01-48a3-8377-f621ae7c0b60"

# Hard coded fields to keep (41 fields reduced to 12) for arrivals
fields_arrivals <- c("airline_iata", "airline_icao", "flight_iata", "flight_icao", "flight_number",
                     "dep_iata", "dep_icao", 
                     "arr_iata", "arr_icao", "arr_terminal", "arr_time", "arr_actual", "delayed", "duration")

# Hard coded Fields to keep for departures
fields_departures <- c("airline_iata", "airline_icao", "flight_iata", "flight_icao", "flight_number",
                       "dep_iata", "dep_icao", "dep_terminal", "dep_time", "dep_actual",
                       "arr_iata", "arr_icao", "delayed", "duration")



# # 2: Airport Lookup codes
# # Remove redundant fields with select command
airports <- read.csv("Data/airports.csv")

# # Example 3: Airline Lookup codes
# # Match airport code with airport name
airlines <- read.csv("Data/airlines.csv")

