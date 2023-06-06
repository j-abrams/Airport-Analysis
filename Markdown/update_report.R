



# Dynamically update our Markdown reports with this script.
# Use the template as a starting point

# Read the Markdown script
markdown_script <- readLines("Markdown/template.Rmd")



# Define the placeholders and airport names
placeholders <- c("{airport}", "{airport_name}")
#airport_names <- c("LAX", "Tom Bradley terminal, LAX")  # Replace with the desired airport names
#airport_names <- c("YYZ", "Toronto Pearson")  # Replace with the desired airport names
airport_names <- c("LHR", "London Heathrow")  # Replace with the desired airport names

# Perform multiple replacements in one step using a for loop
updated_script <- markdown_script
for (i in seq_along(placeholders)) {
  updated_script <- gsub(placeholders[i], airport_names[i], updated_script, fixed = TRUE)
}

# Save the updated Markdown script
writeLines(updated_script, "Markdown/LHR.Rmd")



#### Extension
# Use RegEx operations to complete word count and estimate reading time

# Read the Markdown document
markdown_document <- updated_script

# Combine all lines into a single string
document_text <- paste(markdown_document, collapse = " ")

# Remove Markdown formatting
document_text <- gsub("\\[(.*?)\\]", "", document_text)  # Remove square brackets and their content
document_text <- gsub("\\[(.*?)\\]\\((.*?)\\)", "", document_text)  # Remove hyperlinks

# Remove non-word characters and convert to lowercase
document_text <- tolower(gsub("[^[:alnum:][:space:]]+", "", document_text))

# Split the document into words
words <- strsplit(document_text, "\\s+")

# Count the number of words and print the word count
word_count <- length(unlist(words))
print(word_count)

# Set average reading speed (in words per minute)
average_reading_speed <- 200

# Calculate the estimated reading time (in minutes)
reading_time <- round(word_count / average_reading_speed, 0)

# Print the estimated reading time
print(paste(reading_time, "minutes"))






