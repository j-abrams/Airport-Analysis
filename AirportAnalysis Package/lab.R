
stacked_donut <- function(percentage_df, title) {
  
  # Create a donut chart using ggplot2
  percentage_df$Category <- factor(percentage_df$Category, levels = c("On_Time", "Within_15_Minutes", "Late"))
  
  
  
  donut_chart <- ggplot(percentage_df, aes(x = "", y = Percentage, fill = Category)) +
    geom_bar(width = 1, stat = "identity", color = "white") +
    coord_polar("y", start = 0) +
    geom_text(aes(label = Flights),
              position = position_stack(vjust = 0.5),
              hjust = 1,
              color = "black",
              size = 4) +
    scale_fill_manual(values = case_when(
      percentage_df$Label[2] > 70 ~ c("#98FB98", "#66BB6A", "white"),
      percentage_df$Label[2] > 60 ~ c("#FFD700", "#FFC200", "white"),
      TRUE ~ c("#FFD1D1", "#FF8C8C","white")
    )) +
    labs(title = paste("Percentage of Flights", title, "On Time, Within 15 Minutes, and Late"),
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
  #print(stacked_bar_chart)
}




# Create a stacked bar chart using ggplot2
stacked_bar_chart <- ggplot(percentage_df, aes(x = terminal, y = Percentage, fill = factor(Category, levels = c("Late", "Within_15_Minutes", "On_Time")))) +
  geom_bar(stat = "identity", color = "white") +
  geom_text(aes(label = paste0("Flights: ", Flights, "
", round(Label, 1), "%")), position = position_stack(vjust = 0.5), color = "black", size = 4) +
  scale_fill_manual(values = c("#EF5350", "#FFEE58", "#66BB6A"),
                    labels = c("Late", "Within 15 Minutes", "On Time")) +
  labs(title = paste("Percentage of Flights", title, "On Time, Within 15 Minutes, and Late by Terminal"),
       x = "Terminal", y = "Percentage", fill = "Category") +
  theme_minimal()




