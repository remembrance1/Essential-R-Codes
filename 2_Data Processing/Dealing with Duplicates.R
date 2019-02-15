###########################################################################################################
#    Function: Dealing with Duplicates                                                                    #
#    Written by: Javier Ng                                                                                #
#    Date: 03/07/2018                                                                                     #
#                                                                                                         #
###########################################################################################################

#Remove duplicates and leave the very first entry of every duplicated row
df <- dplyr::distinct(df)

#Identify duplicated rows from a dataset and extract them (includes the very 1st entry as well)
duplrowsall <- df[(duplicated(df) | duplicated(df, fromLast = TRUE)), ]

#Get dataframe that does not have any duplicated entry at all 
duplrowsgone <- df[!(duplicated(df) | duplicated(df, fromLast = TRUE)), ]

#identifying duplicated rows 
duplicated1 <- df[duplicated(df),] #duplicated entries
nondup <- distinct(df)
nondup$Dup_Test <- "No"
duplicated1$Dup_Test <- "Yes"

df <- rbind(nondup, duplicated1)