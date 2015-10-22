
#import numpy as np
#import pandas as pan


#import mnist_loader   


#mn = mnist_loader

#Data = mn.load_data()

#Train = Data[0]

#Test = Data[2]

#x = Train[0]
#y = Train[1]

#i = 5

## For Plotting.
##matshow(np.asmatrix(x[i]).reshape(28,28), fignum = 99, cmap = cm.gray)
##show()
## predictor value.

#realTrain, realValidation, realTest = mn.load_data_wrapper()

#import Neural_Nets as nn

#nets = nn.Network([784,30,10])
#nets.SGD(realTrain, 10, 10, 3.0, test_data = realTest)

##prediction
#tx, ty = realTest[i]
#argmax(nets.feedforward(x))
#y

import Neural_Nets as nn
nets = nn.Network([784,30,10])
import mnist_loader
Train, Val, Test = mnist_loader.load_data_wrapper()

def run_NN():

    nets.SGD(Train, 10, 10, 3.0, test_data = Test)


#import mnist_loader
#import sampleFunctions

#sampleFunctions.showInput(Test, 3711)

