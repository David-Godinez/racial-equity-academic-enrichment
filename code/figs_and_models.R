#Figures and Models

# Preliminaries -----------------------------------------------------------

library(tidyverse)
library(patchwork)
library(ggplot2)

##Requires objects and data frames created in `Data_Analysis.R`

# Prop White vs. Black AP Ernl --------------------------------------------


## Scatterplot:


#Linear
ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_black_enrl_ap)) + 
  geom_point(aes(color = school_type)) +
  geom_smooth(aes(linetype  = school_type), method = 'lm', se = FALSE) +
  xlim(0.0, 0.80) + labs(x = "Proportion White", y = "Proportion Black Students in AP", title = "Black") +
  ggsave("black_ap.pdf")

ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_black_enrl_ap)) + 
  geom_point(aes(color = school_type)) +
  geom_smooth(aes(linetype  = school_type), method = 'lm', se = TRUE) +
  xlim(0.0, 0.80) + labs(x = "Proportion White", y = "Proportion Black Students in AP", title = "Black") +
  ggsave("black_ap_se.jpg")



#non_linear
ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_black_enrl_ap)) + 
  geom_point(aes(color = school_type)) +
  geom_smooth(aes(linetype  = school_type), se = TRUE) +
  xlim(0.0, 0.80) + labs(x = "Proportion White", y = "Proportion Black Students in AP", title = "Black") +
  ggsave("black_nonparam.png")


## Model:


##ALL

prop_AP_black_model = lm(formula = prop_black_enrl_ap ~ prop_white, data = crdc_tidy_data_2)
summary(prop_AP_black_model)
#coef -0.022590
#p-value .4754 -- VERY NOT SIGNIFICANT


##CHARTER

prop_AP_black_charter_model = lm(formula = prop_black_enrl_ap ~ prop_white, data = charter_data)
summary(prop_AP_black_charter_model)
#coef -0.16026
#p-value 0.02826
#NOTE: proportion of black students enrolled in an AP according to white school population IS significant
#in *charters* and negative


##PUBLIC

prop_AP_black_trad_public_model = lm(formula = prop_black_enrl_ap ~ prop_white, data = trad_public_data)
summary(prop_AP_black_trad_public_model)
#coef 0.026323
#p-value 0.4472 -- VERY NOT SIGNIFICANT




# Prop White vs. Hispanic -------------------------------------------------

## Scatterplot:

#Linear
ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_hispanic_enrl_ap)) + 
  geom_point(aes(color = school_type)) +
  geom_smooth(aes(linetype = school_type), method = 'lm', se = FALSE) +
  xlim(0, 0.80) + labs(x = "Proportion White", y = "Proportion Hispanic Students in AP", title = "Hispanic") +
  ggsave("hipanic_ap.pdf")

ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_hispanic_enrl_ap)) + 
  geom_point(aes(color = school_type)) +
  geom_smooth(aes(linetype = school_type), method = 'lm', se = TRUE) +
  xlim(0, 0.80) + labs(x = "Proportion White", y = "Proportion Hispanic Students in AP", title = "Hispanic") +
  ggsave("hipanic_ap_se.png")





#Non-linear

ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_hispanic_enrl_ap)) + 
  geom_point(aes(color = school_type)) +
  geom_smooth(aes(linetype = school_type), se = TRUE) +
  xlim(0, 0.80) + labs(x = "Proportion White", y = "Proportion Hispanic Students in AP", title = "Hispanic") +
  ggsave("hisp_nonparam.png")


##ALL
prop_AP_hispanic_model = lm(formula = prop_hispanic_enrl_ap ~ prop_white, data = crdc_tidy_data_2)
summary(prop_AP_hispanic_model)
#coef -0.008078
#p-value 0.7872 -- VERY NOT SIGNIFICANT


##CHARTER
prop_AP_hispanic_charter_model = lm(formula = prop_hispanic_enrl_ap ~ prop_white, data = charter_data)
summary(prop_AP_hispanic_charter_model)
#coef -0.14265
#p-value 0.05368 -- SIGNIFICANT at .1 LEVEL


