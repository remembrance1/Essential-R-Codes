###########################################################################################################
#    Function: Remove empty columns/rows in dataframe list and create column based on file name           #
#    Written by: Javier Ng                                                                                #
#    Date: 12/10/2018                                                                                     #
#    Libraries Used: NA                                                                                   #
###########################################################################################################

#Ensure that it is a list of dataframe (For this example, it is named as "df.list")

#removes the 1st 7 columns in all of list
t1 <- lapply(df.list, '[', -c(1:7)) 

#creating a column based on the name of the file 
t1 <- mapply(cbind, t1, "Name of File"=file.list, SIMPLIFY=F) 

#removing empty rows from the ID column across list of dataframe
t2 <- lapply(t1, function(x){ x[!(is.na(x$ID) | x$ID==""), ]})