## Serhiy Sokhan Blog 2

## loading libraries
library(tidyverse)
library(ggplot2)

## setting working directory
setwd("/Users/serhiysokhan/Desktop/SeniorYear/Gov1347")

## loading in datasets
economy_df <- read_csv("econ.csv") 
popvote_df <- read_csv("popvote_1948-2016.csv") 

localecon_df <- read_csv("local.csv") 
statevote_df <- read_csv("popvote_bystate_1948-2016.csv") 

## work

localct2 <- localecon_df %>%
  filter(localecon_df$`State and area` == "Connecticut")

localct3 <- localct2 %>%
  filter(localct2$Month == "09") %>%
  select(Year, `State and area`, Unemployed_prce) %>%
  rename(year = Year)

data2 <- statevote_df %>%
  filter(state == "Connecticut") %>%
  filter(year >= 1992) %>%
  select(state, year, D_pv2p) %>%
  left_join(localct3)

ct_data <- data2 %>%
  select(state, year, D_pv2p, Unemployed_prce)

ggplot(ct_data,aes(x=Unemployed_prce, y=D_pv2p, label=year)) +
  geom_point() +
  geom_text() +
  geom_smooth(method="lm", formula = y ~ x) +
  xlab("Unemployment Percentage") +
  ylab("CT Democratic 2-Party Vote Share") +
  ggtitle("CT Dem Vote Share vs Unemployment")

## dem model

lm_ct <- lm(D_pv2p ~ Unemployed_prce, data = ct_data)
summary(lm_ct)

outsamp_model  <- lm(D_pv2p ~ Unemployed_prce, ct_data[ct_data$Unemployed_prce != 5.0,])
outsamp_prediction <- predict(outsamp_model, ct_data[ct_data$Unemployed_prce == 5.0,])
outsamp_test <- ct_data$D_pv2p[ct_data$Unemployed_prce == 5.0]

## FOR GOP
data3 <- statevote_df %>%
  filter(state == "Connecticut") %>%
  filter(year >= 1992) %>%
  select(state, year, R_pv2p) %>%
  left_join(localct3)

ct_data2 <- data3 %>%
  select(state, year, R_pv2p, Unemployed_prce)

ggplot(ct_data2,aes(x=Unemployed_prce, y=R_pv2p, label=year)) +
  geom_point() +
  geom_text() +
  geom_smooth(method="lm", formula = y ~ x) +
  xlab("Unemployment Percentage") +
  ylab("CT Republican 2-Party Vote Share") +
  ggtitle("CT GOP Vote Share vs Unemployment")

## gop model

lm_ctgop <- lm(R_pv2p ~ Unemployed_prce, data = ct_data2)
summary(lm_ctgop)

gop_outsamp_model  <- lm(R_pv2p ~ Unemployed_prce, ct_data2[ct_data2$Unemployed_prce != 5.0,])
gggop_outsamp_prediction <- predict(gop_outsamp_model, ct_data2[ct_data2$Unemployed_prce == 5.0,])
gop_outsamp_test <- ct_data2$R_pv2p[ct_data2$Unemployed_prce == 5.0]
