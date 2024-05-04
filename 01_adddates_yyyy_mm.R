# Load necessary libraries
library(dplyr)
library(lubridate)
library(stringr)

# Example of your existing data frame setup, assuming DATE column exists
# df_bank_data <- data.frame(DATE = as.Date(c("2013-12-31", "2014-03-31", "2015-06-30", "2016-09-30")))

# Assuming your DataFrame df_bank_data is already loaded and includes a DATE column in date format

# Function to convert date to "YYYY QQ" format with a space between the year and the quarter
convert_to_quarter_space <- function(date) {
  year <- year(date)
  quarter <- quarter(date)
  paste0(year, " Q", quarter)  # Concatenation with a space before "Q"
}

# Function to convert date to "YYYYQQ" format without a space
convert_to_quarter_nospace <- function(date) {
  year <- year(date)
  quarter <- quarter(date)
  paste0(year, "Q", quarter)  # Direct concatenation without a space
}

# Add new columns 'YYYY QQ' with a space and 'YYYYQQ' without a space
df_bank_data <- df_bank_data %>%
  mutate(
    YYYY_QQ = sapply(DATE, convert_to_quarter_space),
    YYYYQQ = sapply(DATE, convert_to_quarter_nospace)
  )


