#General Data Download

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

#Website I found with documentation for variables: https://educationdata.urban.org/documentation/schools.html?fbclid=IwAR2q--4bTAOsRGrO8JNdXToeLrD9mqmFCQ10gsiM34TSALPkcb97grn8JA4
