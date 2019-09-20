## Purpose: We're going to try to predict which outbreaks of 
## animal diseases will lead to humans getting sick(affected).

setwd("C:/Users/zm679xs/Desktop/R/Essential-R-Codes/EDA Projects/outbreak")
#import libraries
library(caret)
library(xgboost)
library(tidyverse)
library(dplyr)

#import dataframe
diseaseinfo <- read.csv("Outbreak_240817.csv", stringsAsFactors = F)

#shuffle dataframe
diseaseinfo <- diseaseinfo[sample(1:nrow(diseaseinfo)), ]

# get the subset of the dataframe that doesn't have labels about 
# humans affected by the disease
diseaseInfo_humansRemoved <- diseaseinfo %>%
  select(-starts_with("human"))

# get a boolean vector of training labels
diseaseLabels <- diseaseinfo %>%
  select(humansAffected) %>% # get the column with the # of humans affected
  is.na() %>% # is it NA?
  magrittr::not() # switch TRUE and FALSE (using function from the magrittr package). Humans not affected = F and affected = T

# Reduce redundant information from the dataset
# select just the numeric columns
diseaseInfo_numeric <- diseaseInfo_humansRemoved %>%
  select(-Id) %>% # the case id shouldn't contain useful information
  select(-c(longitude, latitude)) %>% # location data is also in country data
  select_if(is.numeric) # select remaining numeric columns

# make sure that our dataframe is all numeric
str(diseaseInfo_numeric)

# Country information may be useful too, hence need to convert the country: diseaseinfo$country
# one-hot matrix for just the first few rows of the "country" column
# convert categorical factor into one-hot encoding
region <- model.matrix(~country-1,diseaseinfo)

# add a boolean column to our numeric dataframe indicating whether a species is domestic
diseaseInfo_numeric$is_domestic <- str_detect(diseaseinfo$speciesDescription, "domestic")

# get a list of all the species by getting the last
speciesList <- diseaseinfo$speciesDescription %>%
  str_replace("[[:punct:]]", "") %>% # remove punctuation (some rows have parentheses)
  str_extract("[a-z]*$") # extract the least word in each row

# convert our list into a dataframe...
speciesList <- tibble(species = speciesList)

# and convert to a matrix using 1 hot encoding
options(na.action='na.pass') # don't drop NA values!
species <- model.matrix(~species-1,speciesList)

# add our one-hot encoded variable and convert the dataframe into a matrix
diseaseInfo_numeric <- cbind(diseaseInfo_numeric, region, species)
diseaseInfo_matrix <- data.matrix(diseaseInfo_numeric)

########################################################################################
########################################################################################
#-----> Train Model 
# get the numb 70/30 training test split
numberOfTrainingSamples <- round(length(diseaseLabels) * .7)

# training data
train_data <- diseaseInfo_matrix[1:numberOfTrainingSamples,]
train_labels <- diseaseLabels[1:numberOfTrainingSamples]

# testing data
test_data <- diseaseInfo_matrix[-(1:numberOfTrainingSamples),]
test_labels <- diseaseLabels[-(1:numberOfTrainingSamples)]

# put our testing & training data into two seperates Dmatrixs objects
dtrain <- xgb.DMatrix(data = train_data, label= train_labels)
dtest <- xgb.DMatrix(data = test_data, label= test_labels)

# get the number of negative & positive cases in our data
negative_cases <- sum(train_labels == FALSE)
postive_cases <- sum(train_labels == TRUE)

# train a model using our training data
model_tuned <- xgboost(data = dtrain, # the data           
                       max.depth = 3, # the maximum depth of each decision tree
                       nround = 10, # number of boosting rounds
                       early_stopping_rounds = 3, # if we dont see an improvement in this many rounds, stop
                       objective = "binary:logistic", # the objective function
                       scale_pos_weight = negative_cases/postive_cases, # control for imbalanced classes
                       gamma = 1) # add a regularization term

# generate predictions for our held-out testing data
pred <- predict(model_tuned, dtest)

# get & print the classification error
err <- mean(as.numeric(pred > 0.5) != test_labels)
print(paste("test-error=", err))

# Append pred to test_data
testing <- as.data.frame(test_data)
testing$predicted <- pred
testing %>% mutate(`Affected?` = ifelse(predicted > 0.5, 1, 0)) -> testing
testing$Actual <- as.character(test_labels) #add in actual labels
testing %>% mutate(`Actual` = ifelse(Actual == "TRUE", 1, 0)) -> testing

testing <- as.data.frame(testing) #need to convert to dataframe for the dplyr below to work
testing %>% mutate(TEST = ifelse(testing$Actual == testing$`Affected?`, 0, 1)) -> testing #test to see the diff between affected and actual

# Create the confusion matrix
pred.resp <- ifelse(pred > 0.5, 1, 0) # Set our cutoff threshold
confusionMatrix(as.factor(pred.resp), as.factor(as.numeric(test_labels)), positive="1")
#sensitivity = True Positive = 99.5%
#specificity = True Negative = 98.7%


###############################################################
# plot them features! what's contributing most to our model?
xgb.plot.multi.trees(feature_names = names(diseaseInfo_matrix), 
                     model = model_tuned)

# get information on how important each feature is
importance_matrix <- xgb.importance(names(diseaseInfo_matrix), model = model_tuned)

# and plot it!
xgb.plot.importance(importance_matrix)

###############################################################
library(ROCR)

# Use ROCR package to plot ROC Curve
xgb.pred <- prediction(pred, test_labels)
xgb.perf <- performance(xgb.pred, "tpr", "fpr")

plot(xgb.perf,
     avg="threshold",
     colorize=TRUE,
     lwd=1,
     main="ROC Curve w/ Thresholds",
     print.cutoffs.at=seq(0, 1, by=0.05),
     text.adj=c(-0.5, 0.5),
     text.cex=0.5)
grid(col="lightgray")
axis(1, at=seq(0, 1, by=0.1))
axis(2, at=seq(0, 1, by=0.1))
abline(v=c(0.1, 0.3, 0.5, 0.7, 0.9), col="lightgray", lty="dotted")
abline(h=c(0.1, 0.3, 0.5, 0.7, 0.9), col="lightgray", lty="dotted")
lines(x=c(0, 1), y=c(0, 1), col="black", lty="dotted")

auc_ROCR <- performance(xgb.pred, measure = "auc") #gives the AUC rate
auc_ROCR <- auc_ROCR@y.values[[1]]
