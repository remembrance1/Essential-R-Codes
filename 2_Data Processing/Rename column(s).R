###########################################################################################################
#    Function: Renaming multiple column names or 1 column name                                            #
#    Written by: Javier Ng                                                                                #
#    Date: 12/10/2018                                                                                     #
#    Libraries Used: NA                                                                                   #
###########################################################################################################

#To rename 1 column name based on position. To find position, use colnames(dataframe)

names(dataframe)[1] <- paste("newcolumnname") #changes the column name of position 1

#To rename all column names in dataframe

colnames(dataframe) <- c("newcol1", "newcol2", "newcol3") #for dataframe with 3 cols