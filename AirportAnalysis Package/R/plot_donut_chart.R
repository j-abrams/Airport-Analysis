

#' Create a donut chart to visualize performance metrics
#'
#' This function takes a data frame containing performance metrics and creates a donut chart
#' to visualize the percentages of flights that are on time, within 15 minutes, and late.
#' The chart is presented in a speedometer style.
#'
#' @param percentage_df A data frame containing the calculated percentages and counts for each category.
#'                      Must have columns "Category", "Percentage", and "Flights".
#' @param title A character string specifying the title of the chart.
#'
#' @examples
#' plot_donut_chart(percentage_df, "Departures")
#' plot_donut_chart(percentage_df, "Arrivals")
#'
#' @export

# Return Donut chart, speedometer style - analyzing performance metrics

plot_donut_chart <- function(percentage_df, title) {
  
  # Combine "On_Time" and "Within_15_Minutes" categories and calculate sum
  percentage_df <- percentage_df %>%
    mutate(Category = ifelse(Category %in% c("On_Time", "Within_15_Minutes"), "Within_15_Mins", Category)) %>%
    group_by(Category) %>%
    summarise(Percentage = sum(Percentage), Flights = sum(Flights)) %>%
    mutate(Category = factor(Category, levels = c("Within_15_Mins", "Late")))
  
  donut_chart <- ggplot(percentage_df, aes(x = "", y = Percentage, fill = Category)) +
    geom_bar(width = 1, stat = "identity", color = "white") +
    coord_polar("y", start = 0) +
    #geom_text(aes(label = Flights),
    #          position = position_stack(vjust = 0.5),
    #          hjust = 1,
    #          color = "black",
    #          size = 4) +
    scale_fill_manual(values = case_when(
      percentage_df$Percentage[2] > 70 ~ c("#98FB98", "lightgrey"),
      percentage_df$Percentage[2] > 60 ~ c("#FFD700", "lightgrey"),
      TRUE ~ c("#FF8C8C","lightgrey")
    )) +
    labs(title = paste("Percentage of Flight", title, "Within 15 Minutes, and Late"),
         x = NULL, y = NULL) +
    theme_void() +
    geom_polygon(data = data.frame(x = c(-0.1, 0.1), y = c(-Inf, -Inf)), aes(x, y), fill = "white") +
    geom_hline(yintercept = c(40, 30), color = "blue", linetype = "dashed", size = 1) +
    geom_hline(yintercept = 0, color = "black", linetype = "solid", size = 1) +
    geom_text(data = data.frame(y = c(40, 30), label = paste0(" ", c(60, 70), "%")),
              aes(x = 1.75, y = y, label = label),
              inherit.aes = FALSE,
              hjust = 0,
              color = "black",
              size = 4)
  
  print(donut_chart)
  return(donut_chart)
  
}


