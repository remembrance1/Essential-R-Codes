###########################################################################################################
#    Function: Conditional Filtering of 1 Col and Update                                                  #
#    Written by: Javier Ng                                                                                #
#    Date: 12/10/2018                                                                                     #
#    Libraries Used: dplyr, mosaic, base R                                                                #
###########################################################################################################

#conditional filter of 1 col and update new col (mosaic)

library(mosaic)
df <- mutate(df, fruit = derivedFactor(
  "apple" = (x<3 & x>1 & y<6 & y>3),
  "ball" = (x<6 & x>4 & y<9 & y>7),
  "pine" = (x<2 & x>0 & y<5 & y>3),
  "orange" = (x<12 & x>7 & y<15 & y>11),
  method ="first",
  .default = NA
))

#dplyr method, update new column

df %>% mutate(z = ifelse(x<3 & x>1 & y<6 & y>3, 'apple', 
                         ifelse(x<6 & x>4 & y<9 & y>7, 'ball',
                                ifelse(x<2 & x>0 & y<5 & y>3, 'pine',
                                       ifelse(x<12 & x>7 & y<15 & y>11, 'orange', NA))))
)

#condiitonal filter of 1 col and update same column
df %>% 
  mutate(Budget = ifelse(Amount < 0, Amount, Budget),
         Amount = ifelse(Amount < 0, NA, Amount))

#conditional filter to loop through each row to check if it EXISTS in another column (from another dataframe or same dataframe also can)
df %>% mutate(`Exist?` = ifelse(df$Product.Id %in% df2$PART_ID == T, "Yes", "No")) -> updatedataframe