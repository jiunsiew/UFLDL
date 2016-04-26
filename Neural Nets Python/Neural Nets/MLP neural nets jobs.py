# -*- coding: utf-8 -*-
"""
Created on Mon Apr 25 21:03:42 2016

@author: sstojanovic
"""

#import sklearn.neural_network as nn


import neurolab as nl
import numpy as np
import pyodbc
import string
import datetime
import pandas as pd
import re

# Create train samples


cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=EVORA;DATABASE=Kaggle')
cursor = cnxn.cursor()
cursor.execute(" SELECT a.*, b.hat FROM (SELECT CAST(job_id AS INT) AS job_id, CAST(SUBSTRING(variable,2,LEN(variable)) AS INT) - 1 AS cluster_id, value AS is_included FROM job_title_reduced_dimension) a JOIN jobs_sneak b ON a.job_id = b.job_id WHERE hat != -1")

table = cursor.fetchall()

raw_data = []

print("data retrieved")

for rows in table:
    raw_data.append([x for x in rows])

raw_data_2 = pd.DataFrame(raw_data)

raw_pivoted = pd.pivot_table(raw_data_2, values=2, index=[0, 3], columns=[1], aggfunc=np.max)


y_values = np.asarray(list(raw_pivoted.index.values))
y = np.array(map(int,y_values[:,1]))
x = np.array(raw_pivoted.values)

size = len(y)

inp = x.reshape(size,891)
tar = y.reshape(size,1)

# randomise input and target.
shuff = np.append(inp,tar,1)
np.random.shuffle(shuff)

new_x_train = shuff[:1200,:891]
new_y_train = shuff[:1200, 891]

new_x_test = shuff[1200:,:891]
new_y_test = shuff[1200:, 891]

inp_train = new_x_train.reshape(1200,891)
tar_train = new_y_train.reshape(1200,1)

inp_test = new_x_test.reshape(255,891)
tar_test = new_y_test.reshape(255,1)

# make max and min
seq = np.linspace(0,891,891)
ranges = []

for i in seq:
    ranges.append([-2,2])

#clean up
del shuff
del inp
del tar
del new_x_train
del new_y_train
del new_x_test
del new_y_test

print("running network")
# Create network with 2 layers and random initialized
net = nl.net.newff(ranges,[20, 1])

# Train network
error = net.train(inp_train, tar_train, epochs=40, show=1, goal=0.02)

# Simulate network
out = net.sim(inp_test)

correct = 0

validation = np.append(out,tar_test,1)



# Plot result
import pylab as pl
pl.subplot(211)
pl.plot(error)
pl.xlabel('Epoch number')
pl.ylabel('error (default SSE)')

#x2 = np.linspace(-6.0,6.0,150)
#z2 = np.linspace(-1.0,1.0,150)
#x2 = [x2,z2]
#x2 = np.array(x2)
#y2 = net.sim(np.transpose(x2)).reshape(z2.size)

#y3 = out.reshape(size)

#pl.subplot(212)
#pl.plot(x2[1,:], y2, '-',x[1,:] , y, '.', x[1,:], y3, 'p')
#pl.legend(['train target', 'net output'])
#pl.show()