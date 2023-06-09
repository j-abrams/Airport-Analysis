


# Usage
departures_dd <- get_live_flight_data("departures", "YYZ")
arrivals_dd <- get_live_flight_data("arrivals", "YYZ")


# Usage
departure_percentages <- delayed_percentage(departures_dd, "dep")
arrival_percentages <- delayed_percentage(arrivals_dd, "arr")
#percentage_df <- departure_percentages


# Usage
plot_donut_chart(departure_percentages, "Departures")
plot_donut_chart(arrival_percentages, "Arrivals")



