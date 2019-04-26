###########################################################################################################
#    Function: Date Format Conversion (Multiple formats in 1 column)                                      #
#    Written by: Javier Ng                                                                                #
#    Date: 12/10/2018                                                                                     #
#    Libraries Used: dplyr, mosaic, base R                                                                #
###########################################################################################################

#as there are multiple date formats in the date column.... 
multidate <- function(data, formats){
  a<-list()
  for(i in 1:length(formats)){
    a[[i]]<- as.Date(data,format=formats[i])
    a[[1]][!is.na(a[[i]])]<-a[[i]][!is.na(a[[i]])]
  }
  a[[1]]
}

df$Date <- multidate(df$Date, c("%m/%d/%Y","%d-%b-%y"))

##############################################################################
#adding and substracting dates in R
df = data.frame(date1=c("2017-07-07", "2017-02-11", "2017-05-22", "2017-04-27")) 

library(lubridate)
df$date1 <- ymd(df$date1) + years(2)
df$day <- wday(df$date1, label=TRUE)

library(dplyr)

df %>% mutate(newdate = ifelse(df$day == "Sun", date1 + 1, 
                               ifelse(df$day == "Sat", date1 - 1, date1))) -> df
              
df$newdate <- as.Date(df$newdate, origin = "1970-01-01")
df$newday <- wday(df$newdate, label=T)

##### Better technique to adding/subtracting date/year
df = data.frame(date1=c("2017-07-07", "2017-02-11", "2017-05-22", "2017-04-27")) 

library(lubridate)
df$date1 <- ymd(df$date1) + years(2)
df$day <- wday(df$date1, label=TRUE)

library(dplyr)

df %>% mutate(newdate = ifelse(df$day == "Sun", date1 %m+% years(1), 
                               ifelse(df$day == "Sat", date1 %m-% years(1), date1))) -> df

df$newdate <- as.Date(df$newdate, origin = "1970-01-01")
df$newday <- wday(df$newdate, label=T)
df

              