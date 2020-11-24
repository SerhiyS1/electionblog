## Reflection - Serhiy Sokhan

library(tidyverse)
library(ggplot2)
library(reshape2)
library(usmap)
library(ggrepel)



## Setting working directory
setwd("/Users/serhiysokhan/Desktop/SeniorYear/Gov1347")

## Reading in data

prediction <- read_csv("adjust.csv")

prediction$pred_gop_margin <- prediction$gop_margin

predictions <- prediction

results_per_state <- read_csv("popvote_bystate_1948-2020.csv") %>%
  filter(year == "2020") %>%
  mutate(gop_margin = (R_pv2p - D_pv2p)*100)

results_per_state$state <- state.abb[match(results_per_state$state, state.name)]

## joining data

total <- merge(results_per_state, predictions, by = "state") %>%
  select(state, gop_margin.x, pred_gop_margin) %>% 
  mutate(error = gop_margin.x - pred_gop_margin)


## graphing
ggplot(total, aes(x = pred_gop_margin, y = gop_margin.x)) +
  geom_point() +
  geom_smooth(method = "lm") +
  xlab("Predicted GOP Margin (%)") +
  ylab("Actual GOP Margin (%)") +
  ggtitle("GOP Margin, Actual vs. Predicted (%)")


ggplot(total, aes(x = pred_gop_margin, y = gop_margin.x)) +
  geom_point() +
  geom_smooth(method = "lm") +
  xlab("Predicted GOP Margin (%)") +
  ylab("Actual GOP Margin (%)") +
  ggtitle("GOP Margin, Actual vs. Predicted (%)") +
  ggrepel::geom_label_repel(data = total,
                            mapping = aes(x = pred_gop_margin, y = gop_margin.x, label = state))

lim <- lm(total$gop_margin.x ~ total$pred_gop_margin)

summary(lim)

ggplot(total, aes(x = state, y = error)) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("State") +
  ylab("Forecast's GOP Margin Error (%)") +
  ggtitle("Forecast's GOP Margin Error by State (%)")