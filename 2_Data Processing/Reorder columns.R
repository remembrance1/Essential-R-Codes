###########################################################################################################
#    Function: Reorder Columns in data.frame                                                              #
#    Written by: Javier Ng                                                                                #
#    Date: 12/10/2018                                                                                     #
#    Libraries Used: NA                                                                                   #
###########################################################################################################

refvec <- c("A", "B", "C") #create reference vector with columns in the order you wanted
df <- df[refvec]

#Moving any column to the first position
df <- df[,c(which(colnames(ediclaims)=="desired col name"),which(colnames(ediclaims)!="desired col name"))]