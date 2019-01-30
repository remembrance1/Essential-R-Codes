## Anomaly Detection in R ##

library(anomalize)
library(tidyverse)

#Using the tidyverse_Cran_downloads data set
tidyverse_cran_downloads %>%
  ggplot(aes(date, count)) +
  geom_point(color = "#2c3e50", alpha = 0.25) +
  facet_wrap(~ package, scale = "free_y", ncol = 3) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
  labs(title = "Tidyverse Package Daily Download Counts",
       subtitle = "Data from CRAN by way of cranlogs package")

tidyverse_cran_downloads %>%
  # Data Manipulation / Anomaly Detection
  time_decompose(count, method = "stl") %>% #https://en.wikipedia.org/wiki/Decomposition_of_time_series on why you need to decompose.
  #https://business-science.github.io/anomalize/reference/time_decompose.html explains into the different methods of decomposition
  anomalize(remainder, method = "iqr") %>% #for anomaly detection with 2 different methods
  #https://business-science.github.io/anomalize/reference/anomalize.html
  time_recompose() %>% #recompose bands separating anomalies from normal observations
  # Anomaly Visualization
  plot_anomalies(time_recomposed = TRUE, ncol = 3, alpha_dots = 0.25) + #to visualize the anomalies in one or multiple series
  labs(title = "Tidyverse Anomalies", subtitle = "STL + IQR Methods") 

#Get only a specific package's plot, i.e. dplyr
dplyr_downloads <- tidyverse_cran_downloads %>% filter(package == "dplyr") %>% ungroup()

dplyr_downloads %>%
  time_decompose(count, method = 'stl') %>% #count = y-axis variable
  anomalize(remainder, method = 'iqr', max_anoms = 0.01) %>% #max_anoms = maximum % of data that is anomalous
  time_recompose() %>%
  plot_anomalies(time_recomposed = T) +
  labs(title = "Dplyr Anomalies", subtitle = "STL + IQR Methods") #plot 1 - STL + IQR method

dplyr_downloads %>%
  time_decompose(count, method = 'twitter') %>% #count = y-axis variable
  anomalize(remainder, method = 'gesd') %>%
  time_recompose() %>%
  plot_anomalies(time_recomposed = T) +
  labs(title = "Dplyr Anomalies", subtitle = "Twitter + GESD Methods") #plot 2 - Twitter + GESD method

#Identify outliers
dplyr_downloads %>%
  time_decompose(count, method = 'stl') %>%
  anomalize(remainder, method = 'iqr', max_anoms = 0.01, verbose = TRUE) -> df_full

#obtain entries that are anomalous
df_full <- data.frame(df_full[1])
subset(df_full, df_full$anomalized_tbl.anomaly == "Yes")
