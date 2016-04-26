# -*- coding: utf-8 -*-
"""
Created on Mon Apr 25 21:03:42 2016

@author: sstojanovic
"""

#import sklearn.neural_network as nn


import neurolab as nl
import numpy as np

# Create train samples
x = np.linspace(-7, 7, 100)
z = np.linspace(0,1,100)
y = z*np.sin(x) * 0.5

size = len(x)

x = [x,z]

x = np.array(x)


inp = x.reshape(size,2)
tar = y.reshape(size,1)

# Create network with 2 layers and random initialized
net = nl.net.newff([[-7, 7],[0,1]],[10, 1])

# Train network
error = net.train(inp, tar, epochs=500, show=100, goal=0.02)

# Simulate network
out = net.sim(inp)

# Plot result
import pylab as pl
pl.subplot(211)
pl.plot(error)
pl.xlabel('Epoch number')
pl.ylabel('error (default SSE)')

x2 = np.linspace(-6.0,6.0,150)
z2 = np.linspace(-1.0,1.0,150)
x2 = [x2,z2]
x2 = np.array(x2)
y2 = net.sim(np.transpose(x2)).reshape(z2.size)

y3 = out.reshape(size)

pl.subplot(212)
pl.plot(x2[1,:], y2, '-',x[1,:] , y, '.', x[1,:], y3, 'p')
pl.legend(['train target', 'net output'])
pl.show()