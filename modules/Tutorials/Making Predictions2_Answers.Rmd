---
title: "Making Predictions - Answers!"
author: "Abhishek Bhatia"
date: "2023-07-27"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Hospital ICU dataset
Today, we will be building a model to predict hospital death based on data from an intensive care unit (ICU). Predicting patient death in the ICU is extremely important because determining which patients needs attention immediately can help to prioritize care in a way that prevents as many deaths as possible. 

## Load the `tidyverse` library
```{r}
# Load the tidyverse library
library(tidyverse)

```


## Read in in the dataset
The hospital dataset is uploaded to Github, and can be found at https://raw.githubusercontent.com/e-cui/ENABLE-HiDAV-Online-Modules/master/Data%20Mining%20Modules/csv_files/t.csv

1. Assign the url (in quotations, because it is a string) to an object called `urlfile`. 
2. Next, use the `read_csv()` function to read in the csv. Within `read_csv()`, you can specify urls as `read_csv(url(...))`. Read in the csv, and name that dataset
3. Use `head()` to peek at the data

```{r}
#The hospital dataset is uploaded to Github, and can be found at https://raw.githubusercontent.com/e-cui/ENABLE-HiDAV-Online-Modules/master/Data%20Mining%20Modules/csv_files/t.csv

#1. Assign the url (in quotations, because it is a string) to an object called `urlfile`. 
#2. Next, use the `read_csv()` function to read in the csv. Within `read_csv()`, you can specify urls as `read_csv(url(...))`. Read in the csv, and name that dataset
#3. Use `head()` to peek at the data

urlfile <- "https://raw.githubusercontent.com/e-cui/ENABLE-HiDAV-Online-Modules/master/Data%20Mining%20Modules/csv_files/t.csv"
df <- read_csv(url(urlfile))

head(df)
```






## Cleaning the data

We will need to change the variable types, since CSV files don't tell you what type of variable is contained in the data.

Next, convert the following variables to a factor, using `mutate()` along with `as.factor`:
- hospital_death
- sepsis
- cardiovascular_diagnosis
- intubated_apache
- gcs_eyes_apache
- gcs_motor_apache

Also, convert the following variables to numeric:
- temp_apache
- map_apache
- h1_heartrate_max
- d1_resprate_max
- d1_potassium_max
- d1_creatinine_max
- d1_hematocrit_max
- sodium_apache
- wbc_apache
- age
- pre_icu_los_days
- bmi


```{r}
df <- df %>%
  mutate(hospital_death = as.factor(hospital_death)) %>%
  mutate(sepsis = as.factor(sepsis)) %>%
  mutate(cardiovascular_diagnosis = as.factor(cardiovascular_diagnosis)) %>%
  mutate(intubated_apache = as.factor(intubated_apache)) %>%
  mutate(gcs_eyes_apache = as.factor(gcs_eyes_apache)) %>%
  mutate(gcs_motor_apache = as.factor(gcs_motor_apache)) %>%
  mutate(temp_apache = as.numeric(temp_apache)) %>%
  mutate(map_apache = as.numeric(map_apache)) %>%
  mutate(h1_heartrate_max = as.numeric(h1_heartrate_max)) %>%
  mutate(d1_resprate_max = as.numeric(d1_resprate_max)) %>%
  mutate(d1_potassium_max = as.numeric(d1_potassium_max)) %>%
  mutate(d1_creatinine_max = as.numeric(d1_creatinine_max)) %>%
  mutate(d1_hematocrit_max = as.numeric(d1_hematocrit_max)) %>%
  mutate(sodium_apache = as.numeric(sodium_apache)) %>%
  mutate(wbc_apache = as.numeric(wbc_apache)) %>%
  mutate(age = as.numeric(age)) %>%
  mutate(pre_icu_los_days = as.numeric(pre_icu_los_days)) %>%
  mutate(bmi = as.numeric(bmi))

```


## Split data into training and testing datasets
- Splitting the data in this manner is important because the model must be tested on data that it has never seen before. 
- When splitting the data the training set should be larger than the testing to allow for more accurate predictions.

### 1. Set a seed
When you generate “random numbers” in R, you are actually generating pseudorandom numbers. These numbers are generated with an algorithm that requires a seed to initialize. Being pseudorandom instead of pure random means that, if you know the seed and the generator, you can predict (and reproduce) the output. In this tutorial you will learn the meaning of setting a seed, what does set.seed do in R, how does set.seed work, how to set or unset a seed, and hence, how to make reproducible outputs.


```{r}
# use set.seed() and set any random number as your see
set.seed(666)
```

### 2. Split the dataset
We will separate the data into 80:20, i.e. 80% of the data will be used to train the model, and 20% will be used to test it.

```{r}
# First, create a new column called "id" that corresponds to the row number. To do this, (assuming your dataset is called df), we can write "df$id <- 1:nrow(df)". This means, create a new id column in the dataset "df", starting from 1, till the number of rows in the dataframe df. Replicate this to create an id column for your datast
df$id <- 1:nrow(df)
```


Next, we split the dataset. To do this, we will "randomly sample" 80% of the dataset, using `dplyr`, and assign the two datasets as "train" and test". An example of how you do this is:

```
train <- df %>% dplyr::sample_frac(0.70)
test  <- dplyr::anti_join(df, train, by = 'id')
```
"Anti_join" tells R to only keep all of the rows in the dataset "df", that you did not sample in the "train" dataset, and it can figure this out by looking at the id numbers of the rows that you samples in "train". Replicate this for your dataset, with the correct sample fraction of 80%. 

