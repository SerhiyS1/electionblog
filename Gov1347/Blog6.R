## Blog 6 - Serhiy Sokhan

library(tidyverse)
library(ggplot2)

## Setting working directory
setwd("/Users/serhiysokhan/Desktop/SeniorYear/Gov1347")

## Reading in this week's datasets

fo_2012 <- read_csv("fieldoffice_2012_bycounty.csv")
demographics <- read_csv("demographic_1990-2018.csv")
fo_0412 <- read_csv("fieldoffice_2004-2012_dems.csv")
fo_1216 <- read_csv("fieldoffice_2012-2016_byaddress.csv")
popvote_1216 <- read_csv("popvote_bycounty_2012-2016_WI.csv")

## Reading results and polling from previous election cycles, modified as in section

pvstate_df    <- read_csv("popvote_bystate_1948-2016.csv")
pollstate_df  <- read_csv("pollavg_bystate_1968-2016.csv")
pvstate_df$state <- state.abb[match(pvstate_df$state, state.name)]
pollstate_df$state <- state.abb[match(pollstate_df$state, state.name)]

## Dataset merge from Soubhik's section

fulldata <- pvstate_df %>% 
  full_join(pollstate_df %>% 
              filter(weeks_left == 3) %>% 
              group_by(year,party,state) %>% 
              summarise(avg_poll=mean(avg_poll)),
            by = c("year" ,"state")) %>%
  left_join(demographics %>%
              select(-c("total")),
            by = c("year" ,"state"))

fulldata$region <- state.division[match(fulldata$state, state.abb)]
demographics$region <- state.division[match(demographics$state, state.abb)]

changedata <- fulldata %>%
  group_by(state) %>%
  mutate(Asian_change = Asian - lag(Asian, order_by = year),
         Black_change = Black - lag(Black, order_by = year),
         Hispanic_change = Hispanic - lag(Hispanic, order_by = year),
         Indigenous_change = Indigenous - lag(Indigenous, order_by = year),
         White_change = White - lag(White, order_by = year),
         Female_change = Female - lag(Female, order_by = year),
         Male_change = Male - lag(Male, order_by = year),
         age20_change = age20 - lag(age20, order_by = year),
         age3045_change = age3045 - lag(age3045, order_by = year),
         age4565_change = age4565 - lag(age4565, order_by = year),
         age65_change = age65 - lag(age65, order_by = year)
  )

## Blog Focus: Can demographic changes help the Democrats win Texas?

## Part 1: How the change in the number of white people in Texas influences Democratic two-party vote share.

## In this portion, I use the change dataset and filter for the state of Texas and for elections that happened in 1992 or later.  This is because the change
## dataset does not include demographic data on elections prior to 1992.
texas <- changedata %>%
  filter(state == "TX") %>%
  filter(year >= "1992")

## Here, I use the ggplot package to visualize the relationship between the white demographic change and the Democratic two-party vote share. I use geom_point()
## and label by year so viewers of the plot can see which election years the datapoints originate from.  I also create a line with geom_smooth () with the method
## "lm" to create a line of best fit. 
ggplot(texas,aes(x=White_change, y=D_pv2p, label=year)) +
  geom_point() +
  geom_text() +
  geom_smooth(method="lm", formula = y ~ x) +
  xlab("Change in the White Makeup of Texas from the Previous Pres Election (%)") +
  ylab("TX Democratic 2-Party Vote Share (%)") +
  ggtitle("Texas Dem Vote Share vs Change in the White Makeup of Texas")

## I create a linear model and use summary() to get the coefficients of the y-intercept and slope, which I will use for predictions in the final portion of the
## blog.
lm_texas <- lm(D_pv2p ~ White_change, data = texas)
summary(lm_texas)


## Part 2: How the change in the number of women in Texas influences Democratic two-party vote share.

## Here, I use ggplot() with the same methodology as in part 1, but the independent variable is the change in women demographics rather than white demographics.
ggplot(texas,aes(x=Female_change, y=D_pv2p, label=year)) +
  geom_point() +
  geom_text() +
  geom_smooth(method="lm", formula = y ~ x) +
  xlab("Change in the Women Makeup of Texas from the Previous Pres Election (%)") +
  ylab("TX Democratic 2-Party Vote Share (%)") +
  ggtitle("TX Dem Vote Share vs Change in the Women Makeup of Texas")

## Creating a linear model for the Democratic two-party vote share based on changes in the Texas women demographic.
lm_texas2 <- lm(D_pv2p ~ Female_change, data = texas)
summary(lm_texas2)

## Part 3: How the change in the number of black people in Texas influences Democratic two-party vote share.

## Using ggplot() to create a graphic with an independent variable of the change in black demographics in Texas.
ggplot(texas,aes(x=Black_change, y=D_pv2p, label=year)) +
  geom_point() +
  geom_text() +
  geom_smooth(method="lm", formula = y ~ x) +
  xlab("Change in the Black Makeup of Texas from the Previous Pres Election (%)") +
  ylab("TX Democratic 2-Party Vote Share (%)") +
  ggtitle("TX Dem Vote Share vs Change in the Black Makeup of Texas")

## Creating a linear model for the Democratic two-party vote share based on changes in the Texas black demographic.
lm_texas4 <- lm(D_pv2p ~ Black_change, data = texas)
summary(lm_texas4)


