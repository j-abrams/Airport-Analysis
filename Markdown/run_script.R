

# Report info.


# Update all markdown scripts at once using a loop
airport_names_list <- list(
  c("LAX", "Thomas Bradley, LAX"),
  c("YYZ", "Toronto Pearson"),
  c("LHR", "London Heathrow")
)

for (airport_names in airport_names_list) {
  update_markdown(airport_names)
}




#### Extension
# Use RegEx operations to complete word count and estimate reading time

# Read the Markdown document
markdown_document <- readLines("Markdown/Reports/template.Rmd")

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






