# Data Import and EDA
# 22 November 2019


# Preliminaries -----------------------------------------------------------

library(tidyverse)
library(educationdata)
library(devtools)


# Notes -------------------------------------------------------------------

##The Urban Institute API provides data from two separate sources: the CCD and
##the CRDC. Most of the variables we are interested in are in the CRDC data.
##However, the CCD has a variable, `urban_centric_locale`, that categorizes the
##schools based on their respective locale (i.e. "city, large" and "city,
##mediumm). The CRDC data does not have this variable, so we filtered the CCD
##data to focus on schools in large urban settings and used a filter join to
##match the school IDs (NCESSCH) in the CRDC to those in the CCD subset.


# Schools of Interest -----------------------------------------------------

##Includes states that fund charter schools with the same federal and state
##funding formula as public schools. Funding from local revenues is left
##unaccounted for:

focus_fips <- list('4', '5', '6', '10', '11', '12', '13', '15', '16', '18', '21', '23', '26', '29', '32', '37', '40', '45', '47', '45', '47', '48', '49', '53')





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


##Filtering join that matches the schools ID's in `crdc_schools` to those in `ccd_urban_schools`:

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

 


 
 





















