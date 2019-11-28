# Data Import and Wrangle


# Preliminaries -----------------------------------------------------------

library(tidyverse)
library(educationdata)
library(devtools)




# Research Question -------------------------------------------------------

##Are charter schools more equitable in the provision of educational
##opportunities to students of color than traditional public schools?



# Notes -------------------------------------------------------------------

##The Urban Institute API provides data from two separate sources: the CCD and
##the CRDC. Most of the variables we are interested in are in the CRDC data.
##However, the CCD has a variable, `urban_centric_locale`, that categorizes the
##schools based on their respective locale (i.e. "city, large" and "city,
##mediumm). We will use this variable to select our sample. The CRDC data does
##not have this variable, so we filtered the CCD data to focus on schools in
##large urban settings and used a filter join to match the school IDs (ncessch)
##in the CRDC df to those in the CCD subset.


# Schools of Interest -----------------------------------------------------

##Includes states that fund charter schools with the same federal and state
##funding formula as public schools. Funding from local revenues is left
##unaccounted for:

focus_fips <- list('4', '5', '6', '10', '11', '12', '13', '15', '16', '18', '21', 
                   '23', '26', '29', '32', '37', '40', '45', '47', '45', '47', '48', 
                   '49', '53')





##CCD data with `urban_centric_locale` set to "city, large":

ccd_urban_schools <- get_education_data(level = "schools",
                                        source = "ccd",
                                        topic = "directory",
                                        filters = list(year = 2015,
                                                       fips = focus_fips,
                                                       urban_centric_locale = '11'))

##CRDC data without the "city, large" locale:

crdc_schools <- get_education_data(level = "schools",
                                   source = "crdc",
                                   topic = "directory",
                                   filters = list(year = 2015,
                                                  fips = focus_fips))


##Filtering join that matches the schools ID's in `crdc_schools` to those in
##`ccd_urban_schools`:

crdc_urban_schools <- crdc_schools %>%
  filter(ncessch %in% ccd_urban_schools$ncessch)

##Schools without matches:

crdc_schools %>%
  anti_join(ccd_urban_schools, by = 'ncessch') %>%
  count(ncessch, sort = TRUE)


##Drops grades below ninth:

crdc_urban_schools <- crdc_urban_schools %>%
  filter(g9 == '1', g10 == '1', g11 == '1', g12 == '1') %>%
  select(-c(prek, k, g1, g2, g3, g4, g5, g6, g7, g8, ug))


##Drops magnet and alternative schools:

crdc_urban_schools <- crdc_urban_schools %>%
  filter(magnet_crdc == '0', alt_school == '0')


 
##Out of the 1070 schools, 726 are public and 344 are charter.

table(crdc_urban_schools$charter_crdc)



# Enrollment Import & Wrangle ------------------------------------------------

#Enrollment data import:
 
crdc_enrollment <- get_education_data(level = 'schools',
                                      source = 'crdc',
                                      topic = 'enrollment',
                                      filters = list(year  = 2015,
                                                     fips = focus_fips),
                                      by = list('race', 'sex'))
                                      



#Gets total race enrollment (both male and female) and spreads using `race` as
#key and `enrollment_crdc` as value:

crdc_enrollment <- crdc_enrollment %>%
  filter(race != '99' & sex == '99') %>%
  spread(key = race, value = enrollment_crdc)
  
  

#Renames race columns:

crdc_enrollment <- rename(crdc_enrollment,
                          white = '1',
                          black = '2',
                          hispanic = '3',
                          asian = '4',
                          amindian_alnative = '5',
                          hi_native_islander = '6',
                          two_or_more = '7')



#Removes unnecessary columns and adds `total_enrollment` variable.

crdc_enrollment <- crdc_enrollment %>%
  select(-c(sex, disability, lep)) %>%
  mutate(total_enrollment = white + black + hispanic + asian + amindian_alnative + hi_native_islander + two_or_more)



#Filter join that matches to ncessch values in our sample:

crdc_enrollment <- crdc_enrollment %>%
  filter(ncessch %in% crdc_urban_schools$ncessch)


#Mutating join that adds school names; also adds `charter` binary variable that
#returns `1` if the school is charter, and `0` if it is public:

crdc_enrollment <- crdc_enrollment %>%
  mutate(charter = crdc_urban_schools$charter_crdc[match(ncessch, crdc_urban_schools$ncessch)]) %>%
  mutate(school_name = crdc_urban_schools$school_name_crdc[match(ncessch, crdc_urban_schools$ncessch)])
  

#Rearranges columns:

crdc_enrollment <- crdc_enrollment[c("crdc_id", "year", "fips", "school_name", "ncessch", "leaid", 
                                     "charter", "white", "black", "hispanic", "asian", "amindian_alnative", 
                                     "hi_native_islander", "two_or_more", "total_enrollment")]




