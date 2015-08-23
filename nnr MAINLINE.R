

# 
# Train <- getMNISTBinaryTrainingData()
# # predictor
# y <- as.numeric(Train[,1])-1
# # observables
# x <- as.matrix(Train[,2:ncol(Train)])


## create NNR with 1 hidden layer

## start off with a simple dataset.. i.e. the housing dataset.

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
# observables (most explanatory from lin reg. This is just a small problem to test NNR.)
x <- as.matrix(train[,c(5,6,8)])

nneurons <- ncol(x)

W1 <- rnorm(nneurons^2, mean = 0, sd = 1)
b1 <- rnorm(nneurons, mean = 0, sd = 1)

sigmoid = function(x,theta){
  return (1 / (1 + exp(-1*theta%*%t(x))))
}







