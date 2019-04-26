###########################################################################################################
#    Function: Remove characters based on vector                                                          #
#    Written by: Javier Ng                                                                                #
#    Date: 04/24/2019                                                                                     #
#                                                                                                         #
###########################################################################################################

df <- data.frame(serial = 1:3, name = c("Javier", "Kenneth", "Kasey"))
vec <- c("Ja", "Ka")
df$name <- sub(paste0("^", vec, collapse = "|"), "", df$name)

### Remove trailing/leading white spaces with trimws
trimws(x, which = ....) #read the tutorial