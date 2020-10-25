## Blog 7 - Serhiy Sokhan

library(tidyverse)
library(ggplot2)
library(reshape2)


## Setting working directory
setwd("/Users/serhiysokhan/Desktop/SeniorYear/Gov1347")

## Reading in this week's datasets

cdc_data <- read_csv("cdc_bystate.csv")

cdc_county <- read_csv("cdc_bycounty.csv")

polls <- read_csv("polls_2020.csv")

## Work for Part 1

states <- cdc_county %>%
  group_by(State) %>%
  summarize(covid = sum(`Deaths involving COVID-19`),
            alldeaths = sum(`Deaths from All Causes`))

covid_states <- states %>% 
  mutate(covid_pct_death = (covid/alldeaths) *100)

ggplot(covid_states, aes(State, covid_pct_death)) +
  geom_bar(stat = "identity", position = "dodge") +
  ylab("Percent of Deaths Due to COVID-19, 2/1/20 - 10/10/20") +
  xlab("State") +
  ggtitle("Percent of Deaths Due to COVID-19 by State, 2/1/2020 - 10/10/2020") +
  theme_minimal()


## Continuation of Work on Part 1

covid_swing <- covid_states %>%
  filter(State %in% c("PA", "WI", "FL", "MI", "NC", "AZ", "MN"))

ggplot(covid_swing, aes(State, covid_pct_death)) +
  geom_bar(stat = "identity", position = "dodge") +
  ylab("Percent of Deaths Due to COVID-19, 2/1 - 10/10/20") +
  xlab("Swing State") +
  ggtitle("Percent of Deaths Due to COVID-19 by Swing State, 2/1/2020 - 10/10/2020") +
  theme_minimal()

### Work on Part 2

polls$state <- state.abb[match(polls$state, state.name)]

polls$start_date <- as.Date(polls$start_date, format = "%m/%d/%y")

new <- polls %>%
  filter(!is.na(polls$state)) %>%
  filter(answer %in% c("Biden", "Trump")) %>%
  filter(fte_grade %in% c("A-", "A", "A+")) %>%
  filter(start_date >= as.Date("2020-08-01")) %>%
  select(poll_id, state, pollster, fte_grade, sample_size, start_date, end_date, answer, pct) %>%
  group_by(state)

newnew <- new %>%
  filter(state %in% c("PA", "WI", "FL", "MI", "NC", "AZ", "MN")) %>%
  select(state, answer, pct)

newdata <- melt(newnew, id.vars = c("state", "answer"))

means <- dcast(newdata, answer~state, mean)

works <- melt(means)

ggplot(works, aes(x=variable, y= value, fill = answer)) + 
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values =c("blue", "red")) +
  xlab("Swing State") +
  ylab("Polling Average, 8/1 - 9/20/20 (%)") +
  ggtitle("Polling Average in Swing States, 8/1 - 9/20/20") +
  labs(fill = "Candidate") +
  geom_text(aes(label = round(value, digits = 2)), position = position_dodge(width = 1), 
            vjust = -0.5, size = 3.0)

  

