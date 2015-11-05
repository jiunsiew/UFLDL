
#>>> import tester as test
#>>> test.run_NN()
#Epoch 0: 9046 / 10000
#Epoch 1: 9232 / 10000
#Epoch 2: 9255 / 10000
#Epoch 3: 9305 / 10000
#Epoch 4: 9340 / 10000
#Epoch 5: 9353 / 10000
#Epoch 6: 9380 / 10000
#Epoch 7: 9391 / 10000
#Epoch 8: 9385 / 10000
#Epoch 9: 9438 / 10000
#>>> import sampleFunctions as funcs
#>>> funcs.showInput(test.Test,34)


    
import numpy as np
from matplotlib.pyplot import matshow
from matplotlib.pyplot import show
from matplotlib import cm
import matplotlib.pyplot as plt
import Neural_Nets as nn


def predict(nets,matrices,i):
    a = matrices[i][0]
    for b, w in zip(nets.biases, nets.weights):
        a = nn.sigmoid(np.dot(w, a).reshape(b.size,1) + b)
    return np.argmax(a)

def showInput(matrices,i):
    x,y = matrices[i]
    print y
    matshow(np.asmatrix(x).reshape(28,28), fignum = 99, cmap = plt.get_cmap('gray') )
    show()
    return y

def showMatrix(x):
    matshow(x, fignum = 99, cmap = plt.get_cmap('gray') )
    show()
    return True


