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

df$Date <- multidate(df$Date, 
                                 c("%m/%d/%Y","%d-%b-%y"))
