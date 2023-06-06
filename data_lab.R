



# Questions?

# Most popular destinations - domestic or international?
# Most popular airlines?
# Peak hours? 

LAX_departures_dd <- departures_lax

# Select the top 10 airports and reorder them by number of departures
top_airports <- LAX_departures_dd %>%
  select(-c(airline_name, top_airlines, dep_time)) %>%
  distinct() %>%
  select(airport_name, top_airports) %>%
  arrange(desc(top_airports)) %>%
  head(10) %>%
  as.data.frame()


# Select the top 10 airlines and reorder them by number of departures
top_airlines <- LAX_departures_dd %>%
  select(-c(airport_name, top_airports, destination, dep_time)) %>%
  filter(!is.na(airline_name)) %>%
  distinct() %>%
  select(airline_name, top_airlines) %>%
  arrange(desc(top_airlines)) %>%
  head(10) %>%
  as.data.frame()



plot_bar_chart(top_airports, airport_name, top_airports,
               "Airport", "Number of Departures",
               "Top 10 Most Popular Airports Destinations")

plot_bar_chart(top_airlines, airline_name, top_airlines,
               "Airline", "Number of Departures",
               "Top 10 Most Popular Airlines")





#### International / Domestic?

# Calculate the proportion of domestic and international Flights
flight_proportions <- LAX_departures_dd %>%
  group_by(destination) %>%
  summarize(total = n()) %>%
  mutate(proportion = total / sum(total))

# Create the pie chart
ggplot(flight_proportions, aes(x = "", y = proportion, fill = destination)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  scale_fill_manual(values = c("Domestic" = "turquoise", "International" = "pink")) +
  theme_void() +
  labs(fill = "Flight Type") +
  ggtitle("Proportion of Domestic vs International Flights") +
  geom_text(aes(label = paste0(round(proportion * 100), "%")), position = position_stack(vjust = 0.5))






#### Most Popular times of day?


# Use 24 hour clock format for this exercise
peak_hours <- LAX_departures_dd %>%
  select(dep_time) %>%
  mutate(dep_time = as.POSIXct(dep_time)) %>%
  mutate(timeslot = floor_date(dep_time, "hour")) %>%
  mutate(timeslot = format(timeslot, format = "%H")) %>%
  group_by(timeslot) %>%
  summarize(total = n()) %>%
  arrange(-desc(as.numeric(timeslot)))
  

# Convert timeslot to a factor with ordered levels
peak_hours$timeslot <- factor(peak_hours$timeslot, levels = unique(peak_hours$timeslot), ordered = TRUE)


# Plot the time series bar chart
# Map busiest periods for the airport.
ggplot(peak_hours, aes(x = timeslot, y = total)) +
  geom_bar(stat = "identity", fill = "seagreen") +
  scale_x_discrete(labels = function(x) paste0(x, ":00")) +
  labs(x = "Timeslot", y = "Total") +
  ggtitle("Time Series Bar Chart Showing Airport Peak Hours by departures per hour") +
  theme_minimal()



