# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

#L = []
#L.append("cake")
#L.append("sandwich")
#L.append("sandy")
#L.append("Information")
#L.append("Informatics")
#L.append("cool")

import numpy as np 
import sklearn.cluster  
import distance
import pyodbc
import string
import datetime
import pandas as pd
import re
import nltk
#nltk.download()
from nltk.corpus import stopwords # Import the stop word list

current_time = datetime.datetime.now()

cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=EVORA;DATABASE=Kaggle')
cursor = cnxn.cursor()
cursor.execute("SELECT * FROM dbo.jobs_sneak")

table = cursor.fetchall()

raw_data = []


for rows in table:
    raw_data.append([x for x in rows])



words = ""
    
for y in raw_data:
    words = words + " " + re.sub("[^a-zA-Z\s]","",string.lower(y[9].translate(string.maketrans("",""), string.punctuation)))

words = words.split(" ")
#words = "cake sandwich sandy information informatics cool cool close closer this will figure out close words that are wordy".split(" ") #Replace this line
words = np.asarray(words) #So that indexing with a list will work

# do some natural language processing.

#print stopwords.words("english")

def get_meaningful_words(words):
    meaningful_words = [w for w in words if not w in stopwords.words("english")]


    word_list = pd.value_counts(pd.Series(meaningful_words))

    word_list_w_counts = pd.concat([pd.DataFrame(word_list.index.tolist()),pd.DataFrame(word_list.tolist())])


    word_list_new = np.asarray(word_list.index.tolist())
    
    return word_list_new
    
raw_mapping = []    

for row in raw_data:
    raw_words = np.asarray(re.sub("[^a-zA-Z\s]","",string.lower(row[9].translate(string.maketrans("",""), string.punctuation))).split(" "))
    raw_meaningful_words = get_meaningful_words(raw_words)
    for word in raw_meaningful_words:
        raw_mapping.append([row[0], word])


word_list_new = get_meaningful_words(words)


print("words computed")



lev_similarity = -1*np.array([[distance.levenshtein(w1,w2) for w1 in word_list_new] for w2 in word_list_new])


next_time = datetime.datetime.now()

time_diff = next_time - current_time

print(time_diff.total_seconds())

print("distances calculated")

cluster_data = []


affprop = sklearn.cluster.AffinityPropagation(affinity="precomputed", damping=0.5, preference = -3)
affprop.fit(lev_similarity)
for cluster_id in np.unique(affprop.labels_):
    exemplar = word_list_new[affprop.cluster_centers_indices_[cluster_id]]
    cluster = np.unique(word_list_new[np.nonzero(affprop.labels_==cluster_id)])
    for clust in cluster:
        cluster_data.append([cluster_id,clust])
    cluster_str = ", ".join(cluster)
    print(" - *%s:* %s" % (exemplar, cluster_str))


    
final_time = datetime.datetime.now()

final_time_diff = final_time - current_time

print(final_time_diff.total_seconds())

for row in cluster_data:
    cursor.execute("INSERT INTO dbo.abstract_cluster_data_sneak VALUES (?, ?)", [str(row[0]),row[1]])
    cursor.commit()

for row in raw_mapping:
    cursor.execute("INSERT INTO dbo.abstract_job_words_sneak VALUES (?, ?)", [str(row[0]),row[1]])
    cursor.commit()
