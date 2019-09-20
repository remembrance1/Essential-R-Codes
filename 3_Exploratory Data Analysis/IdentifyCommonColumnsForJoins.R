###########################################################################################################
#    Function: To allow easy identification of common columns for joins in R                              #
#    Written by: Javier Ng                                                                                #
#    Date: 15/1/2019                                                                                      #
#    Libraries Used: -                                                                                    #
###########################################################################################################
library(dplyr)
library(purrr)

df1 <- data.frame(fruit=c("apple", "Orange", "Pear"), location = c("Japan", "China", "Nigeria"), price = c(32,53,12))
df2 <- data.frame(grocery = c("Durian", "Apple", "Watermelon"), 
                  place=c("Korea", "Japan", "Malaysia"), 
                  name = c("Mark", "John", "Tammy"), 
                  favourite.food = c("Apple", "ORANGE", "Cakes"), 
                  invoice = c("XD1", "XD2", "XD3"))
df3 <- data.frame(address=c("address1", "address2", "address3"), location = c("USA", "UK", "China"), test = c("a", "apple", "orange"))
df4 <- data.frame(a=c("no", "no"), b=c("yes", "yes"), c=c("Apple", "address1"))

#setting null list
templist <- list() #create templist
newlist <- list() #create newlist

#Get environment objects in decending order
allobj <- ls()[sapply(ls(), function(i) class(get(i))) == "data.frame"]
allobj_new <- list()
for (i in 1:length(allobj)){ #loop to identify obtain vector of dataframes to loop through
  if (i <= length(allobj) - 1){
    allobj_new[[i]] <- allobj[(i):(as.numeric(length(allobj)))]
  }
}

####################################FUNCTIONS###################################################
#set df1 as table1 and df2 as table 2. Table 2 will appear as the column headers.
foridentification <- function(df1, df2){
  vec <- sapply(names(df1), function(x) {
    temp <- sapply(names(df2), function(y) 
      if(any(match(tolower(df1[[x]]), tolower(df2[[y]]), nomatch = FALSE))) y else NA) #works for lower/upper case strings, as long as there is a match in char
    ifelse(all(is.na(temp)), NA, toString(temp[!is.na(temp)]))
  }
  )
  output <- data.frame(columns_from_df1 = names(vec), columns_from_df2 = vec, row.names = NULL)
  return(output)
}

#rename columns in list
renamecol_combine <- function(list_here, refvec){
  output <- lapply(seq_along(list_here), function(x) {
    names(list_here[[x]])[1] <- paste0("From ",refvec[1]) #rename 1st column
    names(list_here[[x]])[2] <- paste0("Against ",refvec[x+1]) #rename 2nd column
    list_here[[x]]
  })
  return(output %>% reduce(left_join, by = paste0("From ",refvec[1])))
}

#loop to get table1 matched against tabl2, tabl3.. (WILL OUTPUT A LIST IN THE END!)
insertref_obj <- function(refobj){
  for (i in 1:length(refobj)){
    if (i < length(refobj)){
      templist[[i]] <- foridentification(get(refobj[1]), get(refobj[i+1])) 
    } 
  } 
  return(templist) #returns a list
}

library(xlsx)

#create the final output workbook
workbook_create <- function(createdlist){
  wb <- createWorkbook()
  sheetnames <- paste0("Sheet", seq_along(createdlist)) # or names(datas) if provided
  sheets <- lapply(sheetnames, createSheet, wb = wb)
  void <- Map(addDataFrame, createdlist, sheets)
  saveWorkbook(wb, file = "KeyIDs.xlsx")
}

################################################################################################
final_list <- function(env_obj_list){
  for (i in 1:length(env_obj_list)){
    newlist[[i]] <- renamecol_combine(insertref_obj(env_obj_list[[i]]), env_obj_list[[i]])
  }
  return(newlist)
}
                                                 
workbook_create(final_list(allobj_new)) 



