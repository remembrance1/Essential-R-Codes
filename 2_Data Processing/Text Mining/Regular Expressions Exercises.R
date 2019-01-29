library(stringr)

#Q1: Extract out the numerics in a string
text1 <- "The current year is 2016"

my_pattern <- regex("\\d.*")
str_extract(text1, my_pattern) #extracts 2016 (can extract multiple times if in sequence)
str_extract(text1, "[:digit:]+") #extracts 2016 (only 1 time)
str_extract(text1, "[0-9]+") #extracts 2016 (only 1 time)

#Q2: Extract out the numerics in a string
strLine <- "The transactions (on your account) were as follows: 1,400 3,000 (500) break 0 2.25 (1,200)"
str_extract_all(strLine, "\\(?[0-9.,]+\\)?")[[1]]

#Explanation:
str_extract_all(strLine, "[0-9.,]+")[[1]] 
#this will only extract out numerics not surrounded by () 
#[0-9] captures all numerics that fall into the pattern in the string.This will return individual digits (0 3 0 0 0 0 2 2 5...)
#[0-9]+  will return only those that matches 1 or more. Thus, we get 0 3 000 500 0 2 ...
#[0-9.,]+ will connect together those with either , or . in the numerics and return the full digit

str_extract_all(strLine, "\\(?\\)?")[[1]]
#\\( As ( is a metacharacter, we need to escape twice in R to represent the symbol. The purpose behind is to 
#capture digits that are enclosed in the (). However, because not all digits are enclosed in (), we have to use the symbol ?
#digits to parse in the condition. ? represents 0 or 1 match
#\\) refers to the closing of the parenthesis

x <- str_extract_all(strLine, "\\(?[0-9,.]+\\)?")[[1]] #<- Final Solution

#Q3: Substitute () to - in Q2 output
gsub("\\((.+)\\)", "-\\1", x) 

#-\\1 refers to each group by its order of appearance, i.e. the first group that appears will gain a "-" sign 
#(.+), symbols within a () is used to set order of evaluation and create groups