## Reflection - Serhiy Sokhan

library(tidyverse)
library(ggplot2)
library(reshape2)
library(usmap)
library(ggrepel)



## Setting working directory
setwd("/Users/serhiysokhan/Desktop/SeniorYear/Gov1347")

## Reading in data

results_per_state <- read_csv("popvote_bystate_1948-2020.csv") %>%
  filter(year == "2020") %>%
  mutate(gop_margin = (R_pv2p - D_pv2p)*100)

results_per_state$state <- state.abb[match(results_per_state$state, state.name)]

exit_polls <- read_csv("exitpolls.csv")

exits <- exit_polls %>%
  mutate(dem_margin = Democrat - Republican)

ggplot(exits, aes(x=race_gender, y= dem_margin, fill = as.factor(year))) + 
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(name = "Election Year", values =c("purple", "orange")) +
  xlab("Race and Sex") +
  ylab("Democratic Margin (%)") +
  ggtitle("Democratic Margin by Race and Sex in the 2016 and 2020 Elections") +
  scale_x_discrete(labels=c(black_men = "Black Men", black_women = "Black Women", latina_women = "Latina Women", latino_men = 
                              "Latino Men", white_men = "White Men", white_women = "White Women")) +
  geom_text(aes(label = round(dem_margin, digits = 2)), position = position_dodge(width = 1), 
           vjust = -0.5, size = 3.0)