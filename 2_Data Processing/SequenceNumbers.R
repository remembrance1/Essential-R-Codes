###########################################################################################################
#    Function: Numbering Rows Within Groups                                                               #
#    Written by: Javier Ng                                                                                #
#    Date: 03/22/2019                                                                                     #
#    Libraries Used: dplyr                                                                                #
###########################################################################################################
library(dplyr)

df <- data.frame(ID = c("1", '1', '2', '3', '3', '3'), measurement = c(32, 44, 11, 22, 44, 55))

#create a sequence number that number rows within the ID group

df %>% group_by(ID) %>%
  mutate(num = row_number())
  