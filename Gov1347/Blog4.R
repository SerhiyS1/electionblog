library(tidyverse)
library(ggplot2)

## setting working directory
setwd("/Users/serhiysokhan/Desktop/SeniorYear/Gov1347")


## reading in this week's datasets
popvote_df    <- read_csv("popvote_1948-2016.csv")
pvstate_df    <- read_csv("popvote_bystate_1948-2016.csv")
economy_df    <- read_csv("econ.csv")
approval_df   <- read_csv("approval_gallup_1941-2020.csv")
pollstate_df  <- read_csv("pollavg_bystate_1968-2016.csv")
fedgrants_df  <- read_csv("fedgrants_bystate_1988-2008.csv")

## merge of data from lab
merged <- popvote_df %>%
  filter(incumbent_party) %>%
  select(year, candidate, party, pv, pv2p, incumbent) %>%
  inner_join(
    approval_df %>% 
      group_by(year, president) %>% 
      slice(1) %>% 
      mutate(net_approve=approve-disapprove) %>%
      select(year, incumbent_pres=president, net_approve, poll_enddate),
    by="year"
  ) %>%
  inner_join(
    economy_df %>%
      filter(quarter == 2) %>%
      select(GDP_growth_qt, year),
    by="year"
  )

## Graph 1 - Incumbency Advantage

p <- ggplot(popvote_df, aes(x = incumbent, y = pv2p))+
  geom_jitter(stat = "identity", aes(color = as.factor(year))) +
  scale_color_manual(name = "Year", values = c("green", "purple", "orange", 
                                "red", "yellow", "black",
                                "blue", "mediumspringgreen", "powderblue",
                                "salmon", "pink", "plum",
                                "tan", "mediumvioletred", "maroon",
                                "lightyellow", "orangered", "turquoise")) +
  geom_boxplot(alpha = 0.1) +
  scale_y_continuous(name = "Two-Party Vote Share (%)",
                     breaks = seq(37.5, 62.5, 2.5)) +
  ggtitle("Incumbency Status and Two-Party Vote Share") +
  xlab("Candidate's Incumbency Status") 

ggplot_build(p)$data


## Graph 2 - Incumbency Party Advantage

x <- ggplot(popvote_df, aes(x = incumbent_party, y = pv2p))+
  geom_jitter(stat = "identity", aes(color = as.factor(year))) +
  scale_color_manual(name = "Year", values = c("green", "purple", "orange", 
                                "red", "yellow", "black",
                                "blue", "mediumspringgreen", "powderblue",
                                "salmon", "pink", "plum",
                                "tan", "mediumvioletred", "maroon",
                                "lightyellow", "orangered", "turquoise")) +
  geom_boxplot(alpha = 0.1) +
  scale_y_continuous(name = "Two-Party Vote Share (%)", 
                     breaks = seq(37.5, 62.5, 2.5)) +
  ggtitle("Incumbent Party Status and Two-Party Vote Share") +
  xlab("Incumbent Party Status") 

ggplot_build(x)$data

## Graph 3 

incumbents <- merged %>%
  filter(incumbent == "TRUE") %>%
  left_join(popvote_df %>%
              filter(incumbent == "TRUE"))

incumbents$winner = factor(incumbents$winner, levels = c("TRUE", "FALSE"))

ggplot(incumbents, aes(x = year, y = net_approve)) +
  geom_point(stat = "identity", aes(color = winner)) +
  scale_color_manual(name = "Election Outcome", labels = c("Winner", "Loser"), values = c("seagreen", "violetred")) +
  scale_x_continuous(name = "Election Year",
                     breaks = seq(1948, 2012, 8)) +
  scale_y_continuous(name = "Net Approval Rating (%)", 
                     breaks = seq(-30, 70, 10)) +
  ggtitle("Incumbent President Approval Rating and Election Outcome")

