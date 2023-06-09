



# TODO: tomorrow

# 1. Fine tuning markdown scripts - Tidy Markdown folders, keep data and reports separate
# 2. Add update_report function to my package
# 3. Tidy up existing functions - re factor code, use dplyr where possible
# 4. Tidy stacked_bar_chart script
# - ADD SPEEDOMETER INTO MY REPORT?
# 5. Annotate code
#
# - Figure out how to load my AirportAnalysis library into the script to reduce replicating code, 
# - Make sure functions in template.Rmd consistent with those in my package
#
# Extension 
# * Arrivals + Departures
#
# * Keep collecting data
# - Daily analysis
# - Leeds Bradford?
# * Investigate automating data collection every 8 hours...
# * Baggage api?



# Package setup
# Initiate packages and hard coded variables.
source("global.R")

# Use roxygen2 comments to document functions in my package
roxygen2::roxygenise("./AirportAnalysis Package")

# Build the package
devtools::build("./AirportAnalysis Package")

# Install the package from specified location
install.packages("C:/Users/james/OneDrive/Documents/AirportAnalysis_0.1.0.tar.gz")
#devtools::install("./AirportAnalysis Package")

# Load the package
library(AirportAnalysis)



#### Data Extraction

# Make use of the airlabs_api function to extract the data we need.
# Function accepts varying endpoints

# 1: Real-Time flights
# Live data for 10s of thousands of flights worldwide
flights <- get_airlabs_api_response(key = "flights")

# 2: Airport Lookup codes
# Remove redundant fields with select command
airports <- get_airlabs_api_response(key = "airports") %>% select(-c(lat, lng, icao_code))


# Example 3: Airline Lookup codes
# Match airport code with airport name
airlines <- get_airlabs_api_response(key = "airlines")


#### Data Handling

# Now we have the arrivals and departures data we need, let's carry out some more focused analysis
# Remember, same flight may be listed for multiple flight providers. Confusing & problematic.
# Use extract_departures() function

departures_lax <- extract_departures(parameter_value = "LAX")
departures_yyz <- extract_departures(parameter_value = "YYZ")
departures_lhr <- extract_departures(parameter_value = "LHR")


# Write output to Markdown location for use in our AI genertaed reports
write.csv(departures_lax, "Markdown/Data/LAX_departures_dd.csv", row.names = F)
write.csv(departures_yyz, "Markdown/Data/YYZ_departures_dd.csv", row.names = F)
write.csv(departures_lhr, "Markdown/Data/LHR_departures_dd.csv", row.names = F)



# Put this all in one function?
# Return data for which actual arrival and departure times have already been returned
# About a half hour delay? Updated incrementally
departures_dd <- get_live_flight_data("departures", "YYZ")
arrivals_dd <- get_live_flight_data("arrivals", "YYZ")

# Prepare percentages ready for plotting
departure_percentages <- delayed_percentage(departures_dd, "dep")
arrival_percentages <- delayed_percentage(arrivals_dd, "arr")

# Speedometer style donut chart - key markers at 60 and 70% threshold
plot1 <- plot_donut_chart(departure_percentages, "Departures")
plot2 <- plot_donut_chart(arrival_percentages, "Arrivals")

# Export the plot to a specified file path
ggsave(filename = "Markdown/Reports/departures_plot.png", plot = plot1, dpi = 300)
ggsave(filename = "Markdown/Reports/arrivals_plot.png", plot = plot2, dpi = 300)



# Concept:
#Scatter plot: Relationship between departure time (dep_time) and average delay time. 


# Exploratory
# Calculate the number of flights by airport
# Convert dep_time to Date format
#install.packages("scales")
# library(scales)
# 
# lab <- read.csv("Markdown/Data/LAX_departures_dd.csv")
# 
# lab %>%
#   mutate(dep_time = as.POSIXct(dep_time)) %>%
#   mutate(dep_time_interval = cut(dep_time, breaks = "hour")) %>%
#   group_by(dep_time_interval) %>%
#   count() %>%
#   mutate(dep_time_interval = as.POSIXct(as.character(dep_time_interval))) %>%
#   ggplot(aes(x = dep_time_interval, y = n)) +
#   geom_line() +
#   scale_x_datetime(labels = function(x) format(x, "%Y-%m-%d %H:%M:%S")) +
#   labs(x = "Time Interval", y = "Number of Flights",
#        title = "Number of Flights Over Time") +
#   theme_minimal()
# 
# # Stacked bar chart: Number of flights to different destinations (destination) by each airline or airport. 
# # This chart will show the distribution of flights to various destinations by different airlines or airports.
#  
# lab %>%
#   count(airport_name, airline_name) %>%
#   top_n(10, n) %>%
#   ggplot(aes(x = airport_name, y = n, fill = airline_name)) +
#   geom_bar(stat = "identity") +
#   labs(x = "Destination", y = "Number of Flights",
#        title = "Number of Flights to Different Destinations by Airline") +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
#   scale_fill_viridis_d()  # Adjust the color palette as desired
# 
# 
# Examples 4: Scheduled arrivals at LAX
# This shows data for the next 10 hours at most.
# Arrivals
# scheduled_arrivals <- get_airlabs_api_response(key = "schedules", 
#                                                parameter_name = "arr_iata", 
#                                                parameter_value = "LAX") %>%
#   distinct(dep_iata, arr_time, .keep_all = TRUE)
# 
# arrivals <- scheduled_arrivals %>%
#   filter(arr_terminal == "TBIT") %>%
#   select(all_of(fields_arrivals))




