# -*- coding: utf-8 -*-
"""
Created on Tue Apr 26 10:29:30 2016

@author: sstojanovic
"""


#y_values = np.asarray(list(raw_pivoted.index.values))
#y = np.array(map(int,y_values[:,1]))
#x = np.array(raw_pivoted.values)
#
#size = len(y)
#
#inp = x.reshape(size,891)
#tar = y.reshape(size,1)
#
## make max and min
#seq = np.linspace(0,891,891)
#ranges = []
#
#for i in seq:
#    ranges.append([0,1])



# Create network with 2 layers and random initialized
net = nl.net.newff(ranges,[10, 1])

# Train network
error = net.train(inp, tar, epochs=30, show=1, goal=0.02)

# Simulate network
out = net.sim(inp)

# Plot result
import pylab as pl
pl.subplot(211)
pl.plot(error)
pl.xlabel('Epoch number')
pl.ylabel('error (default SSE)')
