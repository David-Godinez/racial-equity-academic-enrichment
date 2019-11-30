# Preliminary -------------------------------------------------------------
library(tidyverse)
library(ggplot2)
library(RCurl)
library(httr)
library(dplyr)

# Get Data (once repo is public) ----------------------------------------------------------------

crdc_tidy_data <-
  
  read.csv(
    text = GET(
      "https://github.com/davidgmartinez/final-project/blob/master/data/crdc_tidy_data.csv"
    ),
    
    header = 1
    
  )

# Get Data (Download then Upload -- Should be removed once data is public)--------

crdc_tidy_data <-
  read.csv("C:/Users/julia/Downloads/crdc_tidy_data.csv") #would use 'here' if using this long-term

View(crdc_tidy_data)

# Data Prep ---------------------------------------------------------------------

#Adding relevant columns to df

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data, prop_white = white / total_enrollment)

crdc_tidy_data_2 <-
  mutate(
    crdc_tidy_data_2,
    enrl_ap_total = enrl_ap_white + enrl_ap_black + enrl_ap_hispanic + enrl_ap_asian + enrl_ap_ind_natv + enrl_ap_hinatv_islndr
  )

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_enrl_ap_total = enrl_ap_total / total_enrollment)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_black_enrl_ap = enrl_ap_black / black)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_hispanic_enrl_ap = enrl_ap_hispanic / hispanic)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_white_enrl_ap = enrl_ap_white / white)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_asian_enrl_ap = enrl_ap_asian / asian)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_ind_ntv_enrl_ap = enrl_ap_ind_natv / amindian_alnative)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2,
         prop_hintv_islandr_enrl_ap = enrl_ap_hinatv_islndr / hi_native_islander)

#splitting charter and traditional public
charter_data <- filter(crdc_tidy_data_2, charter == 1)
trad_public_data <- filter(crdc_tidy_data_2, charter == 0)


# EDA ---------------------------------------------------------------------


#General racial distribution of our sample set based on prop_white

ggplot(data = crdc_tidy_data_2) + geom_histogram (mapping = aes(x = prop_white), binwidth = .05)
#^mostly non-white (makes sense for urban schools)


#White AP enrollment based on proportion white
ggplot(data = crdc_tidy_data_2) + geom_point(mapping = aes(x = prop_white, y = enrl_ap_white),
                                             na.rm = TRUE)

#Overall AP enrollment proportion based on white proportion, color charter
ggplot(data = crdc_tidy_data_2) + geom_point(
  mapping = aes(x = prop_white, y = prop_enrl_ap_total, color = charter),
  na.rm = TRUE
)

#Same as above, but with a regression line
ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_enrl_ap_total, color = charter)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#!! shows the positive correlation between prop_white and prop_enrl_ap_total
#(aka overall, more white urban schools have higher proportion enrolled in AP classes)

#CHARTER: Overall AP enrollment proportion based on white proportion
ggplot(data = charter_data, aes(x = prop_white, y = prop_enrl_ap_total)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#!! negative correlation: more white schools have lower overall AP Enrollment

#PUBLIC: Overall AP enrollment proportion based on white proportion
ggplot(data = trad_public_data, aes(x = prop_white, y = prop_enrl_ap_total)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#!! positive correlation: more white schools have higher overall AP Enrollment

#--------Black AP Enrollment vs. School proportion White
ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_black_enrl_ap, color = charter)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

ggplot(data = charter_data, aes(x = prop_white, y = prop_black_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a charter school increases, the proportion of black students enrolled in an AP class decreases

ggplot(data = trad_public_data, aes(x = prop_white, y = prop_black_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a traditional public school increases, the proportion of black students enrolled in an AP class remains roughly the same

#-------Hispanic AP Enrollment vs. School proportion white
ggplot(data = crdc_tidy_data_2,
       aes(x = prop_white, y = prop_hispanic_enrl_ap, color = charter)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

ggplot(data = charter_data, aes(x = prop_white, y = prop_hispanic_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a charter school increases, the proportion of hispanic students enrolled in an AP class decreases

ggplot(data = trad_public_data, aes(x = prop_white, y = prop_hispanic_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a traditional public school increases, the proportion of hispanic students enrolled in an AP class remains roughly the same (increases slightly)

#-------White AP Enrollment vs. School proportion white
ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_white_enrl_ap, color = charter)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

ggplot(data = charter_data, aes(x = prop_white, y = prop_white_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a charter school increases, the proportion of White students enrolled in an AP class decreases

ggplot(data = trad_public_data, aes(x = prop_white, y = prop_white_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a traditional public school increases, the proportion of White students enrolled in an AP class increases

#-------Asian AP Enrollment vs. School proportion white
ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_asian_enrl_ap, color = charter)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

ggplot(data = charter_data, aes(x = prop_white, y = prop_asian_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a charter school increases, the proportion of Asian students enrolled in an AP class decreases slightly

ggplot(data = trad_public_data, aes(x = prop_white, y = prop_asian_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a traditional public school increases, the proportion of Asian students enrolled in an AP class increases

#-------American Indian/Alaska Native AP Enrollment vs. School proportion white
ggplot(data = crdc_tidy_data_2,
       aes(x = prop_white, y = prop_ind_ntv_enrl_ap, color = charter)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

ggplot(data = charter_data, aes(x = prop_white, y = prop_ind_ntv_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a charter school increases, the proportion of American Indian/Alaska Native students enrolled in an AP class decreases

ggplot(data = trad_public_data, aes(x = prop_white, y = prop_ind_ntv_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a traditional public school increases, the proportion of American Indian/Alaska Native students enrolled in an AP class increases

#-------Hawaiian/Pacific Islander vs. School proportion white
ggplot(data = crdc_tidy_data_2,
       aes(x = prop_white, y = prop_hintv_islandr_enrl_ap, color = charter)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

ggplot(data = charter_data, aes(x = prop_white, y = prop_hintv_islandr_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a charter school increases, the proportion of Hawaiian/Pacific Islander students enrolled in an AP class increases slightly

ggplot(data = trad_public_data, aes(x = prop_white, y = prop_hintv_islandr_enrl_ap)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
#As the proportion of white students in a traditional public school increases, the proportion of Hawaiian/Pacific Islander students enrolled in an AP class increases slightly
