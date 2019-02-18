setwd("C:/Users/Javier Ng/Desktop/Rfiles/Essential-R-Codes/EDA Projects/Adult_Age")

library(data.table)
library(mlr)
library(xgboost)

#set variable names
setcol <- c("age", "workclass", "fnlwgt", "education", "education-num", "marital-status", "occupation", "relationship", "race", "sex", "capital-gain", "capital-loss", "hours-per-week", "native-country", "target")

#load data
train <- read.table("adult.txt", header = F, sep = ",", col.names = setcol, na.strings = c(" ?"), stringsAsFactors = F)
test <- read.table("adult.txt",header = F,sep = ",",col.names = setcol,skip = 1, na.strings = c(" ?"),stringsAsFactors = F)

#convert to dt
setDT(train)
setDT(test)

#check missing values 
 table(is.na(train))
 sapply(train, function(x) sum(is.na(x))/length(x))*100

 table(is.na(test))
 sapply(test, function(x) sum(is.na(x))/length(x))*100

#quick data cleaning
#remove extra character from target variable
 library(stringr)
 test [,target := substr(target,start = 1,stop = nchar(target)-1)]

#remove leading whitespaces
 char_col <- colnames(train)[ sapply (test,is.character)]
 for(i in char_col) set(train,j=i,value = str_trim(train[[i]],side = "left"))

 for(i in char_col) set(test,j=i,value = str_trim(test[[i]],side = "left"))

#set all missing value as "Missing" 
train[is.na(train)] <- "Missing" 
test[is.na(test)] <- "Missing"
 
 #using one hot encoding 
labels <- train$target 
ts_label <- test$target
new_tr <- model.matrix(~.+0,data = train[,-c("target"),with=F]) 
new_ts <- model.matrix(~.+0,data = test[,-c("target"),with=F])
 
 #convert factor to numeric 
labels <- as.factor(labels)
ts_label <- as.factor(ts_label)
labels <- as.numeric(labels)-1
ts_label <- as.numeric(ts_label)-1

#preparing matrix 
dtrain <- xgb.DMatrix(data = new_tr,label = labels) 
dtest <- xgb.DMatrix(data = new_ts,label= ts_label)

#default parameters
params <- list(booster = "gbtree", objective = "binary:logistic", eta=0.3, gamma=0, max_depth=6, min_child_weight=1, subsample=1, colsample_bytree=1)

xgbcv <- xgb.cv( params = params, data = dtrain, nrounds = 100, nfold = 5, showsd = T, stratified = T, print.every.n = 10, early.stop.round = 20, maximize = F)
## best iteration = 63

## to get the best iteration of CV
xgbcv$best_iteration

## to see the test_error_mean....
xgbcv$evaluation_log[63,]

#calculate test set accuracy
#first default - model training
xgb1 <- xgb.train (params = params, data = dtrain, nrounds = 79, watchlist = list(val=dtest,train=dtrain), print.every.n = 10, early.stop.round = 10, maximize = F , eval_metric = "error")
#model prediction
xgbpred <- predict(xgb1,dtest)
xgbpred <- ifelse(xgbpred > 0.5,1,0) #adding logistic reg binary outcome

#confusion matrix
library(caret)
ts_label <- as.factor(ts_label)
xgbpred <- as.factor(xgbpred)
confusionMatrix(xgbpred, ts_label)
#Accuracy - 86.54%` 

