
# init --------------------------------------------------------------------
rm(list = ls())

library(RODBC)
library(plyr)
library(dplyr)
library(ggplot2)
theme_set(theme_bw())


# get data ----------------------------------------------------------------
conn <- odbcConnect("Kaggle_localDB")
rawData <- sqlFetch(conn, 'hotel_rec_destinations_last_mil_ranking_v1')
# rawData <- odbcQuery(conn, "select * from ibit_rimor.dbo.tmp_js_health_speedToCompetency_20150618")
close(conn)

library(MASS)

num_eigenvectors = 25


A <- as.matrix(rawData[,2:101])

A.SVD <- svd(A)

eigenvectors <- A.SVD$d[1:num_eigenvectors]



eigenvectors_2 <- append(eigenvectors, rep(0,100-num_eigenvectors), after = length(eigenvectors))

D <- as.matrix(diag(eigenvectors_2),nrow=100,ncol=100)

A.New <- A.SVD$u %*% D %*% A.SVD$v

u_df <- as.data.frame(t(A.SVD$u))
v_df <- as.data.frame(t(A.SVD$v))
pairs(v_df[,1:10])

max(A.New)
min(A.New)
mean(abs(A.New))
mean(abs(A))

median(abs(A.New))
median(abs(A))

# basic stats
quantile(unlist(abs(A.New)), c(0.5, 0.8, 0.95))
quantile(unlist(abs(A)), c(0.5, 0.8, 0.95))
