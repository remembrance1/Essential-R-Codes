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
df %>% group_by(ID) %>% mutate(diff = ifelse(n_distinct(add)>1, "YES", "NO")) 

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
  mutate(Testdiff = ifelse(all(cost == first(cost)), "N", "Y")) %>%
  filter(row_number() == 1) ## will filter out the very first entry only

## Concatenate columns if they have the same value in one column (UF)
df <- data.frame(UF = c("A", "A", "B", "C"), add = c("hello123", "hihi", "f;un", "das"))
df %>% group_by(UF) %>% mutate(add = paste(add, collapse = ';;;')) %>% slice(1) %>% #choose only the 1st row
  mutate(ConcatAdd = ifelse(grepl(";;;", add), "YES", "NO")) #this will create new column to test for concate

##Compare 2 columns' rows if they are the same value. If yes, spit out 1 for the test.
df <- data.frame(ID = c("1234", "1234", "7491", "7319", "321", "321"), add = c("1234", "1234", "749s1", "73a19", "321", "321"))
df %>% mutate(TEST = ifelse(as.character(df$ID) == as.character(df$add), 1, 0))

############################################################################################################
## Revalue ordinal values in a dataframe, based on a level. for example I want to replaced any repeat drug based on the priority. 
## fda > trial > case > pre . 
## So for example if drug d is "case" as well as "pre", all incidence of d will be reclassify as "case". 
## The final table should look like this.

g1 = data.frame ( 
  drug = c( "a","a","a","d","d"),
  value = c("fda","trial","case","pre","case")
)

g1 %>%
  mutate(value = ordered(value, levels = c("fda", "trial", "case", "pre"))) %>% #order levels in the sequence you want. By ordering factor levels, we can use min/max etc
  group_by(drug) %>%
  mutate(value = min(value)) #identifies the minimum level in the grouped 'drug', and replaces all values with the lowest level

############################################################################################################
## Replace NA using replace_na from tidyr to replace all NA in a particular column (using mutate_at), and 
## doing some conditions, i.e. if 1&0 from the same nest, 0 is returned

data1 <- structure(list(nest.code = structure(c(1L, 1L, 1L, 2L, 2L, 2L, 
                                                3L, 3L, 3L, 3L, 4L, 4L, 4L, 5L, 5L, 5L, 6L, 6L, 6L, 6L, 6L), .Label = c("D046", 
                                                                                                                        "D047", "D062", "D063", "W18003", "W18004"), class = "factor"), 
                        year = c(2018L, 2018L, 2018L, 2018L, 2018L, 2018L, 2018L, 
                                 2018L, 2018L, 2018L, 2018L, 2018L, 2018L, 2018L, 2018L, 2018L, 
                                 2018L, 2018L, 2018L, 2018L, 2018L), species = structure(c(1L, 
                                                                                           1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 
                                                                                           2L, 2L, 2L, 2L, 2L), .Label = c("AA", "BB"), class = "factor"), 
                        visit = c(1L, 2L, 3L, 1L, 2L, 3L, 1L, NA, 2L, 3L, 1L, 2L, 
                                  3L, NA, 2L, 3L, 1L, NA, 2L, 3L, NA), eggs = c(1L, NA, NA, 
                                                                                1L, NA, 0L, 2L, NA, NA, 0L, 1L, NA, 0L, NA, NA, NA, 2L, NA, 
                                                                                NA, 0L, 0L), chicks = c(NA, NA, NA, NA, 1L, 0L, NA, NA, 2L, 
                                                                                                        0L, NA, 1L, 0L, NA, NA, 1L, NA, NA, NA, 0L, 0L), outcome = structure(c(1L, 
                                                                                                                                                                               3L, 3L, 1L, 3L, 2L, 1L, 1L, 3L, 2L, 1L, 3L, 2L, 1L, 4L, 3L, 
                                                                                                                                                                               1L, 1L, 3L, 2L, 2L), .Label = c("incubating", "nest failed", 
                                                                                                                                                                                                               "rearing", "unknown"), class = "factor"), success = c(NA, 
                                                                                                                                                                                                                                                                     1L, NA, NA, 1L, 0L, NA, NA, 1L, 0L, NA, 1L, 0L, NA, NA, 1L, 
                                                                                                                                                                                                                                                                     NA, NA, 1L, 0L, NA)), class = "data.frame", row.names = c(NA, 
                                                                                                                                                                                                                                                                                                                               -21L))

data1 %>% 
  group_by(year, species, nest.code) %>%
  mutate_at(.vars=vars(success), funs(replace_na(.,1))) %>% #replaces NA with 1 at COLUMN "SUCCESS"
  summarize(Realsuccess = min(success))

###########################################################################################################
## Obtain min and max date of each part and custid grouped
t1 %>% group_by(CUST_CD, PART_ID) %>% mutate(mindate = date[which.min(date)], 
                                             maxdate = date[which.max(date)]) #obtain min and max date of each part and cust_Cd

