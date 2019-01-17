###########################################################################################################
#    Function: Extracting specific columns                                                                #
#    Written by: Javier Ng                                                                                #
#    Date: 12/10/2018                                                                                     #
#    Libraries Used: dplyr, base R                                                                        #
###########################################################################################################

df <- dplyr::select(df, c("A", "B", "D")) #extracting specific columns using dplyr 

df <- df[,c("A", "B")] #extracting specific columns using base R 



