

#clear all
rm(list = ls())





# check out https://gist.github.com/johnbaums/882ad1e458e13b96a3d1 For the original code.
# this reads the MNIST data.
  
  readTrain <- function() {
    img <- file("R/ex1/train-images.idx3-ubyte", "rb")
    hdr <- readBin(img, 'integer', n=4, endian="big")
    X <- t(sapply(seq_len(hdr[2]), function(ii) {
      readBin(img, 'integer', size=1, n=prod(hdr[3:4]), endian="big")
    }))  
    close(img)
    lab <- file("R/ex1/train-labels.idx1-ubyte", "rb")
    readBin(lab, "integer", n = 1, size = 4, endian = "big")
    n <- readBin(lab, integer(), n=1, size=4, endian="big")
    y <- readBin(lab, integer(), n=n, size=1, signed=FALSE)  
    close(lab)
    cbind.data.frame(y=factor(y), X)
  }  
  X <- readTrain()

  # only get 0's and 1's for this example.
  x <- X[X$y == 1 | X$y == 0,]
  y <- x[,1]
  
  #shift the data by the mean and scale according to the standard deviation. 
  m <- rowMeans(x[,2:ncol(x)], dims = 1)
  s <- apply(x[,2:ncol(x)],1,sd)

  #Get our shcaled training set.
  Train <- data.frame(y,(x[,2:ncol(x)] - m) / (s+0.1))

  #set up an index and permute the training set.
  index <- 1:nrow(Train)
  permIndex <- sample(index)


  
  Train <- Train[permIndex,]


  # TODO: Do the same for our test set. Set this up as a new function to retrieve the training / test data.
  

  #test <- read('t10k')
  #list(train=train, test=test)



# get data from housing.data
to.read <- file("R/ex1/train-images.idx3-ubyte", "rb")
to.pred <- file("R/ex1/train-labels.idx1-ubyte", "rb")

# read the header. 2051 images, 28 rows, 28 columns per image.
readBin(to.read, integer(), n=4, endian="big")
readBin(to.pred, integer(), n=1, endian="big")

# read this data into a matrix.
m <- matrix(readBin(to.read,integer(), size=1, n=28*28, endian="big"),28,28)

#flip it to make it readable.
m <- apply(m,2,rev)
m <- apply(m,1,rev)
m <- apply(m,1,rev)

#have a look at the image.
image(m)


# add 'intercept' column
housingData$intercept = 1

# split into training and test data
permVect <- runif(nrow(housingData))

trainIndex <- permVect <= 0.8


train <- housingData[trainIndex,]
test <- housingData[!trainIndex,]



# predictor
y <- train[,14]
# observables
x <- as.matrix(train[,c(1:13,15)])

sigmoid = function(x,theta){
  return 1 / (1 + exp(-1*t(theta)%*%x))
}


logregVec = function(x,y,alpha=0.05, maxIterations = 1000000){
  
  
  # alpha is the iteration paramater... Might want to make this higher than the default...
  
  # number of input variables
  nInput <- (ncol(x))
  
  # coefficients
  theta <- rep(0,nInput)#runif(nInput)
  
  # Cost function gradient. This is our starting point.
  delta <- rep(1,nInput)
  
  # counter to make sure we don't run an infinite loop.
  n = 0
  
  #gradient descent
  while (abs(max(delta)) > 0.0001 & n < maxIterations)
  {
    h = sigmoid(x, theta)
    err = h - y
    delta = (t(x) %*% err)
    delta = delta / norm(delta, "F")
    theta = theta - alpha*delta
    n = n+1 
  }
  
  return(theta)
}


# looking at the math t(x)*x*theta = t(x)*y. We can solve for theta (the coefficients)
linregLinAlg = function(x,y){
  
  leftHandOperator = t(x)%*%x
  rightHandSide = t(x)%*%y
  # use R's Linear Algebra solver.
  theta = solve(leftHandOperator,rightHandSide)
  
  return(theta)
}

#Run our function. It takes a while. Pun not intended.
Coefficients <- linregVec(x,y,0.1)


# the easy way...
fit.lm = lm(V14~.,data=train[,1:14])

# our version of theta
theta

# R's standard version of theta
fit.lm


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









