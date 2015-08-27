

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

W1 <- as.matrix(rnorm(nneurons^2, mean = 0, sd = 1))
b1 <- as.matrix(rnorm(nneurons, mean = 0, sd = 1))

sigmoid = function(x,theta,b){
  return (1 / (1 + exp(-1*(theta%*%t(x) + b))))
}

sg = function(x){
  return (1 / (1 + exp(-1*(x))))
}

layer1 = function(x){
  w_1 = W1[1:3,]
  w_2 = W1[4:6,]
  w_3 = W1[7:9,]
  
  
  a_1 = sigmoid(x, w_1, b1[1])
  a_2 = sigmoid(x, w_2, b1[2])
  a_3 = sigmoid(x, w_3, b1[3])
  
  a = as.matrix(data.frame(t(a_1),t(a_2),t(a_3)))
  return(a)
}

b_2 = rnorm(1, mean = 0, sd = 1)
a = layer1(x)

W2 <- as.matrix(rnorm(nneurons, mean = 0, sd = 1))

output <- sigmoid(a,t(W2),b_2)

output = t(output)

derivSg = function(x){
  sg(x)*(1-sg(x))
}

z_2 <- a%*%W2 + b_2

dv <- derivSg(z_2)

d_nl <-  -1*(y - sg(z_2))*derivSg(z_2)




