## Blog 8 - Serhiy Sokhan

library(tidyverse)
library(ggplot2)
library(reshape2)
library(usmap)


## Setting working directory
setwd("/Users/serhiysokhan/Desktop/SeniorYear/Gov1347")

## Gathering poll data from FiveThirtyEight


fte_link <- "https://projects.fivethirtyeight.com/polls-page/president_polls.csv"

fte_polls <- read_csv(fte_link)

fte_polls$state <- state.abb[match(fte_polls$state, state.name)]

fte_polls$end_date <- as.Date(fte_polls$end_date, format = "%m/%d/%y")

data <- fte_polls %>%
  filter(candidate_party %in% c("REP", "DEM")) %>%
  filter(!is.na(state)) %>%
  select(poll_id, cycle, state, pollster, fte_grade, sample_size, start_date, end_date, election_date, answer, candidate_name, candidate_party, pct) %>%
  filter(!is.na(fte_grade)) %>%
  filter(end_date >= as.Date("2020-10-20")) %>%
  filter(fte_grade %in% c("A+", "A", "A-", "B+", "B", "B-", "C+", "C", "B/C"))

working <- data %>%
  select(state, candidate_party, pct)

newwork <- melt(working, id.vars = c("state", "candidate_party"))

refit <- dcast(newwork, candidate_party~state, mean)

final <- melt(refit)

adjust <- final %>%
  group_by(variable) %>%
  mutate(gop_margin = value - lag(value, default = first(value))) %>%
  filter(gop_margin != 0) %>%
  select(variable,gop_margin)

adjust$state <- adjust$variable

plot_usmap(data = adjust, regions = "states", values = "gop_margin", labels = FALSE) +
  scale_fill_gradient2(
    high = "red", 
    mid = "white",
    low = "blue", 
    breaks = c(-35,-20,-5,0,5,20,35), 
    limits = c(-35,35),
    name = "GOP Margin (%)"
  ) +
  theme_void()


ggplot(adjust, aes(x=variable, y= gop_margin)) + 
  geom_bar(stat = "identity", position = "dodge") +
  xlab("State") +
  ylab("Forecasted GOP Margin (%)") +
  ggtitle("Forecasted GOP Margin by State, 2020 Election")
           

swings <- adjust %>%
  filter(gop_margin <= 10.0) %>%
  filter(gop_margin >= -10.0)

ggplot(swings, aes(x=variable, y= gop_margin)) + 
  geom_bar(stat = "identity", position = "dodge") +
  xlab("State") +
  ylab("Forecasted GOP Margin (%)") +
  ggtitle("Forecasted GOP Margin by State, 2020 Election")


### testing with 2016 data

polls2016 <- read_csv("polls_2016.csv")

polls2016$state <- state.abb[match(polls2016$state, state.name)]

polls2016$enddate <- as.Date(polls2016$enddate, format = "%m/%d/%y")

data2016 <- polls2016 %>%
  filter(!is.na(state)) %>%
  filter(!is.na(grade)) %>%
  filter(enddate >= as.Date("2020-10-25")) %>%
  filter(enddate <= as.Date("2020-11-08")) %>%
  filter(grade %in% c("A+", "A", "A-", "B+", "B", "B-", "C+", "C", "B/C")) %>%
  mutate(gop_margin = rawpoll_trump - rawpoll_clinton)

working2016 <- data2016 %>%
  select(state, gop_margin) %>%
  group_by(state) %>%
  mutate(avg = mean(gop_margin))

working2016$gopmargin <- final2016$avg

final2016 <- working2016 %>%
  select(state, gopmargin)

final2016 %>%
  group_by(state) %>%
  dplyr::filter(n() == 1) %>%
  ungroup()
  


