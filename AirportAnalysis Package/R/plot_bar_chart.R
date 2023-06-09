



#' Plot Bar Chart
#'
#' This function creates a bar chart using the ggplot2 package.
#' Plots top airlines and top destinations
#'
#' @param data The data frame containing the data to plot.
#' @param x The variable to use for the x-axis.
#' @param y The variable to use for the y-axis.
#' @param lab_x The label for the x-axis.
#' @param lab_y The label for the y-axis.
#' @param title The title of the plot.
#'
#' @return A bar chart plot.
#'
#' @import ggplot2
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_bar
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 ggtitle
#' @importFrom ggplot2 theme_minimal
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 element_text
#' @export
#'
#' @examples
#' # Create a bar chart
#' plot_bar_chart(data = my_data, x = variable1, y = variable2,
#'                lab_x = "X-axis label", lab_y = "Y-axis label", title = "Bar Chart")




# Plotting function for bar charts (also used in markdown script).
plot_bar_chart <- function(data, x, y, lab_x, lab_y, title) {
  ggplot(data, aes(x = reorder({{ x }}, {{ y }}), y = {{ y }})) +
    geom_bar(stat = "identity", fill = "skyblue", width = 0.5) +
    labs(x = lab_x, y = lab_y) +
    ggtitle(title) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}


