
# get data from housing.data
housingData <- read.table("R/ex1/housing.data")

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

linregVec = function(x,y,alpha=0.05, maxIterations = 1000000){

  
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
      h = x %*% theta
      err = h - y
      delta = (t(x) %*% err)
      delta = delta / min(1,norm(delta, "F"))
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










