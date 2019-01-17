###########################################################################################################
#    Function: Reorder Columns in data.frame                                                              #
#    Written by: Javier Ng                                                                                #
#    Date: 12/10/2018                                                                                     #
#    Libraries Used: NA                                                                                   #
###########################################################################################################

refvec <- c("A", "B", "C") #create reference vector with columns in the order you wanted
df <- df[refvec]