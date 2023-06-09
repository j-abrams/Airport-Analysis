

#' Analyze delays in airlines
#'
#' This function analyzes delay data for airlines based on a given directory
#' and threshold.
#'
#' @param directory The directory containing the delay data files.
#' @param threshold The threshold for the delay data collection.
#'
#' @return A list containing three charts and a data table.
#' @export


analyse_delays <- function(directory, threshold) {
  delays <- get_delays(directory, threshold)
  
  test <- delays[[3]] %>%
    group_by(airline_iata) %>%
    mutate(total_flights = n()) %>%
    filter(!is.na(delayed)) %>%
    arrange(desc(delayed)) %>%
    left_join(airlines, by = c("airline_iata" = "iata_code")) %>%
    select(airline_iata, name, total_flights, delayed)
  
  # Airlines with most delays (Total)
  
  chart1 <- test %>%
    count(name) %>%
    arrange(desc(n)) %>%
    head(10) %>%
    mutate(name = factor(name, levels = name)) %>%
    ggplot(aes(x = reorder(name, n), y = n, fill = name)) +
    geom_bar(stat = "identity") +
    labs(x = "Airline", y = "Number of Delays", title = "Number of Delays per Airline") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    guides(fill = guide_legend())
  
  # Airlines with longest delay times (Total)
  chart2 <- test %>%
    group_by(name) %>%
    summarize(average_delay = mean(delayed)) %>%
    slice_max(order_by = average_delay, n = 10) %>%
    ggplot(aes(x = reorder(name, average_delay), y = average_delay, fill = name)) +
    geom_bar(stat = "identity") +
    labs(x = "Airline", y = "Average Delay Time (minutes)", title = "Top Airlines: Average Delay Time") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_fill_discrete(guide = guide_legend(reverse = TRUE))
  
  # Worst performing airlines amongst biggest airlines
  # Calculate total flights, number of delays, and average delay per airline
  table <- test %>%
    group_by(name) %>%
    reframe(total_flights = total_flights,
            num_delays = sum(!is.na(delayed)),
            average_delay = mean(delayed, na.rm = TRUE)) %>%
    mutate(proportion_delayed = num_delays / total_flights) %>%
    arrange(desc(total_flights)) %>%
    filter(total_flights > 10) %>%  # Define Sensible threshold. Azerbaijan airlines had one flight and one delay
    distinct() %>%
    arrange(desc(proportion_delayed)) %>%
    head(10)
    
  chart3 <- table %>%  
    ggplot(aes(x = reorder(name, proportion_delayed), y = proportion_delayed, fill = average_delay)) +
    geom_bar(stat = "identity") +
    labs(x = "Airline", y = "Proportion of Flights Delayed", title = "Worst Performing Airlines: Proportion of Flights Delayed") +
    scale_fill_viridis_c(option = "A", direction = -1) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  return(list(chart1, chart2, chart3, table))
  
}



