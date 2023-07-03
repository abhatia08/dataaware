# -*- coding: utf-8 -*-
"""
Fill in the code 
Text Preprocessing and Exploratory Analysis of Women's Clothing Revews Dataset
(Student Version)

Created on Sat Jul  1 23:30:37 2023

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


#%% Defining a function to remove special characters



#%% Defining a function to remove stopwords


#%% Defining a function to perform stemming


#%% Defining a function to perform lemmatization



#%% This function takes all the previous preprocessing functions and combines them

def normalize_corpus(corpus, text_lower_case=True, 
                     text_lemmatization=True, special_char_removal=True, 
                     stopword_removal=True, remove_digits=True):
    
    normalized_corpus = []
    # normalize each document in the corpus
    for doc in corpus:
        # lowercase the text
        if text_lower_case:
            doc = str(doc)
            doc = doc.lower()
        doc = contractions.fix(doc)  #Make contractions into full form
        # remove extra newlines
        doc = re.sub(r'[\r|\n|\r\n]+', ' ',doc)
        # lemmatize text
        if text_lemmatization:
            doc = lemmatize_text(doc)
        # remove special characters and\or digits    
        if special_char_removal:
            # insert spaces between special characters to isolate them    
            special_char_pattern = re.compile(r'([{.(-)!}])')
            doc = special_char_pattern.sub(" \\1 ", doc)
            doc = remove_special_characters(doc, remove_digits=remove_digits)  
        # remove extra whitespace
        doc = re.sub(' +', ' ', doc)
        doc = re.sub('`', '', doc)
        # remove stopwords
        if stopword_removal:
            doc = remove_stopwords(doc, is_lower_case=text_lower_case)
        
        normalized_corpus.append(doc)
        
    return normalized_corpus
        

#%% Normalize the text data and add a new column on the csv file of the preprocessed text


#%% Let's see how our dataset looks like 


#%% Save the new csv file 


#%% Exploratory Data Analysis 
# zero (0) means not recommended, one (1) means recommended
# we will group the clothing reviews based on whether they recommend the clothing or not


#%% Creating a bar graph of the reviews that recommend the clothing or not 



#%% Creating bigrams and calculating the bigrams for all the recommended reviews


#%% Creating a plot of the number of bigrams for all the recommended reviews


#%% #%% Creating a plot of the number of bigrams for all the not recommended reviews



