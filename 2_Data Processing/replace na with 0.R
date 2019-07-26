## Replacing NA with 0

#Base R
df[is.na(df)] <- 0

##dplyr 
df %>%
  mutate_all(funs(ifelse(is.na(.), 0, .)))