```{r}
# Split the dataset into train and test
train <- df %>% dplyr::sample_frac(0.70)
test  <- dplyr::anti_join(df, train, by = 'id')

```

For a random forest model, we also want to separate out all the x variables from the y variable in both the training and testing data. It requires the y variable to be a vector, and you can convert a dataframe to a vector using the `unlist()` function. Follow the steps below:

1. Create a dataframe `train_x` which is a subset of the `train` dataset, with all the columns except for `hospital death`. Do the same for the test dataset to create `test_x`

2. Also create a dataframe `train_y` with only the `hospital_death` variable. Do the same for the test dataset to create `test_y` 

3. Convert the train and test `y` dataframes to a vector using `unlist()`. 

```{r}
# Train_x and test_x
train_x <- train %>% select(-c("hospital_death", "id"))
test_x <- test %>% select(-c("hospital_death", "id"))

# Train_y and test_y
train_y <- train %>% select(c("hospital_death"))
test_y <- test %>% select(c("hospital_death"))

# Convert train_y and test_y to a vector
train_y <- unlist(train_y)
test_y <- unlist(test_y)

```


## Random Forest Model

### 1. Train a simple model 

Fit a randomforest model called `m1` that predicts hospital death.
Reminder, we use the `lm()` function to fit linear regression models, and `glm()` function to fit logistic regression models.

```{r}
# load the randomForest library
library(randomForest)
```

```{r}
# fit a simple model with x = train_x, y = train_y, xtest = test_x, ytest = test_y, importance = TRUE, and ntree = 5000

rf_model <- randomForest(
  x = train_x,
  y = train_y,
  xtest = test_x,
  ytest = test_y,
  importance = TRUE,
  ntree = 5000
)

```



### 2. Model Tuning

There are a few "hyperparameters" to tune, like the number of variables that each tree should consider during the learning process, which is called `mtry`. We can tune the model using the `tuneRF()` function in the `randomForest` package. 

```{r}
# find the best value for the mtry hyperparameter. Set the x, y, xtest, ytest as before. Set the ntreeTry value to 500 (it will build 500 trees per try), stepFactor to 1.5, improve = 0.01, trace = TRUE, and plot = TRUE 
mtry <- tuneRF(
  x = train_x,
  y = train_y,
  xtest = test_x,
  ytest = test_y,
  ntreeTry = 5000,
  stepFactor = 1.5,
  improve = 0.01,
  trace = TRUE,
  plot = TRUE
)

# The code below will save the best value for the mtry and print it out
best.m <- mtry[mtry[, 2] == min(mtry[, 2]), 1]
print(mtry)
print(best.m)

```

We can also tune the number of trees itself. The random forest model you fit earlier, rf_model should have an error rate associated with a certain number of trees after which the error stabilizes for some time. The code below will find the iteration with the lowest error rate, and save it as `best_nrounds`. 
```{r}
rf_res_df <-
  data.frame(
    TRAINING_ERROR = rf_model$err.rate[,1],
    ITERATION = c(1:5000)
  ) %>%
  mutate(MIN = TRAINING_ERROR == min(TRAINING_ERROR))

best_nrounds <- rf_res_df %>%
  filter(MIN) %>%
  pull(ITERATION)

best_nrounds
```


Finally, fit your final model using the best `mtry` and `ntree` value you found

```{r}
rf_final_model <-
  randomForest(
    x = train_x,
    y = train_y,
    mtry = 6,
    importance = TRUE,
    ntree = 3000
  )

rf_final_model
```

## Feature Importance

A cool feature of random forests is that they are explainable, and it is easy to figure out what variables were the most informative for prediction.

Use the `varImp()` function to extract the variable importance from `rf_final_ model`. The code below will save it as a dataframe for plotting

```{r}
library(caret)
rf_features <- as.data.frame(varImp( rf_final_model))
```

The features extracted have a weird format (take a peek at the dataframe to see it) and so the few lines of code below make it plottable.
```{r}
## Rename the column name to rf_imp
colnames(rf_features) <- "rf_imp"

## convert rownames to column
rf_features$feature <- rownames(rf_features)

## Selecting only relevant columns for mapping
features <- rf_features %>% dplyr::select(c(feature, rf_imp))
```


Now, use `ggplot` to plot the variable importance in the `features` dataframe
The rf_imp should be on the x axis, feature should be on the y axis.
Use geom_point
```{r}
### Plot the feature importance
plot <- features %>%
  ggplot(aes(x =  rf_imp, y = feature , color = "#2E86AB")) +
  # Creates a point for the feature importance
  geom_point(position = position_dodge(0.5)) 

print(plot)
```

You can make this a little better with some ggplot arguments. 
```{r}
plot +
  # Connecting line between 0 and the feature
  geom_linerange(aes(xmin = 0, xmax = rf_imp),
                 linetype = "solid",
                 position = position_dodge(.5)) +
  # Vertical line at 0
  geom_vline(xintercept = 0,
             linetype = "solid",
             color = "grey70") +
  # Adjust the scale if you need to based on your importance
  scale_x_continuous(limits = c(-1, 5)) +
  # Label the x and y axes
  labs(x = "Importance", y = "Feature") +
  # Make the theme pretty
  theme_bw() +
  theme(legend.position = "none",
        text = element_text(family = "serif")) +
  guides(color = guide_legend(title = NULL)) +
  # Plot them in order of importance
  scale_y_discrete(limits = features$feature[order(features$rf_imp, decreasing = FALSE)])
```

