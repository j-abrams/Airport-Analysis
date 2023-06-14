


#' Calculate the percentage of delayed flights
#'
#' This function takes flight data and calculates the percentage of flights that are on time,
#' within 15 minutes of the scheduled time, and late. The calculations can be performed for
#' either departure or arrival flights based on the specified terminal type.
#'
#' @param data A data frame containing flight data.
#' @param terminal_type A character string specifying the terminal type.
#'                      Must be either "dep" for departures or "arr" for arrivals.
#'
#' @return A data frame with the calculated percentages and counts for each category.
#'
#' @examples
#' delayed_percentage(data, "dep")
#' delayed_percentage(data, "arr")
#'
#' @export


# Use the live flight data to calculate proportion of flights which are:
# 1. On Time
# 2. Within 15 Mins of scheduled time
# 3. Late

delayed_percentage <- function(data, terminal_type) {
  
  # Conditional
  if (terminal_type == "dep") {
    data <- data %>%
      rename("terminal" = "dep_terminal") %>%
      rename("actual" =  "dep_actual") %>%
      rename("time" = "dep_time") %>%
      mutate(actual = as.POSIXct(actual)) %>%
      mutate(time = as.POSIXct(time))
  } else if (terminal_type == "arr") {
    data <- data %>%
      rename("terminal" = "arr_terminal")%>%
      rename("actual" =  "arr_actual") %>%
      rename("time" = "arr_time") %>%
      mutate(actual = as.POSIXct(actual)) %>%
      mutate(time = as.POSIXct(time))
  }
  
  # Use dplyr::summarise and tidyr::pivot_longer
  percentage_df <- data %>%
    #group_by(terminal) %>%
    summarise(
      On_Time = sum(is.na(delayed)) / n() * 100,
      Within_15_Minutes = sum(actual - time <= 15) / n() * 100 - On_Time,
      Late = 100 - On_Time - Within_15_Minutes,
      Flights_On_Time = sum(is.na(delayed)),
      Flights_Within_15_Minutes = sum(actual - time <= 15) - Flights_On_Time, 
      Flights_Late = sum(actual - time > 15)
    ) %>%
    pivot_longer(
      cols = c(On_Time, Within_15_Minutes, Late),
      names_to = "Category",
      values_to = "Percentage"
    ) %>%
    pivot_longer(
      cols = starts_with("Flights_"),
      names_to = "Count",
      values_to = "Flights"
    ) %>%
    #filter(!is.na(terminal)) %>%
    mutate(Count = gsub("Flights_", "", Count)) %>%
    filter(Category == Count) %>%
    select(-Count) %>%
    #group_by(terminal) %>%
    mutate(Label = ifelse(Category == "Within_15_Minutes",
                          round(cumsum(Percentage), 0),
                          round(Percentage, 0))
    ) %>%
    ungroup() %>% # Add this line to remove grouping after calculations 
    mutate(Percentage = round(Percentage, 2))
           
  return(percentage_df)
  
}
