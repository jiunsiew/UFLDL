

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
#housingData$intercept = 1

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
b1 = matrix(b1, nrow = 3, ncol = nrow(x))

W_1 <- matrix(W1, nrow = 3, ncol = 3)

#a_1 <- t(W_1 %*% t(x) + b1)



sg = function(x){
  return (1 / (1 + exp(-1*(x))))
}

a_2 = sg(t(W_1 %*% t(x) + b1))


W_2 <- t(as.matrix(rnorm(nneurons, mean = 0, sd = 1)))
b2 <- as.matrix(rnorm(1, mean = 0, sd = 1))
b2 = matrix(b1, nrow = 1, ncol = nrow(x))

a_3 <- sg(t(W_2 %*% t(a_2) + b2)  )
  

derivSg = function(x){
  sg(x)*(1-sg(x))
}

z_2 <- a%*%W2 + b_2

dv <- derivSg(z_2)

d_nl <-  -1*(y - sg(z_2))*derivSg(z_2)

temp <- W1%*%t(d_nl)

z_1 <- x%*%W1 + b_1

