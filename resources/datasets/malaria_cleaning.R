# 1. SETUP ----
## Set Working Directory ----
getwd()
setwd("dataaware/resources/datasets")

## Load tidyverse ----
library(tidyverse)
library(janitor) # This helps with fixing column names
library(stringr)

## Read in data ----
data_wide <- read_csv("malaria_toclean.csv")

# 2. CLEANING ----
## Clean and pivot data ----
## Use `janitor` to make cleaning easier ----
data_wide <- data_wide %>%
  janitor::clean_names() %>% # convert column names to lowercase
  janitor::remove_empty() %>% # removes empty rows and columns
  dplyr::select(-c(indicator_code, indicator_name))

data_long <-
  data_wide %>% pivot_longer(cols = starts_with("x"), # select columns that start with "x"
                              names_to = "year", # the new column for year
                              values_to = "incidence") %>%  # the new column for incidence)
  dplyr::mutate(year = stringr::str_sub(year, start = 2)) %>% # drop the first character in the year col
  dplyr::filter(!is.na(incidence))


## Write to a csv file named "malaria_clean.csv"
write_csv(data_long, "malaria_clean.csv")
