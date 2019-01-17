###########################################################################################################
#    Function: Extracting values within ()                                                                #
#    Written by: Javier Ng                                                                                #
#    Date: 12/10/2018                                                                                     #
#    Libraries Used: dplyr, mosaic, base R                                                                #
###########################################################################################################


df$col <- gsub("(?<=\\()[^()]*(?=\\))(*SKIP)(*F)|.", "", df$col, perl=T) #extracted those () amount aka credit