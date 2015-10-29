import numpy as np

def translate(Train, x_shift, y_shift):

    x = np.asmatrix(Train).reshape(28,28)
    nx,ny = (28, 28)
    X = np.linspace(-13,14,nx)
    Y = np.linspace(-13,14,ny)

    XV, YV = np.meshgrid(X,Y)

    XU = np.round(XV + x_shift)
    YU = np.round(YV + y_shift)

    transTrain = np.zeros(shape=(28,28))

    for i in xrange(28):
        for j in xrange(28):
            if ((YU[i,j] < 0) | (YU[i,j] > 27)):
                transTrain[i,j] = 0
            elif ((XU[i,j] < 0) | (XU[i,j] > 27)):
                transTrain[i,j] = 0
            else:
                #print "indices: ", i, ", ", j, " coords: ", YU[i,j], ", ", XU[i,j] -- debugging purposes.
                transTrain[i,j] = x[YU[i,j],XU[i,j]]

    return transTrain

def expand(Trainset):
    


    return False


def rotate(Train, rotDeg):

    rotRad = rotDeg * np.pi / 180 

    x = np.asmatrix(Train).reshape(28,28)
    nx,ny = (28, 28)
    X = np.linspace(-13,14,nx)
    Y = np.linspace(-13,14,ny)
    XV, YV = np.meshgrid(X,Y)

    XU, YU = DoRotation(XV,YV,rotRad)

    XU = np.round(XU) + 13
    YU = np.round(YU) + 13

    rotTrain = np.zeros(shape=(28,28))

    for i in xrange(28):
        for j in xrange(28):
            if ((YU[i,j] < 0) | (YU[i,j] > 27)):
                rotTrain[i,j] = 0
            elif ((XU[i,j] < 0) | (XU[i,j] > 27)):
                rotTrain[i,j] = 0
            else:
                #print "indices: ", i, ", ", j, " coords: ", YU[i,j], ", ", XU[i,j] -- debugging purposes.
                rotTrain[i,j] = x[YU[i,j],XU[i,j]]


    return rotTrain


def DoRotation(xv, yv, rotRad):

    RotMatrix = ([np.cos(rotRad), np.sin(rotRad)],
                            [-1*np.sin(rotRad), np.cos(rotRad)])

    """ einstein summation, creates tensors and collapses them on the shown indices """
    return np.einsum('ji, mni -> jmn', RotMatrix, np.dstack([xv,yv]))



def artificially_expand(Train):
    
    Train_new = Train
    i = 0
    for j in range(np.size(Train)/2):
        t1 = rotate(Train[j][0], np.random.normal(0,10))
        t2 = rotate(Train[j][0], np.random.normal(0,10))
        t3 = translate(Train[j][0],np.random.normal(0,1),np.random.normal(0,1))

        Train_new.append((t1,Train[j][1]))
        Train_new.append((t2,Train[j][1]))
        Train_new.append((t3,Train[j][1]))

        if( i % 1000 == 0):
            print i
        i = i + 1

    return Train_new