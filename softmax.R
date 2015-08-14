

#clear all
rm(list = ls())





# check out https://gist.github.com/johnbaums/882ad1e458e13b96a3d1 For the original code.
# this reads the MNIST data.

readMNIST <- function(image = "R/ex1/train-images.idx3-ubyte", pred = "R/ex1/train-labels.idx1-ubyte") {
  img <- file(image, "rb")
  hdr <- readBin(img, 'integer', n=4, endian="big")
  X <- t(sapply(seq_len(hdr[2]), function(ii) {
    readBin(img, 'integer', size=1, n=prod(hdr[3:4]), endian="big")
  }))  
  close(img)
  lab <- file(pred, "rb")
  readBin(lab, "integer", n = 1, size = 4, endian = "big")
  n <- readBin(lab, integer(), n=1, size=4, endian="big")
  y <- readBin(lab, integer(), n=n, size=1, signed=FALSE)  
  close(lab)
  cbind.data.frame(y=factor(y), X)
}  
X <- readMNIST()

# only get 0's and 1's for this example.
x <- X
y <- x[,1]

#shift the data by the mean and scale according to the standard deviation. 
m <- rowMeans(x[,2:ncol(x)], dims = 1)
s <- apply(x[,2:ncol(x)],1,sd)

#Get our normalised training set.
Train <- data.frame(y,(x[,2:ncol(x)] - m) / (s+0.1))

#set up an index and permute the training set.
index <- 1:nrow(Train)
permIndex <- sample(index)

Train <- Train[permIndex,]

Train$intercept = 1


#Do the same for our test set. Set this up as a new function to retrieve the training / test data.
Y <- readMNIST(image = "R/ex1/t10k-images.idx3-ubyte", pred = "R/ex1/t10k-labels.idx1-ubyte")

x <- Y
y <- x[,1]

#shift the data by the mean and scale according to the standard deviation. 
m <- rowMeans(x[,2:ncol(x)], dims = 1)
s <- apply(x[,2:ncol(x)],1,sd)

#Get our normalised training set.
Test <- data.frame(y,(x[,2:ncol(x)] - m) / (s+0.1))

Test$intercept = 1


#test <- read('t10k')
#list(train=train, test=test)



# To visualise the data.
#                to.read <- file("R/ex1/train-images.idx3-ubyte", "rb")
#                to.pred <- file("R/ex1/train-labels.idx1-ubyte", "rb")
#                
#                # read the header. 2051 images, 28 rows, 28 columns per image.
#                readBin(to.read, integer(), n=4, endian="big")
#                readBin(to.pred, integer(), n=1, endian="big")
#                
#                # read this data into a matrix.
#                m <- matrix(readBin(to.read,integer(), size=1, n=28*28, endian="big"),28,28)
#                
#                #flip it to make it readable.
#                m <- apply(m,2,rev)
#                m <- apply(m,1,rev)
#                m <- apply(m,1,rev)
#                
#                #have a look at the image.
#                image(m)




#reusing x and y... This should be changed.

# predictor
y <- as.numeric(Train[,1])-1
# observables
x <- as.matrix(Train[,2:ncol(Train)])



gradJ = function(x,theta){
  
  k = ncol(theta)
  m = nrow(x)
  n = ncol(x)
  
  
  #indicator function
  ind = matrix(0,m,k)
  
  for (i in 1:m)
  {
    ind[i,Y[i,1]] = 1
  }
  
  #x = as.matrix(x[,2:ncol(x)])
  
  tmp1 = exp(x %*% theta)
  tmp2 = t(matrix(rep(rowSums(tmp1), each = k), nrow = k))
  p = tmp1 / tmp2
  
  output = t(x) %*% (ind - p)
  return(output)
}



logregVec = function(x,y,numClasses = 10,alpha=0.05, maxIterations = 1000000){
  
  
  # alpha is the iteration paramater... Might want to make this higher than the default...
  alpha = 0.0005
  # number of input variables
  nInput <- (ncol(x))
  
  # coefficients
  theta <- matrix(0,nInput,10)
  #theta <- 
  
  # Cost function gradient. This is our starting point.
  delta <- matrix(1,nInput,10)
  
  # counter to make sure we don't run an infinite loop.
  n = 0
  #gradient descent. TODO: When delta gets ~ < 10 the algorithm becomes really slow to converge. Might need to dynamically increase alpha depending on the size of norm(delta, "F")
  while (abs(max(delta)) > 0.0001 & n < maxIterations)
  {
    
    
    delta = gradJ(x,theta)
    #delta = output
    #deltaNorm = delta / norm(delta, "F")
    theta = theta - alpha*delta
    n = n+1 
    #print(n)
    #print(abs(max(delta)))
    #print(norm(delta, "F"))
  }
  
  return(theta)
}



#Run our function. It takes a while. Pun not intended.
Coefficients <- logregVec(x,y,0.0001)

# the easy way. Even this is really long.

fit.log = glm(y~., data = Train[,2:785], family = binomial )



# our version of theta
theta

# R's standard version of theta


T = Test[,2:785]
p <- predict.glm(fit.log, newdata = T,type = "response")

p = as.matrix(p)


pred = as.numeric(p > 0.5)

compare = data.frame(pred,Test)

#Get least squares (training).

error <- x %*% theta - y

# divide by number of observations in order to get error per observation.
leastSq <- 0.5*t(error)%*%error / nrow(error)

leastSq

yTest <- test[,14]
xTest <- as.matrix(test[,c(1:13,15)])

testError <- xTest %*% theta - yTest

testLeastSq <- 0.5*t(testError)%*%testError / nrow(testError)

#test error per observation. This should be higher than the test error per observation (unless we're really lucky!)
testLeastSq







