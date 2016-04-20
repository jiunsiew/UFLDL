
# This algorithm is based off the netflix prize SVD++ algorithm.

# init --------------------------------------------------------------------
rm(list = ls())

library(RODBC)
library(plyr)
library(dplyr)
library(ggplot2)
library(matrixcalc)
theme_set(theme_bw())


# get data ----------------------------------------------------------------
conn <- odbcConnect("Kaggle_localDB")
rawData <- sqlFetch(conn, 'hotel_rec_destinations_last_mil_ranking_v1')
# rawData <- odbcQuery(conn, "select * from ibit_rimor.dbo.tmp_js_health_speedToCompetency_20150618")
close(conn)

library(MASS)

#dimension of latent factors
dim = 15

R <- as.matrix(rawData[,2:101])

# cost function simplified form.
#cost <- matrix.trace(t(R - p_init %*% q_init)%*%(R - p_init %*% q_init))

cost <- function(a,b){
  return (matrix.trace(t(R - a %*% b)%*%(R - a %*% b)))
}

#initialise p and q matrices.

p_init <- t(matrix(rnorm(dim*161440, mean = 0, sd = 2), dim))
q_init <- matrix(rnorm(dim*100, mean = 0, sd = 2), dim)


# learning rate
gamma = 0.000001
# regularisation paramater
lambda = 10

#initial cost
cost(p_init,q_init)


# gradient descent step

max_steps = 30
error = 100000000

step_count = 0

while(step_count < max_steps && abs(error) > 0.0005){

init_cost = cost(p_init,q_init)
  
p <- p_init + gamma * ( ( R - p_init %*% q_init ) %*% t(q_init) - lambda * p_init)

q <- q_init + gamma * ( t(p_init) %*% ( R - p_init %*% q_init ) - lambda * q_init)

p_init <- p
q_init <- q

error = cost(p,q) - init_cost

step_count = step_count + 1
print(cost(p,q))
print(step_count)
print(abs(error))
}


# new rating matrix.
new_R <- p %*% q

# basic stats
plot(q[1,],q[2,])
plot(q[2,],q[3,])
plot(q[2,],q[10,])

q_df <- as.data.frame(t(q))
pairs(q_df)

quantile(unlist(abs(new_R)), c(0.5, 0.8, 0.95))
quantile(unlist(abs(R)), c(0.5, 0.8, 0.95))

