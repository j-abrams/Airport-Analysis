

#
# STILL
# TODO:
#
# FLight code, how to pick up the right one 
# At the minute it is picking up the first one in alphabetical order
# Fixed? group by and filter(flight_code == cs_flight_code) 
# - not yet fixed in markdown env (low priority)
#
# Rolling updates (automate this please, every 20 mins?)
#
# Add package to github and install from there - removes need for shiny_functions script
#
# gitignore file? 
# Further Organisation of folders required. What to add to git / ignore
# Clear separation between Package / Markdown / Shiny content.
#
# combine_csv - combine files into one going forwards
#
# text output - last update and number of flights
#


# Package setup
# Initiate packages and hard coded variables.
source("setup.R")

# Use roxygen2 comments to document functions in my package
roxygen2::roxygenise("./AirportAnalysis Package")

# Build the package
devtools::build("./AirportAnalysis Package")

# Install the package from specified location
install.packages("C:/Users/james/OneDrive/Documents/AirportAnalysis_0.1.0.tar.gz")
#devtools::install("./AirportAnalysis Package")

# Load the package
library(AirportAnalysis)






# Delays for shiny app

# Start collecting live data half hour increments.
# NOTE - WHEN RUNNING IN SHINY FILE PATH IS DIFFERENT
# Need to edit get_live_flight_data() each time


# investigate use of dep_estimated and arr_estimated

flight_type <- "departures"
airport <- "YYZ"

#This is filtering too much I think.
#filter(flight_number == cs_flight_number) 

departures_dd <- get_live_flight_data("departures", "YYZ") 
# %>% filter(str_detect(dep_time, "^2023-06-15"))

# Mutate dep_actual to equal dep_time if dep_estimated doesnt exist? Not sure.
#  mutate(dep_actual = ifelse(is.na(dep_actual), dep_estimated, dep_actual)) %>%

arrivals_dd <- get_live_flight_data("arrivals", "YYZ")

# Note: If dep_actual is missing, dep_estimated is used instead.
# This may skew results as dep_estimated probably included mainly for delayed flights
# Rather than for those running on time

# Prepare percentages ready for plotting

data <- departures_dd
terminal_type <- "dep"

departure_percentages <- delayed_percentage(departures_dd, "dep")
arrival_percentages <- delayed_percentage(arrivals_dd, "arr")






# Speedometer style donut chart - key markers at 60 and 70% threshold
plot_donut_chart(departure_percentages, "Departures")
plot_donut_chart(arrival_percentages, "Arrivals")


# Testing
#flight_type <- "departures"
#airport <- "YYZ"

list.files("Shiny/Data/departures")
list.files("Shiny/Data/arrivals")


data1 <- read.csv("Shiny/Data/departures/YYZ_departures_1506_0013.csv")
data2 <- read.csv("Shiny/Data/departures/YYZ_departures_1506_0026.csv")

joined <- bind_rows(data1, data2)  %>%
         #distinct(.keep_all = TRUE) %>%
         arrange(dep_time, airport_name) %>%
         filter(airport_name != lag(airport_name, default = "")) %>%
         filter(!is.na(airport_name))

#### Data Extraction

# This data has since been added into the package

# # Make use of the airlabs_api function to extract the data we need.
# # Function accepts varying endpoints
# 
# # 1: Real-Time flights
# # Live data for 10s of thousands of flights worldwide
# flights <- get_airlabs_api_response(key = "flights")
# 
# # 2: Airport Lookup codes
# # Remove redundant fields with select command
# airports <- get_airlabs_api_response(key = "airports") %>% select(-c(lat, lng, icao_code))
# 
# # Example 3: Airline Lookup codes
# # Match airport code with airport name
# airlines <- get_airlabs_api_response(key = "airlines")




#### Data Handling
# For markdown purposes

# Now we have the arrivals and departures data we need, let's carry out some more focused analysis
# Remember, same flight may be listed for multiple flight providers. Confusing & problematic.
# Use extract_departures() function - Uses str_detect() to filter on individual days.
# Remember, only shows 10 Hour period

# Markdown bug - low priority

# Select one day worth of data
departures_lax <- extract_departures(parameter_value = "LAX", date = "2023-06-16") 

departures_yyz <- extract_departures(parameter_value = "YYZ", date = "2023-06-14") 

departures_lhr <- extract_departures(parameter_value = "LHR", date = "2023-06-14") 


#parameter_value = "LHR" 
#date = "2023-06-14"



# Write output to Markdown location for use in our AI genertaed reports
write.csv(departures_lax, "Markdown/Data/LAX_departures_dd.csv", row.names = F)
write.csv(departures_yyz, "Markdown/Data/YYZ_departures_dd.csv", row.names = F)
write.csv(departures_lhr, "Markdown/Data/LHR_departures_dd.csv", row.names = F)




