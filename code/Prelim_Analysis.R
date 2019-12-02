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
#^having some challenges with this, may just need to use here()

# Get Data (Download then Upload -- Should be removed once data is public)--------

crdc_tidy_data <-
  read.csv("C:/Users/julia/Downloads/crdc_tidy_data.csv") #would use 'here' if using this long-term

View(crdc_tidy_data)

# Data Prep ---------------------------------------------------------------------

#Adding relevant columns to df

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data, prop_white = white / total_enrollment)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data2, prop_black = black / total_enrollment)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data2, prop_hispanic = hispanic / total_enrollment)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data2, prop_asian = asian / total_enrollment)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data2, prop_ind_natv = amindian_alnative / total_enrollment)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data2, prop_hinatv_islndr = hi_native_islander / total_enrollment)

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

crdc_tidy_data_2 <-
  mutate(
    crdc_tidy_data_2,
    enrl_ib_total = enrl_ib_white + enrl_ib_black + enrl_ib_hispanic + enrl_ib_asian + enrl_ib_ind_natv + enrl_ib_hinatv_islndr
  )

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_enrl_ib_total = enrl_ib_total / total_enrollment)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_black_enrl_ib = enrl_ib_black / black)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_hispanic_enrl_ib = enrl_ib_hispanic / hispanic)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_white_enrl_ib = enrl_ib_white / white)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_asian_enrl_ib = enrl_ib_asian / asian)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2, prop_ind_ntv_enrl_ib = enrl_ib_ind_natv / amindian_alnative)

crdc_tidy_data_2 <-
  mutate(crdc_tidy_data_2,
         prop_hintv_islandr_enrl_ib = enrl_ib_hinatv_islndr / hi_native_islander)

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

#Models -------------------------------
all_school_model = lm(formula = prop_enrl_ap_total ~ prop_white, data = crdc_tidy_data_2)
summary(all_school_model)
#coef 0.086926
#p-value 0.001822 -- SIGNIFICANT

trad_public_model = lm(formula = prop_enrl_ap_total ~ prop_white, data = trad_public_data)
summary(trad_public_model)
#coef 0.16234
#p-value 2.465e-08 -- SIGNIFICANT

charter_model = lm(formula = prop_enrl_ap_total ~ prop_white, data = charter_data)
summary(charter_model)
#coef -0.12234
#p-value 0.0771 -- NOT SIGNIFICANT

all_school_ib_model = lm(formula = prop_enrl_ib_total ~ prop_white, data = crdc_tidy_data_2)
summary(all_school_ib_model)
#coef -0.19639
#p-value 0.22 -- NOT SIGNIFICANT

charter_ib_model = lm(formula = prop_enrl_ib_total ~ prop_white, data = charter_data)
summary(charter_ib_model)
#coef 8.67 (huge)
#p-value 0.2029 -- NOT SIGNIFICANT

trad_public_ib_model = lm(formula = prop_enrl_ib_total ~ prop_white, data = trad_public_data)
summary(trad_public_ib_model)
#coef 0.14798
#p-value .007802 -- SIGNIFICANT

prop_AP_black_model = lm(formula = prop_black_enrl_ap ~ prop_white, data = crdc_tidy_data_2)
summary(prop_AP_black_model)
#coef -0.022590
#p-value .4754 -- VERY NOT SIGNIFICANT

prop_AP_black_charter_model = lm(formula = prop_black_enrl_ap ~ prop_white, data = charter_data)
summary(prop_AP_black_charter_model)
#coef -0.16026
#p-value 0.02826
#NOTE: proportion of black students enrolled in an AP according to white school population IS significant
#in *charters* and negative

prop_AP_black_trad_public_model = lm(formula = prop_black_enrl_ap ~ prop_white, data = trad_public_data)
summary(prop_AP_black_trad_public_model)
#coef 0.026323
#p-value 0.4472 -- VERY NOT SIGNIFICANT

prop_AP_hispanic_model = lm(formula = prop_hispanic_enrl_ap ~ prop_white, data = crdc_tidy_data_2)
summary(prop_AP_hispanic_model)
#coef -0.008078
#p-value 0.7872 -- VERY NOT SIGNIFICANT

prop_AP_hispanic_charter_model = lm(formula = prop_hispanic_enrl_ap ~ prop_white, data = charter_data)
summary(prop_AP_hispanic_charter_model)
#coef -0.14265
#p-value 0.05368 -- SIGNIFICANT at .1 LEVEL

prop_AP_hispanic_trad_public_model = lm(formula = prop_hispanic_enrl_ap ~ prop_white, data = trad_public_data)
summary(prop_AP_hispanic_trad_public_model)
#coef 0.040377
#p-value 0.2014 -- NOT SIGNIFICANT

#KEY TAKEAWAY: There is a statistically significant negative relationship
# between increased proportions of white students in urban charter schools
# and the proportion of black and hispanic students enrolled in AP programs.
# There is not a similar statistically significant relationship in urban
# traditional public schools.
