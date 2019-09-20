###########################################################################################################
#    Function: To mass-upload .csv files in folder into global.environment and combine files              #
#    Written by: Javier Ng                                                                                #
#    Date: 12/10/2018                                                                                     #
#    Libraries Used: Plyr, readxl                                                                         #
###########################################################################################################

setwd("C:/Users/zm679xs/Desktop/....") #set working directory

library(readxl) #library used to read .csv function

file.list <- list.files(pattern='*.csv') #obtained name of all the files in directory
df.list <- lapply(file.list, read.csv) #list of all uploaded files

#Populate with a source column to identify which data from which file name
df.list <- mapply(cbind, tbl, "Source"=files, SIMPLIFY=F)

compileddf <- plyr::rbind.fill(df.list) #Compiling into one dataframe

write.csv(compileddf, "compiledfile.csv") #saving it as one .csv