##PUBLIC
prop_AP_hispanic_trad_public_model = lm(formula = prop_hispanic_enrl_ap ~ prop_white, data = trad_public_data)
summary(prop_AP_hispanic_trad_public_model)
#coef 0.040377
#p-value 0.2014 -- NOT SIGNIFICANT


# Asian -------------------------------------------------------------------


#Linear:
ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_asian_enrl_ap)) + 
  geom_point(aes(color = school_type)) +
  geom_smooth(aes(linetype = school_type), method = 'lm', se = FALSE) +
  xlim(0, 0.80) + labs(x = "Proportion White", y = "Proportion Asian Students in AP", title = "Asian") +
  ggsave("asian_ap.pdf")


#Non_linear:

ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_asian_enrl_ap)) + 
  geom_point(aes(color = school_type)) +
  geom_smooth(aes(linetype = school_type), se = TRUE) +
  xlim(0, 0.80) + labs(x = "Proportion White", y = "Proportion Asian Students in AP", title = "Asian") +
  ggsave("asian_nonparam.png")
  

##CHARTER

prop_AP_asian_charter_model <- lm(formula = prop_asian_enrl_ap ~ prop_white, data = charter_data)
summary(prop_AP_asian_charter_model)


##PUBLIC

prop_AP_asian_trad_public_model = lm(formula = prop_asian_enrl_ap ~ prop_white, data = trad_public_data)
summary(prop_AP_asian_trad_public_model)











# Non-White Regression ----------------------------------------------------


crdc_tidy_data_2 <- crdc_tidy_data_2 %>%
  mutate(enrl_nonwhite = total_enrollment - white)

crdc_tidy_data_2 <- crdc_tidy_data_2 %>%
  mutate(enrl_ap_nonwhite = enrl_ap_black + enrl_ap_hispanic + 
  enrl_ap_asian + enrl_ap_ind_natv + enrl_ap_hinatv_islndr)

crdc_tidy_data_2 <- crdc_tidy_data_2 %>%
  mutate(prop_nonwhite_ap_enrl = enrl_ap_nonwhite / enrl_nonwhite)

crdc_tidy_data_2$school_type <- ifelse(crdc_tidy_data_2$charter == '1', "charter", "public")

##linear

ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_nonwhite_ap_enrl)) + 
  geom_point(aes(color = school_type)) +
  geom_smooth(aes(linetype = school_type), method = 'lm', se = FALSE) +
  xlim(0, 0.80) + labs(x = "Proportion White", y = "Proportion of Non-White Students in AP", title = "Non-White") +
  ggsave("non_white_ap.pdf")

ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_nonwhite_ap_enrl)) + 
  geom_point(aes(color = school_type)) +
  geom_smooth(aes(linetype = school_type), method = 'lm', se = TRUE) +
  xlim(0, 0.80) + labs(x = "Proportion White", y = "Proportion of Non-White Students in AP", title = "Non-White") +
  ggsave("non_white_ap_se.png")



##non-linear

ggplot(data = crdc_tidy_data_2, aes(x = prop_white, y = prop_nonwhite_ap_enrl)) + 
  geom_point(aes(color = school_type)) +
  geom_smooth(aes(linetype = school_type), se = TRUE) +
  xlim(0, 0.80) + labs(x = "Proportion White", y = "Proportion of Non-White Students in AP", title = "Non-White") +
  ggsave("nonwhite_nonparam.png")



## Charter

nonwhite_ap_charter_lm <- lm(formula = prop_nonwhite_ap_enrl ~ prop_white, data = charter_data)

summary(nonwhite_ap_charter_lm)


## Public

nonwhite_ap_public_lm <- lm(formula = prop_nonwhite_ap_enrl ~ prop_white, data = trad_public_data)

summary(nonwhite_ap_public_lm)














  