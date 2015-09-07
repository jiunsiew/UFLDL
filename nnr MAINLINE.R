

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

a_1 = x

sg = function(x){
  return (1 / (1 + exp(-1*(x))))
}

z_2 = t(W_1 %*% t(x) + b1)
a_2 = sg(z_2)


W_2 <- t(as.matrix(rnorm(nneurons, mean = 0, sd = 1)))
b2 <- as.matrix(rnorm(1, mean = 0, sd = 1))
b2 = matrix(b1, nrow = 1, ncol = nrow(x))

z_3 = t(W_2 %*% t(a_2) + b2)
a_3 <- sg(z_3)
  

derivSg = function(x){
  sg(x)*(1-sg(x))
}


dv <- derivSg(z_3)

delta_3 <-  -1*(y - a_3)*derivSg(z_3)

delta_2 <- t(W_2)%*%t(delta_3) * derivSg(t(z_2))

d_2_placeholder <- as.matrix(c(1))
d_2_placeholder = matrix(tmp, nrow = 1, ncol = nrow(x))

nabla_w_1 = delta_2 %*% a_1
nabla_b_1 = delta_2 %*% t(d_2_placeholder)

nabla_w_2 = t(delta_3) %*% a_2
nabla_b_2 = t(delta_3) %*% t(d_2_placeholder)



