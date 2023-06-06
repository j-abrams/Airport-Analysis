



# Package setup

# Initiate
source("global.R")
roxygen2::roxygenise()

# Build the package
devtools::build()

# Install
install.packages("C:/Users/james/OneDrive/Documents/AirportAnalysis_0.1.0.tar.gz")




#### Data Extraction

# Make use of the airlabs_api function to extract the info we need.
# Function accepts varying endpoints

# Example 1: Real-Time flights
flights <- airlabs_api_function(key = "flights")

# Example 2: Airport Lookup codes
airports <- airlabs_api_function(key = "airports") %>% select(-c(lat, lng, icao_code))  # Remove redundant fields

# Example 3: Airline Lookup codes
airlines <- airlabs_api_function(key = "airlines")



#### Data Handling

# Now we have the arrivals and departures data we need, let's carry out some more focused analysis
# Use this function

departures_lax <- extract_departures(parameter_value = "LAX")
departures_yyz <- extract_departures(parameter_value = "YYZ")
departures_lhr <- extract_departures(parameter_value = "LHR")


write.csv(departures_lhr, "Raw_Data/LAX_departures_dd.csv", row.names = F)




# TODO: Figure out how to use arrivals and departures combined. 
# Departure and arrival location in to one field.
# Same with arrival and departure time?
#
# TODO: Update markdown document so text and narrative updates dynamically.
# TODO: Investigate Delays Endpoint
# TODO: Any other interesting questions we can answer with the data we have?
# TODO: Periodically update departure data - 
# the 10 hour constraint currently causing limitations.
# TODO: Baggage API?
#
# TODO: Rename "extract_and_analyze_data"
# TODO: Split functions in to separate scripts, package style
# TODO: Setup github project.
# TODO: Peak hours bar chart - add figures for inactive hours between 1 and 5

# Remember, same flight may be listed for multiple flight providers. Confusing





# lab

# Examples 4: Scheduled arrivals at LAX
# This shows data for the next 10 hours at most.
# Arrivals
# scheduled_arrivals <- airlabs_api_function(key = "schedules", 
#                                            parameter_name = "arr_iata", 
#                                            parameter_value = "LAX") %>%
#   distinct(dep_iata, arr_time, .keep_all = TRUE)
# 
# arrivals <- scheduled_arrivals %>%
#   filter(arr_terminal == "TBIT") %>%
#   select(all_of(fields_arrivals))
# Example 5: Departures from LAX
# Example 6: Delays?




