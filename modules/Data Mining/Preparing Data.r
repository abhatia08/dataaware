# This is an example of a code cell
print('Congratulations!')
print('You\'ve run your first code cell.')

options(readr.show_col_types=FALSE) 

#install and load packages required to read in the CSV file 
library (readr)
library (rlang)

#location of raw csv file on github repository 
urlfile="https://raw.githubusercontent.com/e-cui/ENABLE-HiDAV-Online-Modules/master/Data%20Mining%20Modules/csv_files/training_v2.csv"

#Read the CSV file into a data frame called training_v2 
training_v2<-read_csv(url(urlfile))


#print
print("CSV file loaded successfully")

#select variable columns from the training_v2 data frame into a new data frame called practice_csv
library(dplyr)
practice_csv = select(training_v2, 4, 43, 36, 79, 61, 42, 123, 107, 115, 46, 28, 29, 5, 16, 6, 35, 20)
 
#create sepsis and cardiovascular diagnosis columns from the diagnosis column
practice_csv<- mutate(practice_csv, sepsis = ifelse(apache_2_diagnosis == '113', '1', '0'))
practice_csv<- mutate(practice_csv, cardiovascular_diagnosis = ifelse(apache_2_diagnosis == '114', '1', '0'))

#delete original diagnosis column
practice_csv = select(practice_csv, -17)

#print
print("variables selected, sepsis and cardiovascular diagnosis columns added, diagnosis column deleted")

#change categorical variables to factor data type 
practice_csv$hospital_death<- as.factor(practice_csv$hospital_death)
practice_csv$sepsis<- as.factor(practice_csv$sepsis)
practice_csv$cardiovascular_diagnosis<- as.factor(practice_csv$cardiovascular_diagnosis)
practice_csv$intubated_apache<- as.factor(practice_csv$intubated_apache)
practice_csv$gcs_eyes_apache<- as.factor(practice_csv$gcs_eyes_apache)
practice_csv$gcs_motor_apache<- as.factor(practice_csv$gcs_motor_apache)

#change to numeric variables to numeric data type 
practice_csv$temp_apache<- as.numeric(practice_csv$temp_apache)
practice_csv$map_apache<- as.numeric(practice_csv$map_apache)
practice_csv$h1_heartrate_max<- as.numeric(practice_csv$h1_heartrate_max)
practice_csv$d1_resprate_max<- as.numeric(practice_csv$d1_resprate_max)
practice_csv$d1_potassium_max<- as.numeric(practice_csv$d1_potassium_max)
practice_csv$d1_creatinine_max<- as.numeric(practice_csv$d1_creatinine_max)
practice_csv$d1_hematocrit_max<- as.numeric(practice_csv$d1_hematocrit_max)
practice_csv$sodium_apache<- as.numeric(practice_csv$sodium_apache)
practice_csv$wbc_apache<- as.numeric(practice_csv$wbc_apache)
practice_csv$age<- as.numeric(practice_csv$age)
practice_csv$pre_icu_los_days<- as.numeric(practice_csv$pre_icu_los_days)
practice_csv$bmi<- as.numeric(practice_csv$bmi)

#check all variable data types to make sure they are correct
str(practice_csv)

#replace some numeric variable nulls with the column mean 
practice_csv = transform(practice_csv, bmi = ifelse(is.na(bmi), mean(bmi, na.rm=TRUE), bmi))
practice_csv = transform(practice_csv, temp_apache = ifelse(is.na(temp_apache), mean(temp_apache, na.rm=TRUE), temp_apache))
practice_csv = transform(practice_csv, map_apache = ifelse(is.na(map_apache), mean(map_apache, na.rm=TRUE), map_apache))
practice_csv = transform(practice_csv, h1_heartrate_max = ifelse(is.na(h1_heartrate_max), mean(h1_heartrate_max, na.rm=TRUE), h1_heartrate_max))
practice_csv = transform(practice_csv, d1_resprate_max = ifelse(is.na(d1_resprate_max), mean(d1_resprate_max, na.rm=TRUE), d1_resprate_max))
practice_csv = transform(practice_csv, d1_potassium_max = ifelse(is.na(d1_potassium_max), mean(d1_potassium_max, na.rm=TRUE), d1_potassium_max))
practice_csv = transform(practice_csv, d1_creatinine_max = ifelse(is.na(d1_creatinine_max), mean(d1_creatinine_max, na.rm=TRUE), d1_creatinine_max))
practice_csv = transform(practice_csv, d1_hematocrit_max = ifelse(is.na(d1_hematocrit_max), mean(d1_hematocrit_max, na.rm=TRUE), d1_hematocrit_max))
practice_csv = transform(practice_csv, sodium_apache = ifelse(is.na(sodium_apache), mean(sodium_apache, na.rm=TRUE), sodium_apache))
practice_csv = transform(practice_csv, wbc_apache = ifelse(is.na(wbc_apache), mean(wbc_apache, na.rm=TRUE), wbc_apache))
practice_csv = transform(practice_csv, pre_icu_los_days = ifelse(is.na(pre_icu_los_days), mean(pre_icu_los_days, na.rm=TRUE), pre_icu_los_days))
practice_csv = transform(practice_csv, age = ifelse(is.na(age), mean(age, na.rm=TRUE), age))


#replace some categorical variable nulls with 0 (0 is the mode for these columns)
#gcs_motor_apache nulls replaced with a 1 (1 is the mode for this column) 
practice_csv$sepsis[is.na(practice_csv$sepsis)] <- 0
practice_csv$cardiovascular_diagnosis[is.na(practice_csv$cardiovascular_diagnosis)] <- 0
practice_csv$gcs_motor_apache[is.na(practice_csv$gcs_motor_apache)] <- 1
practice_csv$gcs_eyes_apache[is.na(practice_csv$gcs_eyes_apache)] <- 1

#print
print("Numeric nulls replaced with column mean, categorical nulls replaced with 0 or 1")

#use a random forest algorithm to replace the remaining nulls
#random forest imputation works for replacing both categorical and numeric variables
#ntree is the number of trees, maxiter is the maximum number of iterations (repeats) 
#more trees and more iterations can increase accuracy but takes more time to run
library(missForest)
library(randomForest)
set.seed(96) 
practice_csv.imp <- missForest(practice_csv, verbose = TRUE, maxiter = 2, ntree = 10)

#check imputed values
practice_csv.imp$ximp

#assign imputed data frame to a new data frame called t
t<- practice_csv.imp$ximp

#this code writes a CSV file of the dataframe to a specified file path location 
write.csv(dataframe,"file_path", row.names = FALSE)


