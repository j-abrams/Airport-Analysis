


# Delays (for flights delayed over 30 mins)
# Calculate average delay time
# Calculate proportion of flights delayed


# Minimum 30 mins for delay
# 
delays <- read.csv("Raw_Data/LAX/LAX_departures_0606_2309.csv") %>%
  select(dep_time, arr_iata, delayed)

# Calculate average delay time
average_delay <- round(mean(delays$delayed, na.rm = TRUE), 0)

# Calculate proportion of flights which are delayed
proportion_delayed <- delays %>%
  summarize(proportion_delayed = 1 - sum(is.na(delayed)) / n())

  

  