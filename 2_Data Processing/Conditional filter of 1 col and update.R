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

##########################################################################3
#identify if there are differences in col A and col B
df <- data.frame(ID = c("1234", "1234", "7491", "7319", "321", "321"), add = c("ABC", "DEF", "HIJ", "KLM", "WXY", "WXY"))
aggqty %>% group_by(`DIST INVOICE-PART KEY`) %>% mutate(diff = ifelse(n_distinct(`DIST Ship to Addr1 Desc`)>1, "YES", "NO")) -> t

#DPLYR SOLUTION
library(dplyr)

df %>% 
  group_by(ID) %>% 
  mutate(diff = ifelse(length(unique(add))>1, "YES", "NO")) # n_distict(add)>1 will also work 
#mutate(diff = ifelse(n_distinct(add)>1, "YES", "NO"))

#Using data.table
setDT(df)
df[, diff := if (uniqueN(add) > 1) "Yes" else "No", by = ID]

## Groupby the ID, to test if there are differences in the cost column and update a new column called Test diff
## AND remove the first row
df <- data.frame(ID = c("A", "A", "B", "B", "B","C", "C", "D"), cost = c("0.5", "0.4", "0.7", "0.8", "0.5", "1.3", "1.3", "2.6"))
#tidyverse solution 
df %>%
  group_by(ID) %>%
  mutate(Testdiff = ifelse(all(cos == first(cost)), "N", "Y")) %>%
  filter(row_number() == 1) ## will filter out the very first entry only

## Concatenate columns if they have the same value in one column (UF)
df <- data.frame(UF = c("A", "A", "B", "C"), add = c("hello123", "hihi", "f;un", "das"))
df %>% group_by(UF) %>% mutate(add = paste(add, collapse = ';;;')) %>% slice(1) %>% #choose only the 1st row
  mutate(ConcatAdd = ifelse(grepl(";;;", add), "YES", "NO")) #this will create new column to test for concate
