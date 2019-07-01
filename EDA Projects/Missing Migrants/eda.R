setwd("C:/Users/zm679xs/Desktop/R/Essential-R-Codes/EDA Projects/Missing Migrants")

library(dplyr)
library(stringr)

df <- read.csv("MissingMigrants-Global-2019-03-29T18-36-07.csv")

table(df$Region.of.Incident, df$Reported.Year)

df[is.na(df)] <- 0 #replace NA with 0

##--------------------------------------------------------------------------------------------------##
# group the causes of death into broader categories. Take note that we can use | (pipe operators) to group similar classes together
# Take note that str_detect is case sensitive! 
df %>% mutate('New Cause of Death' = ifelse(str_detect(df$Cause.of.Death, 'Organ|Coronary|Envenomation|Post-partum|Respiratory|Hypoglycemia'), "Health Issues", 1)) %>%
  select('New Cause of Death', 'Cause.of.Death') -> t

##--------------------------------------------------------------------------------------------------##
#To make str_detect to be case insensitive, we can use this instead (?i)
data <- data.frame('Type' = c("Organ Failure", "organ failure", "Coronary Disease", "Accident"), "No" = c(3, 1, 2, 4))
data %>% mutate('Grouped Type' = ifelse(str_detect(data$Type, "(?i)Organ|Coronary"), "Health Issues", 
                                        ifelse(str_detect(data$Type, 'Drown|Accident'), "Accident", 0))) 

##--------------------------------------------------------------------------------------------------##
#Reproducible example
data <- data.frame('Type' = c("Organ Failure", "Drowning", "Coronary Disease", "Accident"), "No" = c(3, 1, 2, 4))

data %>% mutate('Grouped Type' = ifelse(str_detect(data$Type, 'Organ|Coronary'), "Health Issues", 
                                        ifelse(str_detect(data$Type, 'Drown|Accident'), "Accident", 0)))             

#simpler way to recreate the above..
#https://stackoverflow.com/questions/56764480/creating-grouped-categories-with-str-detect-and-dplyr/56764580?noredirect=1#comment100085755_56764580 

library(tidyverse)
data %>%
  mutate(`Grouped Type` = case_when(
    str_detect(Type, 'Organ|Coronary') ~ "Health Issues", 
    str_detect(Type, 'Drown|Accident') ~ "Accident", 
    TRUE ~ NA_character_))

##--------------------------------------------------------------------------------------------------##

df %>% 
  mutate('New Cause of Death' = case_when(
    str_detect(Cause.of.Death, 'Organ|Coronary|Envenomation|Post-partum|Respiratory|Hypoglycemia|Sickness|sickness|diabetic|heart attack|meningitis|virus|cancer|bleeding|insuline|inhalation') ~ "Health Issues",
    str_detect(Cause.of.Death, 'harsh weather|Harsh weather|Harsh conditions|harsh conditions|Exhaustion|Heat stroke') ~ "Harsh Conditions",
    str_detect(Cause.of.Death, '(?i)Unknown') ~ "Unknown",
    str_detect(Cause.of.Death, '(?i)Starvation') ~ "Starvation",
    str_detect(Cause.of.Death, '(?i)Dehydration') ~ "Dehydration", 
    str_detect(Cause.of.Death, 'Drowning|drowning|Pulmonary|respiratory|lung|bronchial|pneumonia|Pneumonia') ~ 'Drowning',
    str_detect(Cause.of.Death, '(?i)hyperthermia') ~ "Hyperthermia", 
    str_detect(Cause.of.Death, '(?i)hypothermia') ~ "Hypothermia", 
    str_detect(Cause.of.Death, '(?i)asphyxiation|suffocation') ~ "Asphyxiation",
    str_detect(Cause.of.Death, '(?i)train|bus|vehicle|truck|boat|car|road|van|plane') ~ "Vehicle Accident",
    str_detect(Cause.of.Death, '(?i)murder|stab|shot|violent|blunt force|violence|beat-up|fight|murdered|death|rape') ~ "Murder",
    str_detect(Cause.of.Death, '(?i)crushed to death|crush|Crush|Rockslide') ~ "Crushed",
    str_detect(Cause.of.Death, '(?i)Burn|Burns|Burned|Fire') ~ "Burned",
    str_detect(Cause.of.Death, 'electrocution|Electrocution') ~ "Electrocution",
    str_detect(Cause.of.Death, '(?i)fall') ~ "Fall", 
    str_detect(Cause.of.Death, 'crocodile|hippopotamus|hippoptamus') ~ "Killed by Animals",
    str_detect(Cause.of.Death, '(?i)exposure') ~ "Exposure",
    str_detect(Cause.of.Death, 'mortar|landmine|Apache|Hanging|Gassed') ~ "Killed by War",
    str_detect(Cause.of.Death, 'Mixed') ~ "Multiple Reasons",
    str_detect(Cause.of.Death, 'Suicide') ~ "Suicide",
    TRUE ~ NA_character_
  )) -> df

##df %>% select(Cause.of.Death, `New Cause of Death`) %>% filter(is.na(`New Cause of Death`)) -- Check NA

library(ggplot2)

ggplot(df, aes(x=reorder(`New Cause of Death`, Total.Dead.and.Missing, sum), y= Total.Dead.and.Missing, fill = Region.of.Incident)) + 
  geom_bar(stat='identity') + theme_classic() + 
  theme(axis.text.x = element_text(angle = 90)) +
  coord_flip()

#split up coordinates based on long and lat
lonlat <- data.frame(do.call('rbind', strsplit(as.character(df$Location.Coordinates),',',fixed=TRUE)))
colnames(lonlat) <- c("lat", "lon") # rename columns

df <- df[!df$Location.Coordinates == '',] #remove 1 blank coordinate
df <- cbind(df, lonlat) #added lonlat

write.csv(df, "df.csv")
