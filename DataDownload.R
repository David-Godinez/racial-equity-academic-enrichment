#General Data Download
library(tidyverse)
library(devtools)
library(educationdata)

#Note: in order to download education data, must complete the following code:
#install.packages('devtools')
#devtools::install_github('UrbanInstitute/education-data-package-r')
#I will need to run that line every time, David should only need to run it once

#Optional code to run for assistance:
#?get_education_data

#Example uses:
#school_districts_all <- get_education_data(level = 'school-districts')

#first successful pass at getting a data set through the educationdata package
testdf <- get_education_data(level = 'schools',
                             source = 'ccd',
                             topic = 'directory',
                             filters = list(year = 2015, #our focus year
                                            fips = '6', #This is CA, only used this to test the download in a small version
                                            urban_centric_locale = '11'), #code for "city, large"
                             add_labels = TRUE, 
                             csv = FALSE)

view(testdf)

#This gives us school-level data for California (fips 6) schools that are identified as "City, large" based on Urban's models
#Obviously, this is very limited, as it only provides us with CA's large city schools
#We could expand to include "City, medium" if we would like
#Going forward, we won't need to include the fips filter, but we will need more filters to make the download small enough
#We will need filters for the specific data that we want (racial breakdowns, AP/IB enrollment, suspension rates, etc.)

#progress towards downloading discipline data (not completed)
num_ISS <- get_education_data(level = 'schools',
                             source = 'crdc',
                             topic = 'students_susp_in_sch',
                             filters = list(year = '2015', #our focus year
                                            urban_centric_locale = list('11', '12'),
                                            by = list("race", "sex")
                             add_labels = TRUE, 
                             csv = FALSE)

discipline_test <- get_education_data(level = "schools",
+                                      source = "crdc",
+                                      topic = "discipline",
+                                      filters = list(year = '2015', urban_centric_locale = '11'),
+                                      by = c("disability", "race", "sex"))

#General Data Download
library(tidyverse)
library(devtools)
library(educationdata)

#Note: in order to download education data, must complete the following code:
#install.packages('devtools')
#devtools::install_github('UrbanInstitute/education-data-package-r')
#I will need to run that line every time, David should only need to run it once

#Optional code to run for assistance:
#?get_education_data

#Example uses:
#school_districts_all <- get_education_data(level = 'school-districts')

#first successful pass at getting a data set through the educationdata package
testdf <- get_education_data(
  level = 'schools',
  source = 'ccd',
  topic = 'directory',
  filters = list(
    year = 2015,
    #our focus year
    fips = '6',
    #This is CA, only used this to test the download in a small version
    urban_centric_locale = '11'
  ),
  #code for "city, large"
  add_labels = TRUE,
  csv = FALSE
)

view(testdf)

num_ISS <- get_education_data(
  level = 'schools',
  source = 'crdc',
  topic = 'students_susp_in_sch',
  filters = list(
    year = '2015',
    #our focus year
    urban_centric_locale = list('11', '12'),
    by = list("race", "sex"),
    add_labels = TRUE,
    csv = FALSE
  )
  
  discipline_JA_test <- get_education_data(
    level = 'schools',
    source = 'crdc',
    topic = 'discipline',
    filters = list(year = '2015', ncessch = '110003000453'),
    by = c('race', 'sex'),
    add_labels = TRUE,
    csv = FALSE
  )
  
  #sample that effectively pulls discipline records by race and sex for one school
  
  harass_JA_test <- get_education_data(
    level = 'schools',
    source = 'crdc',
    topic = 'harassment-or-bullying',
    filters = list(year = '2015', ncessch = '110003000453'),
    by = c('race', 'sex'),
    add_labels = TRUE,
    csv = FALSE)
  
  #sample that effectively pulls harassment and bullying records by race and sex for one school
  #I think a good next step will be to work more on the `ncessch` section to specify which schools we want to include in the data
  #I'm thinking that the general logic for how that would work is the following:
      # 1) filter the data to only include urban schools
      # 2) store that list of urban school ncessch values
      # 3) filter based on whether ncessch values are within our list of urban schools
      # would look something like filters = list(year = '2015', ncessch.in(urbanschoollist) = TRUE) 
      # ^not actual function that works, but that's the logic
                                
#Website I found with documentation for variables: https://educationdata.urban.org/documentation/schools.html?fbclid=IwAR2q--4bTAOsRGrO8JNdXToeLrD9mqmFCQ10gsiM34TSALPkcb97grn8JA4

#states (fips) that we are looking into, based on their policies of funding charter scools
focus_fips <- list('4','6','11','12', '13', '15', '21', '26', '29', '32', '37', '40', '47', '48', '53')
focus_fips_data <- get_education_data(level = 'schools', source = 'crdc', topic = 'discipline', filters = list(year = '2015', fips = focus_fips), by = c('disability', 'race', 'sex'), add_labels = TRUE, csv = FALSE)
