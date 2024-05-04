# Imports and setup -------------------------------------------------------
library(dplyr)
library(corrplot)

# Read data files
df_fed_hist <- read.csv("/Users/kazinafis/Downloads/2024-Table_2A_Historic_Domestic.csv")
scenario_data <- read.csv("/Users/kazinafis/Downloads/2024-Table_4A_Supervisory_Severely_Adverse_Domestic.csv")

# Data transformation ----------------------------------------------------
# Renaming and dropping columns in historical data
df_fed_hist <- df_fed_hist %>% 
  rename(YYYY_QQ = Date) 

# Merging historical macro data with bank data
df_bank_macro <- left_join(df_bank_data, df_fed_hist, by = "YYYY_QQ")

# Exploratory Analysis ----------------------------------------------------
# Calculate correlations among predictors
corr_matrix <- cor(df_bank_macro[,c("Nominal.GDP.growth", "Unemployment.rate", "CPI.inflation.rate",
                                    "X3.month.Treasury.rate", "X10.year.Treasury.yield", "BBB.corporate.yield", 
                                    "Mortgage.rate", "Dow.Jones.Total.Stock.Market.Index..Level.", 
                                    "House.Price.Index..Level.", "Commercial.Real.Estate.Price.Index..Level.", 
                                    "Market.Volatility.Index..Level.")])

# Create Recession Variables
df_bank_macro <- df_bank_macro %>%
  mutate(
    recession_great = if_else(YYYYQQ >= "2007Q4" & YYYYQQ <= "2009Q2", 1, 0),
    recession_covid = if_else(YYYYQQ >= "2019Q4" & YYYYQQ <= "2020Q2", 1, 0)
  )

# Modeling ---------------------------------------------------------------
# Baseline regression model
reg_stress_test <- lm(DRLNLS ~ Nominal.GDP.growth + Unemployment.rate + CPI.inflation.rate + 
                        BBB.corporate.yield + House.Price.Index..Level. + Market.Volatility.Index..Level. + 
                        recession_great + recession_covid, data = df_bank_macro)
summary(reg_stress_test)



# Apply stress test results to Federal Reserve Macro Scenarios ------------
# Severely Adverse Scenario
scenario_data <- scenario_data %>% 
  mutate(
    recession_great = 0,
    recession_covid = 0,
    Intercept = 1,
    Scenario.Name = "Severely Adverse"
  )

# Prepare data columns in the correct order and compute predictions
required_columns <- c("Intercept", "Nominal.GDP.growth", "Unemployment.rate", "CPI.inflation.rate",
                      "BBB.corporate.yield", "House.Price.Index..Level.", "Market.Volatility.Index..Level.",
                      "recession_great", "recession_covid")

# Check for any missing required columns and add them
missing_cols <- setdiff(required_columns, names(scenario_data))
for (col in missing_cols) {
  scenario_data[[col]] <- NA
}

# Compute predicted DRLNLS
scenario_data$predicted_DRLNLS <- as.matrix(scenario_data[, required_columns]) %*% coefficients(reg_stress_test)




# Incomplete







# Create final combined dataset -------------------------------------------



# Add missing columns in scenario_data that are present in df_bank_macro
missing_cols <- setdiff(names(df_bank_macro), names(scenario_data))
for (col in missing_cols) {
  scenario_data[[col]] <- NA  # Initialize missing columns with NA
}

# Now, safely reorder scenario_data columns to match df_bank_macro
scenario_data <- scenario_data[names(df_bank_macro)]

# Combine the data frames
combined_data <- rbind(df_bank_macro, scenario_data)

# Sort combined_data by the `YYYYQQ` column if it's used as a date indicator
combined_data <- combined_data %>%
  mutate(YYYYQQ = as.character(YYYYQQ)) %>%  # Ensure YYYYQQ is in character format for sorting
  arrange(as.Date(paste0(substr(YYYYQQ, 1, 4), "-", (as.numeric(substr(YYYYQQ, 6, 7)) - 1) * 3 + 1, "-01")))  # Convert YYYYQQ to date and sort




  # Imports and setup -------------------------------------------------------
library(dplyr)
library(corrplot)
library(readr)  # For improved CSV reading


# Modeling ---------------------------------------------------------------
# Baseline regression model
reg_stress_test <- lm(DRLNLS ~ Nominal.GDP.growth + Unemployment.rate + CPI.inflation.rate + 
                        BBB.corporate.yield + House.Price.Index..Level + Market.Volatility.Index.Level + 
                        recession_great + recession_covid, data = df_bank_macro)
summary(reg_stress_test)

# Apply stress test results to Federal Reserve Macro Scenarios ------------
# Severely Adverse Scenario
scenario_data <- scenario_data %>%
  mutate(
    recession_great = 0,
    recession_covid = 0,
    Intercept = 1,
    Scenario_Name = "Severely Adverse"
  )

# Prepare data columns in the correct order and compute predictions
required_columns <- c("Intercept", "Nominal.GDP.growth", "Unemployment.rate", "CPI.inflation.rate",
                      "BBB.corporate.yield", "House.Price.Index..Level.", "Market.Volatility.Index.Level",
                      "recession_great", "recession_covid")

# Check for any missing required columns and add them
missing_cols <- setdiff(required_columns, names(scenario_data))
for (col in missing_cols) {
  scenario_data[[col]] <- NA
}

# Compute predicted DRLNLS
scenario_data$predicted_DRLNLS <- as.matrix(scenario_data[, required_columns]) %*% coefficients(reg_stress_test)

# Create final combined dataset -------------------------------------------
# Add missing columns in scenario_data that are present in df_bank_macro
missing_cols <- setdiff(names(df_bank_macro), names(scenario_data))
for (col in missing_cols) {
  scenario_data[[col]] <- NA  # Initialize missing columns with NA
}

# Now, safely reorder scenario_data columns to match df_bank_macro
scenario_data <- scenario_data[names(df_bank_macro)]

# Combine the data frames
combined_data <- rbind(df_bank_macro, scenario_data)

# Sort combined_data by the `YYYY_QQ` column if it's used as a date indicator
combined_data <- combined_data %>%
  mutate(YYYY_QQ = as.character(YYYY_QQ)) %>%  # Ensure YYYY_QQ is in character format for sorting
  arrange(as.Date(paste0(substr(YYYY_QQ, 1, 4), "-", (as.numeric(substr(YYYY_QQ, 6, 7)) - 1) * 3 + 1, "-01")))  # Convert YYYY_QQ to date and sort

# Output combined_data for further use
write_csv(df_bank_macro, "JP Morgan.csv")
