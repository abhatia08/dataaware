# -*- coding: utf-8 -*-
"""
Module 1: Text Preprocessing

Created on Mon Jun 26 14:09:59 2023

@author: Ashley Victor 
"""
#%%

# go to the command prompt (or terminal) and download the following 
# pip install nltk

#%% Import python modules and packages 

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

#%%
def remove_special_characters(text, remove_digits=False):
    '''
    A caret located in a bracket means ‘not.’ 
    If remove_digits parameter is True, "^a-zA-Z0-9\s" matches any characters other than 
    alphabets ([a-zA-Z]) or digits ([0-9]), followed by a white space ([\s]).
    If 'remove_digits' parameter is False, the the function will remove numbers as well. 
    '''
    pattern = r'[^a-zA-Z0-9\s]' if not remove_digits else r'[^a-zA-z\s]'
    text = re.sub(pattern, '', text)
    return text

#%% This code block removes all the stopwords from text data. Stopwords are the not important words in text.

print(stopwords.words('english'))

tokenizer = ToktokTokenizer()
stopword_list = nltk.corpus.stopwords.words('english')
stopword_list.remove('no') # we will not remove 'no' from texts
stopword_list.remove('not') # we will not reomve 'not' from texts

def remove_stopwords(text, is_lower_case=False):
    # First, tokenize the text
    tokens = tokenizer.tokenize(text)
    # remove whitespaces in each token
    tokens = [token.strip() for token in tokens]
    # if "is_lower_case" parameter is True, 
    # we will not remove stopwords that have any upper case letter
    if is_lower_case: 
        filtered_tokens = [token for token in tokens if token not in stopword_list]
    # If "is_lower_case" parameter is False, 
    # we will remove any stopwords no matter whether they are in uppercase or not
    else:
        filtered_tokens = [token for token in tokens if token.lower() not in stopword_list]
    filtered_text = ' '.join(filtered_tokens)    
    return filtered_text



#%%
"""
This code block performs stemming on the text data. Stemming is removing the suffixes of words. 
"""
def simple_stemmer(text):
    ps = nltk.porter.PorterStemmer()
    # split the text into individual word and return a list of words
    # the 'ps' function stems each word, and .join() function joins the stemmed words with whitespace.
    text = ' '.join([ps.stem(word) for word in text.split()]) 
    return text

#%%
""" 
This code block will perform lemmatization on your text data. 
"""
wordnet_lemmatizer = WordNetLemmatizer()

def lemmatize_text(text):
    s = " " # create an empty string that later will contain lemmatized words,
    t_l = [] # create an empty list
    t_w = nltk.word_tokenize(text) # tokenize the text
    # assign the list of tokenized words into t_w.
    for w in t_w:
        # “pos” is a part of speech parameter and “v” means verbs. 
        # We will lemmatize verbs only. 
        l_w = wordnet_lemmatizer.lemmatize(w, pos="v")
        # append l_w into the list t_l
        t_l.append(l_w)
    # joint the tokens to make a complete sentence
    text = s.join(t_l)
    return text 

#%% 
"""
This code block combines all the functions we have defined above. 
"""

def normalize_corpus(corpus, text_lower_case=True, 
                     text_lemmatization=True, special_char_removal=True, 
                     stopword_removal=True, remove_digits=True):
    
    normalized_corpus = []
    # normalize each document in the corpus
    for doc in corpus:
        # lowercase the text
        if text_lower_case:
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
