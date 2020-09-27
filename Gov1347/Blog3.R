## Blog Post 3 Graphics Code

## loading in libraries
library(tidyverse)
library(ggplot2)
library(readr)

## setting working directory
setwd("/Users/serhiysokhan/Desktop/SeniorYear/Gov1347")

## reading in files

urlfile="https://raw.githubusercontent.com/fivethirtyeight/data/master/pollster-ratings/2016/pollster-ratings.csv"

fte_rating <- read_csv(url(urlfile))

popvote <- read_csv("popvote_1948-2016.csv")
economy <- read_csv("econ.csv")
poll    <- read_csv("pollavg_1968-2016.csv")
polls_old <- read_csv("polls_2016.csv")
polls_new <- read_csv("polls_2020.csv")

## Cleaning data for 2016 pollsters rating by 538

fte_dist <- fte_rating %>%
  select(ID, Pollster, '538 Grade')

ftegrades <- fte_dist$'538 Grade' 

ftegrades2 <- fte_dist$`538 Grade` <- factor(fte_dist$`538 Grade`, levels = c("A+", "A", "A-", "B+", "B", "B-",
                                                                              "C+", "C", "C-","D+", "D", "D-",
                                                                              "F"))

## Creating plot
ggplot(data.frame(ftegrades2),aes(x = ftegrades2)) +
  geom_bar(stat = "count", aes(fill = "red")) +
  xlab("538 Poll Rating, 2016") +
  ylab("Amount of Pollsters") +
  ggtitle("2016 538 Pollster Ratings") +
  theme(legend.position = "none") 

## Building a model for 2020

polls_new$start_date <- as.Date(polls_new$start_date, format = "%m/%d/%y")

star_polls <- polls_new %>%
  filter(pollster %in% c("Monmouth University", "Selzer & Co.", "ABC News/The Washington Post")) %>%
  filter(is.na(state)) %>%
  filter(answer %in% c("Trump", "Biden")) %>%
  filter(start_date >= as.Date("2020-08-01")) %>%
  select(pollster, answer, start_date,  pct) %>%
  group_by(answer, pollster)


ggplot(star_polls, aes(x = answer, y = pct))+
  geom_jitter(stat = "identity", aes(color = pollster)) +
  scale_color_manual(values = c("green", "purple", "orange")) +
  geom_boxplot(alpha = 0.1) +
  scale_y_continuous(name = "Polling Percentage",
                     breaks = seq(30, 60, 2.5)) +
  ggtitle("'16 Star Polls in 8/20 - Present") +
  xlab("Candidate") 

biden_avg <- star_polls %>%
  filter(answer == 'Biden')

mean(biden_avg$pct)

trump_avg <- star_polls %>%
  filter(answer == 'Trump')

mean(trump_avg$pct)
