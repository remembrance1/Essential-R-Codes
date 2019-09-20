setwd("C:/Users/zm679xs/Desktop/R/Essential-R-Codes/EDA Projects/Adult_Age")

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
#Accuracy - 89.49%` 
# 0: <=50k & 1: >50k

#convert characters to factors
fact_col <- colnames(train)[sapply(train,is.character)]

for(i in fact_col) set(train,j=i,value = factor(train[[i]]))
for (i in fact_col) set(test,j=i,value = factor(test[[i]]))

#create tasks
traintask <- makeClassifTask(data = train,target = "target")
testtask <- makeClassifTask (data = test,target = "target")

#do one hot encoding`<br/> 
traintask <- createDummyFeatures (obj = traintask,target = "target") 
testtask <- createDummyFeatures (obj = testtask,target = "target")




























test$pred <- xgbpred
test$actual <- ts_label

###########################################################
#multiple-in-one plot
#Ensemble several trees into a single one
xgb.plot.multi.trees(model = xgb1)

##plot feature importance
importance_matrix <- xgb.importance(model = xgb1)
xgb.plot.importance(importance_matrix, top_n = 10)


###############################################################
library(ROCR)

# Use ROCR package to plot ROC Curve
xgb.pred <- prediction(as.numeric(test$pred), as.numeric(test$actual))
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
auc_ROCR 
#AUC = 0.831

