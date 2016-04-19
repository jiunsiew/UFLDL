
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
dim = 10

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
gamma = 0.01
# regularisation paramater
lambda = 5


# gradient descent step
p <- p_init - gamma * ( ( R - p_init %*% q_init ) %*% t(q_init) - lambda * abs(p_init))

q <- q_init - gamma * ( t(p_init) %*% ( R - p_init %*% q_init ) - lambda * abs(q_init))

p_init <- p
q_init <- q

cost(p,q)





