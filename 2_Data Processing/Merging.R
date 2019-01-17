###########################################################################################################
#    Function: Merging (Left Joins, Right, Inner)                                                         #
#    Written by: Javier Ng                                                                                #
#    Date: 12/10/2018                                                                                     #
#    Libraries Used: SQLdf/ Base R                                                                        #
###########################################################################################################

#Base R
Inner join: merge(df1, df2) 2, by = "CustomerId") #merging by "Customer ID"

Outer join: merge(x = df1, y = df2, by = "CustomerId", all = TRUE)

Left outer: merge(x = df1, y = df2, by = "CustomerId", all.x = TRUE)

Right outer: merge(x = df1, y = df2, by = "CustomerId", all.y = TRUE)

#SQLdf

library(sqldf) 
sqldf("SELECT Week, `Rule Name`, `Month`, `Customer ID`, count, `Model Name`, Score, `Customer Type` 
       FROM t1
       LEFT JOIN t2 USING(`Rule Name`)") #using SQL in R