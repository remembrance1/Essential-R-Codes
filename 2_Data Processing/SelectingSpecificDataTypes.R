###########################################################################################################
#    Function: Selecting Specific Data Types                                                              #
#    Written by: Javier Ng                                                                                #
#    Date: 01/29/2018                                                                                     #
#    Libraries Used: dplyr                                                                                #
###########################################################################################################
library(dplyr)
# This code will allow you to select a particular data type, i.e. numeric, factor, character
df <- iris[,1:4] #get dataframe

#or use this to select numeric columns only
df <- dplyr::select_if(iris, is.numeric)

