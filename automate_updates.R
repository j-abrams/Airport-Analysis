



# Define your code here
my_code <- function() {
  departures_dd <- get_live_flight_data("departures", "YYZ") 
  arrivals_dd <- get_live_flight_data("arrivals", "YYZ")
}


# Define the interval in seconds (20 minutes = 1200 seconds)
interval <- 1200


# Run the code repeatedly
while (TRUE) {
  my_code()
  Sys.sleep(interval)
}
