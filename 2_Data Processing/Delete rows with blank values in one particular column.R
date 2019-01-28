###########################################################################################################
#    Function: Delete rows with blank values in one particular column                                     #
#    Written by: Javier Ng                                                                                #
#    Date: 1/22/2019                                                                                      #
#    Libraries Used: base R                                                                               #
###########################################################################################################

df[!(is.na(df$start_pc) | df$start_pc==""), ]