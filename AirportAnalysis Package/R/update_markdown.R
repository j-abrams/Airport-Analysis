



#' Dynamically update Markdown reports based on airport names
#'
#' This function reads a template Markdown script and performs placeholder replacements
#' based on the provided airport names. The updated Markdown script is then saved to
#' a new file with the corresponding airport name.
#'
#' @param airport_names A character vector of airport names for replacement
#' @examples
#' update_markdown(c("LAX", "Los Angeles International Airport"))
#' @export



# Dynamically update our Markdown reports with this function.
# Use the template.Rmd as a starting point

update_markdown <- function(airport_names) {
  # Read the Markdown script
  in_path <- "AirportAnalysis Markdown/Reports/template.Rmd"
  out_path <- paste0("AirportAnalysis Markdown/Reports/", airport_names[1], ".Rmd")
  
  markdown_script <- readLines(in_path)
  
  # Define the placeholders
  placeholders <- c("{airport}", "{airport_name}")
  
  # Perform multiple replacements in one step using a for loop
  for (i in seq_along(placeholders)) {
    markdown_script <- gsub(placeholders[i], airport_names[i], markdown_script, fixed = TRUE)
  }
  
  # Save the updated Markdown script
  writeLines(markdown_script, out_path)
}


# Usage example:
#airport_names <- c("LAX", "Thomas Bradley, LAX")
#airport_names <- c("YYZ", "Totonto Pearson")
#airport_names <- c("LHR", "London Heathrow")

#update_markdown(airport_names)


