write_csv(df_bank_macro, "JP Morgan.csv")
library(readr)
write_csv(df_bank_macro, "Huntington.csv")
write_csv(df_bank_macro, "Park National.csv")

# Load required libraries
library(dplyr)
library(readr)
library(ggplot2)

# Load the datasets
jp_morgan <- read_csv("/Users/kazinafis/Downloads/JP_Morgan.csv")
huntington <- read_csv("/Users/kazinafis/Downloads/Huntington.csv")
park_national<- read_csv("/Users/kazinafis/Downloads/Park_National.csv")
supervisory_adverse <- read_csv("/Users/kazinafis/Downloads//2024-Table_4A_Supervisory_Severely_Adverse_Domestic.csv")

# Function to generate descriptive statistics
generate_stats <- function(data, variables) {
  data %>% 
    select(all_of(variables)) %>%
    summary()
}

# Function to plot histograms for each variable
plot_histograms <- function(data, variables) {
  for (variable in variables) {
    p <- ggplot(data, aes_string(x = variable)) +
      geom_histogram(bins = 30, fill = "blue", color = "black") +
      ggtitle(paste("Distribution of", variable))
    print(p)
  }
}

# Generate and print descriptive statistics for each dataset
cat("JP Morgan Descriptive Statistics:\n")
print(generate_stats(jp_morgan_data, c('Real.GDP.growth', 'Unemployment.rate', 'CPI.inflation.rate', 'Mortgage.rate', 'BBB.corporate.yield', 'DRLNLS')))

cat("\nHuntington Descriptive Statistics:\n")
print(generate_stats(huntington_data, c('Real.GDP.growth', 'Unemployment.rate', 'CPI.inflation.rate', 'Mortgage.rate', 'BBB.corporate.yield', 'DRLNLS')))

cat("\nPark National Descriptive Statistics:\n")
print(generate_stats(park_national_data, c('Real.GDP.growth', 'Unemployment.rate', 'CPI.inflation.rate', 'Mortgage.rate', 'BBB.corporate.yield', 'DRLNLS')))

cat("\nSupervisory Severely Adverse Conditions Descriptive Statistics:\n")
print(generate_stats(supervisory_data, c('Real.GDP.growth', 'Unemployment.rate', 'CPI.inflation.rate', 'Mortgage.rate', 'BBB.corporate.yield')))

# Plot histograms for a specific dataset
cat("\nPlotting histograms for JP Morgan Data:\n")
plot_histograms(jp_morgan_data, c('Real.GDP.growth', 'Unemployment.rate', 'CPI.inflation.rate', 'Mortgage.rate', 'BBB.corporate.yield', 'DRLNLS'))

# Descriptive Statistics Function
describe_data <- function(data) {
  data %>%
    summarise(
      Count = n(),
      Mean = mean(DRLNLS, na.rm = TRUE),
      SD = sd(DRLNLS, na.rm = TRUE),
      Min = min(DRLNLS, na.rm = TRUE),
      Median = median(DRLNLS, na.rm = TRUE),
      Max = max(DRLNLS, na.rm = TRUE)
    )
}

# Apply the function to each dataset
jp_morgan_stats <- describe_data(jp_morgan)
huntington_stats <- describe_data(huntington)
park_national_stats <- describe_data(park_national)
supervisory_adverse_stats <- supervisory_adverse %>% 
  summarise_all(.funs = funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE), min(., na.rm = TRUE), median(., na.rm = TRUE), max(., na.rm = TRUE)))

# Print the statistics
print(jp_morgan_stats)
print(huntington_stats)
print(park_national_stats)
print(supervisory_adverse_stats)

# Data Visualization: Histograms of DRLNLS for each dataset
ggplot(jp_morgan, aes(x = DRLNLS)) +
  geom_histogram(bins = 30, fill = "blue") +
  ggtitle("JP Morgan - DRLNLS Distribution")

ggplot(huntington, aes(x = DRLNLS)) +
  geom_histogram(bins = 30, fill = "red") +
  ggtitle("Huntington - DRLNLS Distribution")

ggplot(park_national, aes(x = DRLNLS)) +
  geom_histogram(bins = 30, fill = "green") +
  ggtitle("Park National - DRLNLS Distribution")

# Supervisory Adverse Data: Plotting all numeric variables
supervisory_adverse %>%
  gather(key = "variable", value = "value", -Scenario) %>%
  ggplot(aes(x = value)) +
  geom_histogram(bins = 30, fill = "orange") +
  facet_wrap(~variable, scales = "free_x") +
  ggtitle("Supervisory Adverse Conditions - Variable Distributions")
