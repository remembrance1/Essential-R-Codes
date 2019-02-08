###########################################################################################################
#    Function: Aggregate!!                                                                                #
#    Written by: Javier Ng                                                                                #
#    Date: 03/07/2018                                                                                     #
#                                                                                                         #
###########################################################################################################

library(dplyr)

#Group by all columns but a few.... this is useful when dealing with many variables in a dataset
df <- mtcars[,-c(3:11)]
df <- as_tibble(df, rownames = "car")
df %>% group_by_at(vars(-mpg, -car)) %>% summarize(summpg = sum(mpg)) #this will take in all variables in a df except for MPG & CAR

#Group by one column & sum up one column
mtcars %>% group_by(cyl) %>% summarize(sum(mpg))

#Using formula to do group by in replacement of above
aggregate(mpg ~ cyl, mtcars, sum)

#using formula to do group by but adding more variables..
aggregate(mpg ~ cyl + hp, mtcars, sum)

#using formula to do group by but want to add all variables..
aggregate(mpg ~., mtcars, sum) # period(.) is used to replace all variables
