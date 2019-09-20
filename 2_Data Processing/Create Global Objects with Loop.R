###########################################################################################################
#    Function: Creating Global Objects with a for Loop                                                    #
#    Written by: Javier Ng                                                                                #
#    Date: 12/3/2019                                                                                      #
#    Libraries Used: Base R                                                                               #
###########################################################################################################

#i'd like to assign values from a function to each element in a vector...
vec <- c("A", "B", "C")

#simple function
addfunc <- function(x){
  x+x
}

#assign is used to assign a value to the vector
for (i in 1:length(vec)){
  assign(paste0(vec[i]), addfunc(i))  
}

A
B
C