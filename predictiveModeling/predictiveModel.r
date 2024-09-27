library(wbstats)
library(dplyr)
library(zoo)
library(tidyverse)
library(forecast)
library(tseries)

# Define the indicators you want to download
indicators <- c(
  "NY.GDP.MKTP.KD",     # GDP (constant 2015 US$)
  "SL.UEM.TOTL.ZS",     # Unemployment rate (% of total labor force)
  "FP.CPI.TOTL",        # Consumer Price Index (2010 = 100)
  "FR.INR.RINR",        # Real interest rate (%)
  "NE.EXP.GNFS.KD",     # Exports of goods and services (constant 2015 US$)
  "NE.IMP.GNFS.KD"      # Imports of goods and services (constant 2015 US$)
)

# Download the data from the World Bank
data <- wb_data(indicator = indicators, start_date = 1990, end_date = 2023)

# Preview the data
head(data)

# Missing values
sum(is.na(data))

# Handle missing data
data <- data %>%
  group_by(iso2c) %>%
  mutate(
    NY.GDP.MKTP.KD = na.approx(NY.GDP.MKTP.KD, na.rm = FALSE),
    SL.UEM.TOTL.ZS = na.approx(SL.UEM.TOTL.ZS, na.rm = FALSE),
    FP.CPI.TOTL = na.approx(FP.CPI.TOTL, na.rm = FALSE),
    FR.INR.RINR = na.approx(FR.INR.RINR, na.rm = FALSE),
    NE.EXP.GNFS.KD = na.approx(NE.EXP.GNFS.KD, na.rm = FALSE),
    NE.IMP.GNFS.KD = na.approx(NE.IMP.GNFS.KD, na.rm = FALSE)
  ) %>%
  ungroup()

# Function to check stationarity and difference the series if necessary
make_stationary <- function(ts_data) {
  ts_data <- na.omit(ts_data) 
  if (length(ts_data) > 1 && adf.test(ts_data)$p.value > 0.05) {
    ts_data <- diff(ts_data, differences = 1)
    ts_data <- na.omit(ts_data) 
  }
  return(ts_data)
}

# Function to build ARIMA model and make forecast
make_forecast <- function(country_code, data, h = 8) {
  country_data <- data %>% filter(iso2c == country_code)
  
  # Check if the country data has sufficient non-NA observations
  if (sum(!is.na(country_data$NY.GDP.MKTP.KD)) < 2) {
    print(country_data$NY.GDP.MKTP.KD)
    stop("Not enough data for the selected country to build a time series.")
  }
    
    # Convert to time series
    gdp_ts <- ts(country_data$NY.GDP.MKTP.KD, start = c(1990,1), frequency = 1)
    gdp_ts <- make_stationary(gdp_ts)
    
    exog_variables <- country_data %>%
      select(SL.UEM.TOTL.ZS, FP.CPI.TOTL, FR.INR.RINR, NE.EXP.GNFS.KD, NE.IMP.GNFS.KD) %>%
      mutate(across(everything(), ~make_stationary(.))) %>%
      as.data.frame()
    
    # Ensure exogenous variables matrix is the same length as the GDP series
    exog_variables <- exog_variables[1:length(gdp_ts), ]
    
    # Check if there are enough observations after processing
    if (length(gdp_ts) < 2) {
      stop("Not enough data after processing to built a time series")
      
    }
    
    # Build ARIMA model
    arima_model <- auto.arima(gdp_ts, xreg = exog_variables)
    
    # Forecast the next h periods
    forecasted_values <- forecast(arima_model, xreg = tail(exog_variables, h), h = h)
    return(forecasted_values)
}

# Example: USA
tryCatch({
  forecast_USA <- make_forecast("USA", data)
  print(forecast_USA)
}, error = function(e) {
  cat("Error:", e$message, "\n")
}
)