## `crdc_enrollment` is now ready for join w/ 'ap_ib_enrollment':

view(crdc_enrollment)




# AP Enrollment Import and Wrangle ----------------------------------------


#AP/IB enrollment data import:

ap_ib_enrollment <- get_education_data(level = "schools",
                           source = "crdc",
                           topic = "ap-ib-enrollment",
                           filters = list(year = 2015,
                                          fips = focus_fips),
                           by = list("race", "sex")) 
 
 
#Creates separate df that only looks at `enrl_AP` to allow for spreading of `race` column:

enrl_in_AP <- ap_ib_enrollment %>%
  select(-c(enrl_AP_math, enrl_AP_science, enrl_AP_other, enrl_IB, enrl_AP_language, enrl_gifted_talented)) %>%
  filter(race != '99' & sex == '99') %>%
  spread(key = race, value = enrl_AP)

#Matches to focus ncessch:

enrl_in_AP <- enrl_in_AP %>%
  filter(ncessch %in% crdc_enrollment$ncessch)

#Renames race columns:

enrl_in_AP <- rename(enrl_in_AP,
                     enrl_ap_white = '1',
                     enrl_ap_black = '2',
                     enrl_ap_hispanic = '3',
                     enrl_ap_asian = '4',
                     enrl_ap_ind_natv = '5',
                     enrl_ap_hinatv_islndr = '6',
                     enrl_ap_two_or_more = '7')


#Joins `enrl_ap` columns to `crdc`_enrollment:

crdc_enrollment <- crdc_enrollment %>%
  inner_join(enrl_in_AP, by = "ncessch")


#Removes duplicate variables from inner join:

crdc_enrollment <- crdc_enrollment %>%
  select(-c("crdc_id.y", "year.y", "fips.y", "leaid.y")) %>%
  rename(crdc_id = "crdc_id.x",
         year = "year.x",
         fips = "fips.x",
         leaid = "leaid.x")

crdc_enrollment <- crdc_enrollment %>%
  select(-c("sex", "disability", "lep"))




# IB Enrollment Wrangle ---------------------------------------------------


enrl_in_ib <- ap_ib_enrollment %>%
  select(-c(enrl_AP, enrl_AP_math, enrl_AP_science, enrl_AP_other, enrl_AP_language, enrl_gifted_talented)) %>%
  filter(race != '99' & sex == '99') %>%
  spread(key = race, value = enrl_IB)


enrl_in_ib <- rename(enrl_in_ib,
                     enrl_ib_white = '1',
                     enrl_ib_black = '2',
                     enrl_ib_hispanic = '3',
                     enrl_ib_asian = '4',
                     enrl_ib_ind_natv = '5',
                     enrl_ib_hi_natv_islndr = '6',
                     enrl_ib_two_or_more = '7')


enrl_in_ib <- enrl_in_ib %>%
  filter(ncessch %in% crdc_enrollment$ncessch)



crdc_enrollment <- crdc_enrollment %>%
  inner_join(enrl_in_ib, by = "ncessch") %>%
  select(-c("crdc_id.y", "year.y", "fips.y", "leaid.y", "sex", "disability", "lep")) %>%
  rename(crdc_id = "crdc_id.x",
         year = "year.x",
         fips = "fips.x",
         leaid = "leaid.x")



# Gifted and Talented Enrollment Wrangle ----------------------------------

enrl_in_gt <- ap_ib_enrollment %>%
  select(-c(enrl_AP, enrl_IB, enrl_AP_math, enrl_AP_science, enrl_AP_other, enrl_AP_language)) %>%
  filter(race != '99' & sex == '99') %>%
  spread(key = race, value = enrl_gifted_talented)


enrl_in_gt <- rename(enrl_in_gt,
                     enrl_gt_white = '1',
                     enrl_gt_black = '2',
                     enrl_gt_hispanic = '3',
                     enrl_gt_asian = '4',
                     enrl_gt_ind_natv = '5',
                     enrl_gt_hi_natv_islndr = '6',
                     enrl_gt_two_or_more = '7')


enrl_in_gt <- enrl_in_gt %>%
  filter(ncessch %in% crdc_enrollment$ncessch)


crdc_enrollment <- crdc_enrollment %>%
  inner_join(enrl_in_gt, by = "ncessch") %>%
  select(-c("crdc_id.y", "year.y", "fips.y", "leaid.y", "sex", "disability", "lep")) %>%
  rename(crdc_id = "crdc_id.x",
         year = "year.x",
         fips = "fips.x",
         leaid = "leaid.x")




# Export and Notes --------------------------------------------------------

write.csv(crdc_enrollment, file = "crdc_tidy_data.csv")
