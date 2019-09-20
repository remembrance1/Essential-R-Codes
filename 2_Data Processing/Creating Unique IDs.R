###########################################################################################################
#    Function: Creating Unique Identifiers                                                                #
#    Written by: Javier Ng                                                                                #
#    Date: 03/13/2010                                                                                     #
#    Libraries Used: Base R                                                                               #
###########################################################################################################

FIRST = c("Barabara", "Filip", "Lupe")
LAST = c("Lee", "Rice", "De")
BIRTHDAY = c("1986-01-01", "1989-04-08", "1976-02-10")
BIRTHDAY = as.Date(BIRTHDAY)
GENDER = c("Female","Male","Female")

PracticeData = data.frame(FIRST, LAST, BIRTHDAY, GENDER)

PracticeData$PatientID = paste0(str_sub(PracticeData$FIRST,1,3),
                                str_sub(PracticeData$LAST,-2),
                                str_length(PracticeData$LAST),
                                PracticeData$BIRTHDAY,
                                str_sub(PracticeData$GENDER,1,1))

PracticeData$PatientID = gsub("-", "", PracticeData$PatientID)

PracticeData