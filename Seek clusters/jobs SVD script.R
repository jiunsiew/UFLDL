
# init --------------------------------------------------------------------
rm(list = ls())

library(RODBC)
library(plyr)
library(dplyr)
library(ggplot2)
theme_set(theme_bw())

library(reshape)



# get data ----------------------------------------------------------------
conn <- odbcConnect("Evora_Kaggle")
rawData <- sqlFetch(conn, 'job_title_cluster_matrix_sneak')
 #rawData <- odbcQuery(conn, "select * from dbo.job_title_cluster_matrix_sneak")
close(conn)

library(MASS)

rawData_matrix <- cast(rawData, job_id ~ cluster_id, max)



num_cols = length((rawData_matrix[1,]))


A <- as.matrix(rawData_matrix[,2:num_cols])

A.SVD <- svd(A)

# look at the eigenvalue spectrum.
x <- seq(1,891)
plot(x = x, y = A.SVD$d)

num_eigenvectors = 860

eigenvectors <- A.SVD$d[1:num_eigenvectors]



eigenvectors_2 <- append(eigenvectors, rep(0,num_cols-1-num_eigenvectors), after = length(eigenvectors))

D <- as.matrix(diag(eigenvectors_2),nrow=num_cols-1,ncol=num_cols-1)

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
quantile(unlist(abs(A.New)), c(0.5, 0.8, 0.95, 0.98))
quantile(unlist(abs(A)), c(0.5, 0.8, 0.95, 0.98))

# melt data back to an unpivoted view.
new_matrix <- data.frame(as.data.frame(rawData_matrix[,1]),as.data.frame(A.New))

# get the id name.
names(new_matrix)[1] <- "job_id"



new_matrix_unpivot <- melt(data = new_matrix, id = "job_id")

conn <- odbcConnect("Evora_Kaggle")
rawData <- sqlSave(conn, new_matrix_unpivot, tablename = 'job_title_reduced_dimension')
