# Sample of Schools


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





# Issue -------------------------------------------------------------------

##Up to this point, the `crdc_urban_schools` subset contains the sample of
##schools we are interested in. Data on enrollemnt, discipline, student
##assessments, etc., is available in the Urban Institute API, though we have to
##import it in different data sets. However, we cannot retreive this data
##because `get_education_data()` only allows for one ncessch number at a time. We
##are trying to pull data on over a thousand ncessch numbers. Below is an
##example of an unsuccessful attempt at retreiving enrollment data for our
##sample of 1070 schools:


# sample <- crdc_urban_schools$ncessch

# get_education_data(level = "schools",
#                   source = "crdc",
#                   topic = "enrollment",
#                   filters = list(year = 2015,
#                                  fips = focus_fips,
#                                  ncessch = sample),
#                   by = list("race", "sex"))



##This returns an error pertaining to how we used the `ncessch` filter. The
##problem seems to be that the API was designed to allow users to pull data on
##one school at a time. I used one ncessch number and it returned a df of
##24 observations and 10 variables. I don't think there is any practical way of
##using it to get data on 1070 different schools in one df.

##I believe the best solution to this would be to limit our observations to one
##state, or at the very least a few number of states, to make the data import
##process much more manageable. Even then, I am unsure if this would limit the
##validity of our results.


#Additions from my code -JH
focus_fips_discipline <- get_education_data(level = 'schools', 
                                      source = 'crdc', 
                                      topic = 'discipline', 
                                      filters = list(year = '2015', 
                                                     fips = focus_fips), 
                                      by = c('disability', 'race', 'sex'), 
                                      add_labels = TRUE, 
                                      csv = FALSE)

focus_nces_discipline <- focus_fips_discipline %>% filter(ncessch == focus_ncessch)

write.csv(focus2, "C:/Users/jh3873a/Desktop//FocusNCES_Discipline.csv", row.names = FALSE)

#^this is going to take a *long* time, but I'm letting it run and it should proceed 
# to downloading a .csv file when it completes, so it shouldn't need to be "babysat."

#^this is only for discipline
#Below: code that should work, but will need some time to run
#I typed these out as general plans, but can't test them because the download is currently going
#Feel free to modify the path to try downloading .csv files to your desktop, then upload 
#to github when you have the chance:

#--------- Harassment and Bullying --------------
focus_fips_HB <- get_education_data(level = 'schools', 
                                      source = 'crdc', 
                                      topic = 'harassment and bullying', #I'm not sure if this is the topic title 
                                      filters = list(year = '2015', 
                                                     fips = focus_fips), 
                                      by = c('disability', 'race', 'sex'), #not sure if these are the endpoints
                                      add_labels = TRUE, 
                                      csv = FALSE)

focus_nces_HB <- focus_fips_HB %>% filter(ncessch == focus_ncessch)

write.csv(focus_nces_HB, "C:/Users/jh3873a/Desktop//FocusNCES_HB.csv", row.names = FALSE)

#--------- Restraint and Seclusion ----------------
focus_fips_RS <- get_education_data(level = 'schools', 
                                      source = 'crdc', 
                                      topic = 'restraint and seclusion', #I'm not sure if this is the topic title 
                                      filters = list(year = '2015', 
                                                     fips = focus_fips), 
                                      by = c('disability', 'race', 'sex'), #not sure if these are the endpoints
                                      add_labels = TRUE, 
                                      csv = FALSE)

focus_nces_RS <- focus_fips_RS %>% filter(ncessch == focus_ncessch)

write.csv(focus_nces_RS, "C:/Users/jh3873a/Desktop//FocusNCES_RS.csv", row.names = FALSE)

#--------- Chronic Absenteeism ----------
focus_fips_CA <- get_education_data(level = 'schools', 
                                      source = 'crdc', 
                                      topic = 'Chronic Absenteeism', #I'm not sure if this is the topic title 
                                      filters = list(year = '2015', 
                                                     fips = focus_fips), 
                                      by = c('disability', 'race', 'sex'), #not sure if these are the endpoints
                                      add_labels = TRUE, 
                                      csv = FALSE)

focus_nces_CA <- focus_fips_CA %>% filter(ncessch == focus_ncessch)

write.csv(focus_nces_CA, "C:/Users/jh3873a/Desktop//FocusNCES_RS.csv", row.names = FALSE)

#--------- AP Exams ----------
focus_fips_CA <- get_education_data(level = 'schools', 
                                      source = 'crdc', 
                                      topic = 'ap exams', #I'm not sure if this is the topic title 
                                      filters = list(year = '2015', 
                                                     fips = focus_fips), 
                                      by = c('disability', 'race', 'sex'), #not sure if these are the endpoints
                                      add_labels = TRUE, 
                                      csv = FALSE)

focus_nces_AP <- focus_fips_AP %>% filter(ncessch == focus_ncessch)

write.csv(focus_nces_AP, "C:/Users/jh3873a/Desktop//FocusNCES_RS.csv", row.names = FALSE)
 





















