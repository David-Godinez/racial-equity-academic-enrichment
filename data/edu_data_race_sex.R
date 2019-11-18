# Data downloadds from the CRDC source.



# Preliminaries -----------------------------------------------------------


library(devtools)

library(educationdata)



# CRDC Directory Data -----------------------------------------------------

## Contains school level geographic information, grades offered, and school type
## (magnet, charter, etc.).


crdc_directory <- get_education_data(level = "schools",
                                     source = "crdc",
                                     topic = "directory",
                                     filters = list(year = 2015))
 

# CRDC Enrollment ---------------------------------------------------------


## Enrollment by race and sex:

enrollment_race_sex <- get_education_data(level = "schools",
                                      source = "crdc",
                                      topic = "enrollment",
                                      filters = list(year = 2015),
                                      by = list("race", "sex"))



# CRDC Absenteeism --------------------------------------------------------

# Absenteeism by race and sex:

absent_race_sex <- get_education_data(level = "schools",
                                      source = "crdc",
                                      topic = "chronic-absenteeism",
                                      filters = list(year = 2015),
                                      by = list("race", "sex"))


# CRDC AP/IB Enrollment----------------------------------------------------

ap_ib_enrollment <- get_education_data(level = "schools",
                                       source = "crdc",
                                       topic = "ap-ib-enrollment",
                                       filters = list(year = 2015),
                                       by = list("race", "sex"))



# CRDC AP Performance --------------------------------------------------

ap_performance <- get_education_data(level = "schools",
                                     source = "crdc",
                                     topic = "ap-exams",
                                     filters = list(year = 2015),
                                     by = list("race", "sex"))



# Notes -------------------------------------------------------------------

## Contains the enrollment, assessment, and absenteeism data. However, it only
## groups by race and sex for each topic. The API does not allow for further
## grouping within the same data set. The best practice moving forward would be
## to perform the joins necesary to have all of assessment/abseenteeism and
## discipline data with all of the groups of interest in one definitive df. This
## would make our analysis much easier.

