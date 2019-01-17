list.df <- list(data.frame(a=(1:5), b=(6:10)), data.frame(a=(1:5), b=(11:15)), data.frame(a=(1:5), b=(21:25)))

#will square all dataframes in list, at column 2, and only return a vector
lapply(list.df, function(x) x[,2]^2) 

#returns a list instead...            
lapply(list.df, function(x) {
  i <- seq_along(list.df)
  x[i, 2] <- x[i, 2] ^ 2
  x
})

######FOR UNDERSTANDING########
The (X) in the function within lapply refers to the index!

########################################################################################################
allorg <- c("df1", "df2", "df3", "df4")

#lapply to rename columns and iterating through another vector (allobj), to sequentially add column names
lapply(seq_along(templist), function(x) {
  names(templist[[x]])[2] <- allorg[x]
  templist[[x]]
})

#mapply can be used instead
mapply(function(x, y) {names(x)[2] <- y; x}, templist, allobj) #templist is assigned to x and allobj is assigned to y
#mapply it takes 1st list from templist and 1st value from allobj and assign the names. 
#In the next iteration it takes second list from templistand 2nd value from allobj and so on. -

#change column names in list
for (i in seq_along(list.df)){
  colnames(list.df[[i]]) <- c("df", paste0("df",i+1)) #will change the column name of each dataframe in a list in seq
}

for (i in seq_along(list.df)){
  colnames(list.df[[i]]) <- c("df1", paste0(allorg[i+1])) #will change the column name of each dataframe in a list in seq
}

#changing the data.frame name in a list
names(list.df) <- c("hi", "hi2", "hi3") #manually changes the name of each df in list

for (i in seq_along(list.df)){
  names(list.df)[i] <- allorg[i+1] #loop to change the name of each df in a list
}

######################################################################
#create function that squares every odd position ...
set.seed(100)
oddsqr <- function(df){
  (df[seq(1, nrow(df), 2), 2])^2 #selects odd index positions from column 2
}

vec <- seq(1,5,2)
for (k in seq_along(list.df)){
  for (i in seq_along(list.df)){
      list.df[[k]][[2]][vec[i]] <- oddsqr(list.df[[k]])[i]
  }
}

#alternative method
out <- lapply(list.df, function(x) {
  idx <- seq(1, nrow(x), 2)
  x[idx, 2] <- x[idx, 2] ^ 2
  x
})

#alternative function that returns a dataframe instead of a vector
oddsqr_df <- function(df){
  df[seq(1, nrow(df), 2), 2] <- df[seq(1, nrow(df), 2), 2]^2 #selects odd index positions from column 2
  df
}
