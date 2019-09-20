###########################################################################################################
#    Function: Using Dplyr to Select Data Type and Convert                                                #
#    Written by: Javier Ng                                                                                #
#    Date: 12/3/2019                                                                                      #
#    Libraries Used: dplyr                                                                                #
###########################################################################################################

df <- data.frame(A = 1:3, B = c("This", "is", "factor"))

library(dplyr)

df %>%
  mutate_if(is.numeric, as.character) %>% #if type is numeric, convert to character
  select_if(is.character) #selects numerics only
