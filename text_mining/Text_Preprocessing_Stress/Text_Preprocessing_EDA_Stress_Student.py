
# -*- coding: utf-8 -*-
"""
Fill in the code
Text Preprocessing and Exploratory Analysis of Human Stress Dataset
(Student Version)

Created on Sat Jul  1 19:09:56 2023

@author: User
"""
#%% Import python modules and packages 

# Tools to create a data frame(table)
import pandas as pd
from pandas import DataFrame

# Tools for text preprocessing
import nltk
import re

# Tools to remove stopwords
from nltk.corpus import stopwords

# Tools for tokenizing
from nltk.tokenize.toktok import ToktokTokenizer

# Tools for lemmatization
from nltk.stem import WordNetLemmatizer
nltk.download('stopwords')
nltk.download('punkt')
nltk.download('wordnet')

#Package to help us expand contractions
import contractions

# Tools for plotting
import matplotlib.pyplot as plt

# Tools for doing word frequencies
from nltk.util import ngrams


#%% Read in a csv file 



#%% Drop any columns you don't want 
# We will keep all the rows
# We will keep columns the first 5 columns 



#%% How does our new dataset look like?



#%% Defining a function to remove special characters




#%% Defining a function to remove stopwords


#%% Defining a function to perform stemming


#%% Defining a function to perform lemmatization



#%% This function takes all the previous preprocessing functions and combines them



#%% Normalize the text data and add a new column on the csv file of the preprocessed text

data['normalized_text'] = normalize_corpus(data['text'])

#%% Let's see how our dataset looks like 



#%% Save the new csv file 
# Completed with the first step of Text Preprocessing 



#%% Exploratory Data Analysis 
# zero (0) means no stress, one (1) means stress
# we will group the subredits based on stress and no stress 
# Enter the column name that we are interested grouping in

groups = data.groupby('ENTER THE COLUMN NAME').agg({'ENTER THE COLUMN NAME':'count'})
groups

#%% Creating a bar graph

bars = plt.bar(range(2),groups.label,color=('b','r'))
# Add labels and title
plt.xlabel('ENTER LABEL FOR X ')
plt.ylabel('ENTER LABEL FOR Y')
plt.title('ENTER TITLE')


plt.xticks([0,1])

plt.show()

#%% Creating bigrams and calculating the word frequency
stressed_word=[]
for words in data[data.label == 1].normalized_text:
    tokens = tokenizer.tokenize(words)
    for token in tokens:
        stressed_word.append(token)
stressed_bigrams_series = (pd.Series(nltk.ngrams(stressed_word, 2)).value_counts())[:20]

#%% Creating a plot of the number of bigrams for all the stressed subredits
stressed_bigrams_series.sort_values().plot.barh(color='blue', width=.9, figsize=(12, 8))
plt.title('20 Most Frequently Occuring Bigrams')
plt.ylabel('Bigram')
plt.xlabel('# of Occurances')

#%% #%% Creating a plot of the number of bigrams for all the non-stressed subredits

non_stressed_word=[]
for words in data[data.label == 0].normalized_text:
    tokens = tokenizer.tokenize(words)
    for token in tokens:
        non_stressed_word.append(token)
non_stressed_bigrams_series = (pd.Series(nltk.ngrams(non_stressed_word, 2)).value_counts())[:20]
non_stressed_bigrams_series.sort_values().plot.barh(color='blue', width=.9, figsize=(12, 8))
plt.title('20 Most Frequently Occuring Bigrams')
plt.ylabel('Bigram')
plt.xlabel('# of Occurances')
