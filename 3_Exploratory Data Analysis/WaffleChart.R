###########################################################################################################
#    Function: Waffle Chart                                                                               #
#    Written by: Javier Ng                                                                                #
#    Date: 02/07/2018                                                                                     #
#    Function: To show categorical composition of total population                                         #
###########################################################################################################

# install.packages("devtools")
# install_github("hrbrmstr/waffle")

library(waffle)
library(extrafont)
library(dplyr)
library(tsbox) #convert ts to df or anything else

#using the mdeaths dataset (TS)
df <- ts_df(mdeaths)
df$month <- format(df$time, "%m")
df %>% group_by(month) %>% summarize(deathsbymth = sum(value)) %>% mutate(quarter = 1:n()) -> dat

dat %>% mutate(Qtr = ifelse(dat$quarter < 4, "1",
                                ifelse(dat$quarter >= 4  & dat$quarter < 7, "2",
                                      ifelse(dat$quarter >= 7 & dat$quarter < 10, "3", "4")))) %>% select(month, deathsbymth, Qtr) -> dat

dat %>% group_by(Qtr) %>% summarize(deathsbymth = sum(deathsbymth)) -> dat

deaths <- c("Qtr 1" = 37090, "Qtr 2" = 24950, "Qtr 3" = 19176, "Qtr 4" = 26492)

waffle(deaths/2000, rows=5, 
       glyph_size = 4, colors=c("midnightblue","deeppink3", "darkorange1","gold"), 
       title="Total Deaths by Month",
       xlab="1 Person = 2000 people")
