###########################################################################################################
#    Function: Stacked & Grouped Bar Charts                                                               #
#    Written by: Javier Ng                                                                                #
#    Date: 12/14/2018                                                                                     #
#    Libraries Used: ggthemes, ggplot2                                                                    #
###########################################################################################################

library(ggthemes)
library(ggplot2)

plotc <- ggplot(df, aes(x = Skill, y = value, fill = Level)) + 
  geom_bar(position = "stack", stat="identity") + 
  labs(x="A", y= "B", title = "C") +
  facet_grid(.~Country) +
  scale_y_continuous(limits = c(0,9), breaks = 1:9) +
  theme_wsj() + #wall street journal presentation 
  scale_fill_wsj('colors6', '') +
  theme(axis.text.x = element_text(angle = 90, size = 12))