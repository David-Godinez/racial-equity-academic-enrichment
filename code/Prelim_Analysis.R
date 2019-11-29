

# Preliminary -------------------------------------------------------------
library(tidyverse)
library(ggplot2)
library(devtools)
library(RCurl)
library(httr)
library(dplyr)


# Get Data (once repo is public) ----------------------------------------------------------------

School_data <-
  read.csv(
    text = GET(
      "https://github.com/davidgmartinez/final-project/blob/master/data/crdc_tidy_data.csv"
    ),
    header = 1
  )

# Get Data (Download then Upload -- Should be removed once data is --------

crdc_tidy_data <- read.csv("C:/Users/julia/Downloads/crdc_tidy_data.csv")
View(crdc_tidy_data)


# EDA ---------------------------------------------------------------------

#Adding relevant columns
crdc_tidy_data_2 <- mutate(crdc_tidy_data, prop_white = white/total_enrollment)
crdc_tidy_data_2 <- mutate(crdc_tidy_data_2, enrl_ap_total = enrl_ap_white + enrl_ap_black + enrl_ap_hispanic + enrl_ap_asian + enrl_ap_ind_natv + enrl_ap_hinatv_islndr)



#General racial distribution of our sample set based on prop_white
ggplot(data = data_prop_white) + geom_histogram (mapping = aes(x = prop_white), binwidth = .05)

#^mostly non-white (makes sense for urban schools)

ggplot(data = data_prop_white) + geom_point(mapping = aes(x = prop_white, y = enrl_ap_white), na.rm = TRUE)
