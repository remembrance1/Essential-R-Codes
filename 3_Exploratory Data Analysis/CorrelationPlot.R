###########################################################################################################
#    Function: Correlation Plots                                                                          #
#    Written by: Javier Ng                                                                                #
#    Date: 01/29/2018                                                                                     #
#    Libraries Used: corrplot, RColorBrewer                                                               #
###########################################################################################################

library(corrplot)
library(RColorBrewer)

df <- iris[,1:4] #get dataframe

#or use this to select numeric columns only
df <- dplyr::select_if(iris, is.numeric)

corr <- cor(df, use="complete")

corrplot(corr, method="circle", 
         sig.level = 0.0000112, 
         type="upper", 
         tl.cex = 1, 
         tl.col="black", 
         order="hclust",
         addCoef.col = "black", #add this to display correlation value
         col=brewer.pal(n=8, name="RdYlBu"))

