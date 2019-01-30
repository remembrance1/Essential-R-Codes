## Using AirPassengers dataset

df <- AirPassengers
df <- data.frame(AirPassengers, year = trunc(time(AirPassengers)), 
                 month = month.abb[cycle(AirPassengers)])
df$Date <- paste0("01",df$month, df$year)
df$Date <- as.Date(df$Date, format="%d%b%Y")
df$AirPassengers <- as.numeric(df$AirPassengers)
names(df)[1] <- "Count"

library(tibbletime)
df <- as_tbl_time(df, index = Date) #create tibble time datastructure

library(anomalize)
df %>%
  time_decompose(Count, method = 'stl') %>% #count = y-axis variable
  anomalize(remainder, method = 'iqr', max_anoms = 0.05) %>% #max_anoms = maximum % of data that is anomalous
  time_recompose() %>%
  plot_anomalies(time_recomposed = T) +
  labs(title = "AirPassengers Anomalies", subtitle = "STL + IQR Methods") #plot 1 - STL + IQR method

#Identify outliers
df %>%
  time_decompose(Count, method = 'stl') %>%
  anomalize(remainder, method = 'iqr', max_anoms = 0.05, verbose = TRUE) -> df_full

#obtain entries that are anomalous
df_full <- data.frame(df_full[1])
df_anomaly <- subset(df_full, df_full$anomalized_tbl.anomaly == "Yes")

#############################################################
## Using FB stock prices
df <- FB

library(tibbletime)
df <- as_tbl_time(df, index = date) #create tibble time datastructure

df %>% filter(date > "2015-01-01" & date < "2016-01-01") -> df #to subset a specific date

df %>%
  time_decompose(close, method = 'stl') %>% #count = y-axis variable
  anomalize(remainder, method = 'iqr', alpha = 0.1) %>% 
  time_recompose() %>%
  plot_anomalies(time_recomposed = T) +
  labs(title = "Closing Price Anomalies", subtitle = "STL + IQR Methods") #plot 1 - STL + IQR method
