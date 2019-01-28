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

x <- "ABC|DEF|GHI"
gsub("\\|.*", "", x)

x <- "12/3/2019"
pattern <- regex("\\d{1,2}\\/\\d{1,2}\\/\\d{4}", comments = T)
str_extract(x, pattern)

