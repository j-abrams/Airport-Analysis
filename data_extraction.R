



# TODO: Everything working well.
# 1. Next steps - tidy up markdown scripts
# - Figure out how to load my AirportAnalysis library into the script to reduce replicating code, 
# defining functions etc.
#
# 2. Arrivals + Departures
# Keep collecting data
# - Daily analysis
# - Leeds Bradford?

# 3. Baggage api?


# Package setup

# Initiate

source("global.R")


roxygen2::roxygenise("./AirportAnalysis Package")

# Build the package
devtools::build("./AirportAnalysis Package")

# Install
install.packages("C:/Users/james/OneDrive/Documents/AirportAnalysis_0.1.0.tar.gz")
#devtools::install("./AirportAnalysis Package")

library(AirportAnalysis)


#### Data Extraction

# Make use of the airlabs_api function to extract the info we need.
# Function accepts varying endpoints

# Example 1: Real-Time flights
flights <- airlabs_api_function(key = "flights")

# Example 2: Airport Lookup codes
airports <- airlabs_api_function(key = "airports") %>%
  select(-c(lat, lng, icao_code))  # Remove redundant fields

# Example 3: Airline Lookup codes
airlines <- airlabs_api_function(key = "airlines")



#### Data Handling

# Now we have the arrivals and departures data we need, let's carry out some more focused analysis
# Remember, same flight may be listed for multiple flight providers. Confusing & problematic.
# Use this function

departures_lax <- extract_departures(parameter_value = "LAX")
departures_yyz <- extract_departures(parameter_value = "YYZ")
departures_lhr <- extract_departures(parameter_value = "LHR")



# Write output to Markdown location for use in our AI genertaed reports
write.csv(departures_lax, "Markdown/LAX_departures_dd.csv", row.names = F)
write.csv(departures_yyz, "Markdown/YYZ_departures_dd.csv", row.names = F)
write.csv(departures_lhr, "Markdown/LHR_departures_dd.csv", row.names = F)





lab <- read.csv("Markdown/LAX_departures_dd.csv")





#Bar chart: Number of flights by each airline (airline_name) or airport (airport_name). This chart will show the distribution of flights among different airlines or airports.

#Line chart: Departure time (dep_time) trends over time. You can plot the average departure time or the number of flights departing at different times of the day to identify any patterns or peak hours.

#Pie chart: Proportion of flights to top airports (top_airports) or top airlines (top_airlines). This chart will give you an overview of the market share of different airports or airlines.

#Stacked bar chart: Number of flights to different destinations (destination) by each airline or airport. This chart will show the distribution of flights to various destinations by different airlines or airports.

#Scatter plot: Relationship between departure time (dep_time) and average delay time. Each point represents a flight, and you can analyze if there is any correlation between the departure time and delay time.

# 2.
# Calculate the number of flights by airport
# Convert dep_time to Date format
#install.packages("scales")
library(scales)

lab %>%
  mutate(dep_time = as.POSIXct(dep_time)) %>%
  mutate(dep_time_interval = cut(dep_time, breaks = "hour")) %>%
  group_by(dep_time_interval) %>%
  count() %>%
  mutate(dep_time_interval = as.POSIXct(as.character(dep_time_interval))) %>%
  ggplot(aes(x = dep_time_interval, y = n)) +
  geom_line() +
  scale_x_datetime(labels = function(x) format(x, "%Y-%m-%d %H:%M:%S")) +
  labs(x = "Time Interval", y = "Number of Flights",
       title = "Number of Flights Over Time") +
  theme_minimal()

# 4. Stacked bar chart: Number of flights to different destinations (destination) by each airline or airport. 
# This chart will show the distribution of flights to various destinations by different airlines or airports.
 
lab %>%
  count(airport_name, airline_name) %>%
  top_n(10, n) %>%
  ggplot(aes(x = airport_name, y = n, fill = airline_name)) +
  geom_bar(stat = "identity") +
  labs(x = "Destination", y = "Number of Flights",
       title = "Number of Flights to Different Destinations by Airline") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_viridis_d()  # Adjust the color palette as desired




#### Delays

# TODO: Put this all in a function.and add to markdown
# TODO: Markdown - why can't i load my library 

directory <- "Raw_Data/LHR/"
threshold <- 6062300  # First time stamp where delay data was collected
delays <- delays_function(directory, threshold)

output <- analyse_delays("Raw_Data/LHR/", 6062300)


print(output[[1]])
print(output[[2]])
print(output[[3]])
print(output[[4]])


library(AirportAnalysis)

# Good work. Priorities this afternoon

# 1. Delay chart
# 2. Daily analysis for each airport? Keep collecting data first I think

# 3. Data so far only accounts for departures. Extend to include arrivals in there too somehow.
#    - Departure and arrival location in to one field.
#    - Same with arrival and departure time?
# 4. Extension : Baggage API?


# DONE.

# 3. Delays endpoint - Can we use this 
# 1. Peak hours bar chart - add figures for inactive hours between 1 and 5
# 2. Dynamically update markdown reports
#
# TODO: Rename "extract_and_analyze_data"
# TODO: Split functions in to separate scripts, package style
# TODO: Setup github project.
# TODO: Periodically update departure data - 
# the 10 hour constraint currently causing limitations. solution - ish - not automated 





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




