# This R environment comes with all of CRAN preinstalled, as well as many other helpful packages
# The environment is defined by the kaggle/rstats docker image: https://github.com/kaggle/docker-rstats
# For example, here's several helpful packages to load in 
setwd("C:/Users/zm679xs/Desktop/R/Essential-R-Codes/EDA Projects/Credit Card Fraud Detection")
library(ggplot2) # Data visualization
library(readr) # CSV file I/O, e.g. the read_csv function
library(caret)
library(DMwR) # smote
library(xgboost)
library(Matrix)
library(reshape) #melt
library(pROC) # AUC

# Input data files are available in the "../input/" directory.
# For example, running this (by clicking run or pressing Shift+Enter) will list the files in the input directory
load("ccdata.RData")

## split into train, test, cv
set.seed(1900)
inTrain <- createDataPartition(y = ccdata$Class, p = .6, list = F) #60% train
train <- ccdata[inTrain,]
testcv <- ccdata[-inTrain,]
inTest <- createDataPartition(y = testcv$Class, p = .5, list = F) #20% test
test <- testcv[inTest,]
cv <- testcv[-inTest,]
train$Class <- as.factor(train$Class)
rm(inTrain, inTest, testcv) #20% cv

#using SMOTE instead
i <- grep("Class", colnames(train)) # Get index Class column
train_smote <- SMOTE(Class ~ ., as.data.frame(train), perc.over = 20000, perc.under=100)
table(train_smote$Class)

#Identify the Predictors and the dependent variable, aka label.
predictors <- colnames(train_smote[-ncol(train_smote)]) #remove last column
#xgboost works only if the labels are numeric. Hence, convert the labels (Species) to numeric.
label <- as.numeric(train_smote[,ncol(train_smote)])

#Alas, xgboost works only if the numeric labels start from 0. Hence, subtract 1 from the label.
label <- as.numeric(train_smote[,ncol(train_smote)])-1
print(table(label))

# set parameters:
parameters <- list(
  # General Parameters
  booster            = "gbtree",          
  silent             = 0,                 
  # Booster Parameters
  eta                = 0.3,               
  gamma              = 0,                 
  max_depth          = 6,                 
  min_child_weight   = 1,                 
  subsample          = 1,                 
  colsample_bytree   = 1,                 
  colsample_bylevel  = 1,                 
  lambda             = 1,                 
  alpha              = 0,                 
  # Task Parameters
  objective          = "binary:logistic",   
  eval_metric        = "auc",
  seed               = 1900               
)

## Training of models
# Original
cv.nround = 200;  # Number of rounds. This can be set to a lower or higher value, if you wish, example: 150 or 250 or 300  
bst.cv <- xgb.cv(
  param=parameters,
  data = as.matrix(train_smote[,predictors]),
  label = label,
  nfold = 3,
  nrounds=cv.nround,
  prediction=T)

#Find where the minimum logloss occurred
min.loss.idx = which.max(bst.cv$evaluation_log[, test_auc_mean]) 
cat("Minimum logloss occurred in round : ", min.loss.idx, "\n")

# Minimum logloss
print(bst.cv$evaluation_log[min.loss.idx,])

#Plot:
melted <- melt(bst.cv$evaluation_log, id.vars="iter")
ggplot(data=melted, aes(x=iter, y=value, group=variable, color = variable)) + geom_line()

## Make predictions
bst <- xgboost(
  param=parameters,
  data =as.matrix(train_smote[,predictors]), #training it without the output variable! 
  label = label,
  nrounds=min.loss.idx)

# Make prediction on the testing data.
test$prediction <- predict(bst, as.matrix(test[,predictors])) #here, I've removed the output variable....

test$prediction <- ifelse(test$prediction >= 0.5, 1 , 0)

#Compute the accuracy of predictions.
confmatrix_table <- confusionMatrix(as.factor(test$prediction), as.factor(test$Class)) #sensitivity (TPR) = 0.9991, specificity = 0.9135
#accuracy = 0.9989

########################################################################################################################

plot_confusion_matrix <- function(test_df, sSubtitle) {
  tst <- data.frame(round(test_df$prediction,0), test_df$Class)
  opts <-  c("Predicted", "True")
  names(tst) <- opts
  cf <- plyr::count(tst)
  cf[opts][cf[opts]==0] <- "Not Fraud"
  cf[opts][cf[opts]==1] <- "Fraud"
  
  ggplot(data =  cf, mapping = aes(x = True, y = Predicted)) +
    labs(title = "Confusion matrix", subtitle = sSubtitle) +
    geom_tile(aes(fill = freq), colour = "grey") +
    geom_text(aes(label = sprintf("%1.0f", freq)), vjust = 1) +
    scale_fill_gradient(low = "lightblue", high = "Green") +
    theme_bw() + theme(legend.position = "none")
  
}

plot_confusion_matrix(test, paste("XGBoost with", paste("min logloss at round: ", min.loss.idx, "\n"),
                                  "Sensitivity:", round(confmatrix_table[[4]][1], 4), "\n",
                                  "Specificity:", round(confmatrix_table[[4]][2], 4)))

#plot a boosted tree model 
xgb.plot.tree(model = bst, trees = 0, show_node_id = T)

#multiple-in-one plot
#Ensemble several trees into a single one
xgb.plot.multi.trees(model = bst)

##plot feature importance
importance_matrix <- xgb.importance(model = bst)
xgb.plot.importance(importance_matrix)


###############################################################
library(ROCR)

# Use ROCR package to plot ROC Curve
xgb.pred <- prediction(test$prediction, test$Class)
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
#AUC = 0.956
