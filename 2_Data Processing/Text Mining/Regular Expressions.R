###########################################################################################################
#    Function: Regular Expressions                                                                        #
#    Written by: Javier Ng                                                                                #
#    Date: 25/1/2019                                                                                  #
#    Libraries Used: stringr                                                                       #
###########################################################################################################
library(stringr)

#Extract any characters before '-'
x <- "FM123456-990"
str_extract(x,"[:alnum:]+")

###Abbreviate strings###
states <- rownames(USArrests) #get the list of states
abbreviate(states, minlength = 5) #use the abbreviate function, with minlength to set length

###Select longest name###
#size (in characters) of each name
state_chars = nchar(states)
# longest name
states[which(state_chars == max(state_chars))]

###Select values with characters (anywhere in the string - in order & case specific)
grep(pattern = "ak", x = tolower(states), value = TRUE) #use tolower/toupper function to change to lowercase first

###Character Translation (Replaces characters in old string to new)
#Rule: no. of char for old must be = to new
# replace 'a' by 'A'
chartr("a", "A", "This is a boring string")

###Replace substrings, by position in element
# extract 'bcd'
substr("abcdef", 2, 4)

###replace metacharacters in a string
x <- "-money"
sub(pattern = "\\-", replacement = "", x) #can change the - to anything eg $, %

### You can replace essentially any characters with the below table
# \\d match a digit character
# \\D match a non-digit character
# \\s match a space character
# \\S match a non-space character
# \\w match a word character
# \\W match a non-word character
# \\b match a word boundary
# \\B match a non-(word boundary)
# \\h match a horizontal space
# \\H match a non-horizontal space
# \\v match a vertical space
# \\V match a non-vertical space

### Differences between using sub() and gsub()
sub() replaces the first match, while gsub() replaces all the matches

#replace digit with '_'
sub("\\d", "_", "the dandelion war 2010")

# replace non-digit with '_'
sub("\\D", "_", "the dandelion war 2010")

###Find strings based on patterns
# some string
transport = c("car", "bike", "plane", "boat")
# look for 'e' or 'i'
grep(pattern = "[ei]", transport, value = TRUE)

# some numeric strings
numerics = c("123", "17-April", "I-II-III", "R 3.0.1")
# match strings with 0 or 1
grep(pattern = "[01]", numerics, value = TRUE)
## [1] "123" "17-April" "R 3.0.1"
# match any digit
grep(pattern = "[0-9]", numerics, value = TRUE)
## [1] "123" "17-April" "R 3.0.1"
# negated digit
grep(pattern = "[^0-9]", numerics, value = TRUE)
## [1] "17-April" "I-II-III" "R 3.0.1"

#########################################################################
x <- "ABC|DEF|GHI"
gsub("\\|.*", "", x)

#extracts out a fixed pattern even in the midst of a complex sentence
x <- "hello the date *$(@) is this 12/3/2019 this is a series of test"
pattern <- regex("\\d{1,2}\\/\\d{1,2}\\/\\d{2,4}", comments = T)
str_extract(x, pattern)

#testing the above via a dataframe
test_vec <- data.frame(test = c("hi11/4/2018", "mucks3/09/2014"))
str_extract(test_vec$test, pattern)

#extracting letters before a fullstop sign (method 1)
x <- "hello.csv"
pattern <- regex("[^.]*") #[^] refers to anything but.
str_extract(x, pattern)

#subsetting all the letters before a sign (Method 2)
x <- "hello_name_hi"
pattern <- regex("^(\\S+?)\\_")
str_extract(x, pattern)

#subsetting all the letters before a sign (Method 3)
str_extract(x, "[a-z]*")

#use this to split up the vector
strsplit(x, "_")

#extracting 1st vector before comma
x <- data.frame(cities = c("Singapore, Aussie, NZ"))
gsub(",.*$", "\\1", x$cities) #? refers to 0 or 1 match, * = 0 or more matches, + = one or more match

########################################################################
#subsetting rows that matches a portion of a string
x <- c("hello.csv", "hey.xlsx")
str_subset(x, "\\.csv")
#[1] "hello.csv"

#what if I want to subset out rows that START with a certain string? 
str_subset(x, "^h") #we use the ^ symbol

#what if I want to subset out rows that END with a certain string? 
str_subset(x, ".csv$") #we use the $ symbol

#what if I want to subset out rows based on certain conditions?
x <- c("hello.csv", "hey.xlsx", "useless.jpg")
str_subset(x, "\\.(csv|xlsx)$")

#what if i want to subset specific rows only with multiple conditions? 
files = c(
  "tmp-project.csv", "project.csv", 
  "project2-csv-specs.csv", "project2.csv2.specs.xlsx", 
  "project_cars.ods", "project-houses.csv", 
  "Project_Trees.csv","project-cars.R",
  "project-houses.r", "project-final.xls", 
  "Project-final2.xlsx"
)

#condition 1: extract out all those .csv that starts with p only and one _
str_subset(files, "(P|p)roject*\\.csv$") #<------ This does not work as it extracts only those with project.csv, and skips special symbols
str_subset(files, "^(P|p)roject(\\_|\\-)[a-zA-Z]*\\.(csv)$") #<---- This works

######### VERY USEFUL REGULAR EXPRESSION INFORMATION ###################################
#extract out happy to learn.com but then we dont have to code out everything... 
x <- c("happy_to-learn.com", "His_is-omitted.net")
str_subset(x, "^[a-zA-Z]+(\\_|\\-).*\\.com$")

# We need to specify one or more with + as the _ or - are not just after the first letter.
# str_subset(x, "^[a-zA-Z]+(\\_|\\-).*\\.com$")
# #[1] "happy_to-learn.com"
# Also, the .* refers to zero or more characters as . can be any character until the . and 'com' at the end ($) of the string

################ Method 2 with BASE R ##################################################
grep("^[[:alpha:]_-]+.*\\.com$", x, value = TRUE)
#[1] "happy_to-learn.com"

Explanation:

"^" marks the beginning of the string.
"[:alpha:] matches any alphabetic character, upper or lower case in a portable way.
"^[[:alpha:]_-]+" between [], there are alternative characters to match repeated one or more times. Alphabetic or the underscore _ or the minus sign -.
"^[[:alpha:]_-]+.*" The above followed by any character repeated zero or more times.
"^[[:alpha:]_-]+.*\\.com$" ending with the string ".com" where the dot is not a metacharacter and therefore must be escaped.

