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
