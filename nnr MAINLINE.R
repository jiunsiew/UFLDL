

# 
# Train <- getMNISTBinaryTrainingData()
# # predictor
# y <- as.numeric(Train[,1])-1
# # observables
# x <- as.matrix(Train[,2:ncol(Train)])

rm(list = ls())
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
Y <- train[,14]
# observables (most explanatory from lin reg. This is just a small problem to test NNR.)
X <- as.matrix(train[,c(5,6,8)])



nneurons <- ncol(X)


sg = function(x){
  return (1 / (1 + exp(-1*(x))))
}

derivSg = function(x){
  sg(x)*(1-sg(x))
}

# create fake y.


w_1_real <- matrix(c(-0.8,0.5,0.1,-0.6,1.2,-0.54,1,-0.88,-0.32), nrow = 3, ncol = 3, byrow = TRUE)
b1_real <- t(matrix(c(0.2,0,0), nrow = 1, ncol = 3, byrow = TRUE))

w_2_real <- matrix(c(0.52,-1.65,0.11), nrow = 1, ncol = 3, byrow = TRUE)
b2_real <- matrix(c(0.25))


for (i in 1:nrow(X)){
x = matrix(X[i,])
a_1 = x

z_2 = t(w_1_real %*% x + b1_real)
a_2 = sg(z_2)


z_3 = t(w_2_real %*% t(a_2) + b2_real)
Y[i] = sg(z_3)
}




set.seed(823)

W1 <- as.matrix(rnorm(nneurons^2, mean = 0, sd = 1))
b1 <- as.matrix(rnorm(nneurons, mean = 0, sd = 1))


W_1 <- matrix(W1, nrow = 3, ncol = 3)

W_2 <- t(as.matrix(rnorm(nneurons, mean = 0, sd = 1)))
b2 <- as.matrix(rnorm(1, mean = 0, sd = 1))



W_1 = w_1_real
#W_2 = w_2_real
b1 = b1_real
#b2 = b2_real


m = nrow(X)
lambda = 0
alpha = 0.005

# counter to make sure we don't run an infinite loop.
n = 0
maxComponent = 1
maxIterations = 2000
#gradient descent. TODO: When delta gets ~ < 10 the algorithm becomes really slow to converge. Might need to dynamically increase alpha depending on the size of norm(delta, "F")




#gradDescent = function(){
while (maxComponent > 0.02 & n < maxIterations)
{
  
  delta_W_1 = matrix(0, dim(W_1)[1], dim(W_1)[2] )
  delta_b_1 = matrix(0, dim(b1))
  
  delta_W_2 = matrix(0, dim(W_2)[1], dim(W_2)[2] )
  delta_b_2 = matrix(0, dim(b2))
  
  
  for (i in 1:nrow(X)){
    
    x = X[i,]
    y = Y[i]
    #a_1 <- t(W_1 %*% t(x) + b1)
    
    a_1 = x
    
    
    
    z_2 = W_1 %*% x + b1
    a_2 = sg(z_2)
    
    
    z_3 = t(W_2 %*% a_2 + b2)
    a_3 <- sg(z_3)
    
    
    
    
    
    dv <- derivSg(z_3)
    
    delta_3 <-  -1*(y - a_3)*derivSg(z_3)
    
    delta_2 <- t(W_2)%*%delta_3 * derivSg(z_2)
    
    nabla_w_1 = delta_2 %*% t(a_1)
    nabla_b_1 = delta_2 
    
    nabla_w_2 = delta_3 %*% t(a_2)
    nabla_b_2 = delta_3
    
    delta_W_1 <-  delta_W_1 + nabla_w_1
    delta_W_2 <-  delta_W_2 + nabla_w_2
    delta_b_1 <-  delta_b_1 + nabla_b_1
    delta_b_2 <-  delta_b_2 + nabla_b_2
    
  }
  
  W_1 = W_1 - alpha * (delta_W_1 / m + lambda * W_1)
  W_2 = W_2 - alpha * (delta_W_2 / m + lambda * W_2)
  b1 = b1 - alpha * (delta_b_1 / m)
  b2 = b2 - alpha * (delta_b_2 / m)
  
  n = n+1 
  print(n)
  print(abs(max(delta_W_1)))
  print(abs(max(delta_W_2)))
  print(abs(max(delta_b_1)))
  print(abs(max(delta_b_2)))
  maxComponent = max(abs(max(delta_W_1)),abs(max(delta_W_2)),abs(max(delta_b_1)),abs(max(delta_b_2)))
  
  #print(abs(max(delta)))
  #print(norm(delta, "F"))
}
#}




