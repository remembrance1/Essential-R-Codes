###########################################################################################################
#    Function: To allow easy identification of common columns for joins in R                              #
#    Written by: Javier Ng                                                                                #
#    Date: 15/1/2019                                                                                      #
#    Libraries Used: -                                                                                    #
###########################################################################################################


df1 <- data.frame(fruit=c("apple", "Orange", "Pear"), location = c("Japan", "China", "Nigeria"), price = c(32,53,12))
df2 <- data.frame(grocery = c("Durian", "Apple", "Watermelon"), 
                  place=c("Korea", "Japan", "Malaysia"), 
                  name = c("Mark", "John", "Tammy"), 
                  favourite.food = c("Apple", "ORANGE", "Cakes"), 
                  invoice = c("XD1", "XD2", "XD3"))
df3 <- data.frame(address=c("address1", "address2", "address3"), location = c("USA", "UK", "China"))
df4 <- data.frame(a=c("no", "no"), b=c("yes", "yes"))

#set df1 as table1 and df2 as table 2. Table 2 will appear as the column headers.

foridentification_temp <- function(df1, df2){
  vec <- sapply(names(df1), function(x) {
    temp <- sapply(names(df2), function(y) 
      if(any(match(tolower(df1[[x]]), tolower(df2[[y]]), nomatch = FALSE))) y else NA) #works for lower/upper case strings, as long as there is a match in char
    ifelse(all(is.na(temp)), NA, toString(temp[!is.na(temp)]))
  }
  )
  output <- data.frame(columns_from_df1 = names(vec), columns_from_df2 = vec, row.names = NULL)
  return(output)
}

# foridentification <- function(df1, df2){ #function to add respective column names #redundant
#   temp <- foridentification_temp(df1,df2)
#   names(temp)[1] <- paste("From", deparse(substitute(df1)))
#   names(temp)[2] <- paste("From", deparse(substitute(df2)))
#   return(temp)
# }

#loop to get table1 matched against tabl2, tabl3..
allobj <- ls()[sapply(ls(),function(t) is.data.frame(get(t)))]
templist <- list() #create templist

for (i in 1:length(allobj)){
        if (i < length(allobj))
          templist[[i]] <- foridentification_temp(get(allobj[1]), get(allobj[i+1])) 
}

#####################TRYING TO RENAME COLUMN IN A LIST#################################
#rename columns in list..
lapply(templist, function(x) {names(x)[2] <- paste("From", allobj[seq(1,2)]); x})


