###########################################################################################################
#    Function: Identifying overlapping values in different IDs                                            #
#    Written by: Javier Ng                                                                                #
#    Date: 25/4/2019                                                                                      #
#    Libraries Used: -                                                                                    #
###########################################################################################################

library(tidyverse)

data <- tibble(id = factor(c(1234, 1234, 1234, 1234, 1234, 
                             4523, 4523, 4523, 4523, 4523, 
                             0984, 0984, 0984, 0984, 0984)),
               word = c("hello", "today", "the", "monkey", "boy",
                        "go", "me", "today", "wind", "hello",
                        "monkey", "yes", "no", "wild", "quit"))

tcrossprod(table(data))
