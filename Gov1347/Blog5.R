library(tidyverse)
library(ggplot2)
library(scales)
library(reshape2)


## setting working directory
setwd("/Users/serhiysokhan/Desktop/SeniorYear/Gov1347")


## reading in this week's datasets
popvote_df    <- read_csv("popvote_1948-2016.csv")
pvstate_df    <- read_csv("popvote_bystate_1948-2016.csv")
pollstate_df  <- read_csv("pollavg_bystate_1968-2016.csv")
pollavg_df <- read_csv("pollavg_1968-2016.csv")
ad_campaign_df <- read_csv("ad_campaigns_2000-2012.csv")
ad_creative_df <- read_csv("ad_creative_2000-2012.csv")
ads_new <- read_csv("ads_2020.csv")
polls_2016 <- read_csv("polls_2016.csv")
polls_2020 <- read_csv("polls_2020.csv")
vep_df <- read_csv("vep_1980-2016.csv")

new <- left_join(ad_campaign_df, ad_creative_df, group_by = c("creative", "party", "cycle"))

## Part 1 - Total Cost Per Election Per Party

cost <- ad_campaign_df %>%
  select(party, total_cost, cycle) %>%
  group_by(cycle, party) %>%
  summarise(total_spending = sum(total_cost), .groups = 'keep') 

ggplot(data = cost, aes(x = party, y = total_spending, fill = party)) + 
  geom_col(stat = "identity") + 
  scale_fill_manual(values = c(
    "democrat" = "blue",
    "republican" = "red"
  ),
  name = "Party") +
  facet_wrap(~cycle) +
  geom_text(aes(label = total_spending), vjust = 0.05, size = 3.0) +
  scale_y_continuous(breaks = c(0,1200000000)) +
  ylab("Total Advertising Spending ($)") +
  xlab("Party") +
  ggtitle("Total Advertising Spend Per Party, 2000-2012")

## Part 2 2020 Tipping State Ad Spending


tipping <- ads_new %>%
  filter(state %in% c("FL", "WI", "PA")) %>%
  filter(period_startdate == "2020-09-05") %>%
  group_by(state)

tipping_long <- melt(tipping) %>%
  filter(variable %in% c("biden_airings", "trump_airings"))
  
ggplot(tipping_long, aes(x = state, y = value, fill = variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c(
    "biden_airings" = "blue",
    "trump_airings" = "red"
  ), name = "Candidate",
  labels = c("Biden", "Trump")) +
  ylab("Number of Advertisements Aired") +
  xlab("State") +
  ggtitle("Ads Aired 9/5 - 9/27, Tipping Point States") +
  geom_text(aes(label = value), vjust = -0.5, size = 3.0, position = position_dodge(width = 1))

