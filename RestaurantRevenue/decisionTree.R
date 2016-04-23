

# get data ----------------------------------------------------------------
library(gdata)
mydata = read.csv("C:\\Users\\sstojanovic\\Downloads\\wave500k\\wave500k.csv")


trainPercent = 0.8

library(caret)
# look at relatioship with P ----------------------------------------------
inTrain <- createDataPartition(y = mydata$CLASS, p = trainPercent, list = FALSE)

training <- mydata[inTrain,]
testing <- mydata[-inTrain,]



library(rpart)
dTree <- rpart(CLASS ~ .,  data = training )

#dTree <- rpart(revenue ~ P1 + P2 + P3 + P4 + P5 + P6 + P7 + P8 + P9 + P10 + 
#                 P11 + P12 + P13 + P14 + P15 + P16 + P17 + P18 + P19 + P20 +
#                 P21 + P22 + P23 + P24 + P25 + P26 + P27 + P28 + P29 + P30 +
#                 P31 + P32 + P33 + P34 + P35 + P36 + P37
#               ,  data = data[1:100,])



library(rpart.plot)
rpart.plot(dTree)

TestingData <- sqlFetch(conn,'restaurant_revenue_prediction.test_data')

TestingData <- trainData[(floor(trainPercent*nrow(trainData))+1):nrow(trainData), ]

prediction

library(rpart.utils)

prediction <- predict(dTree,testing)


pred <- as.data.frame(prediction)


outcome <- max(apply(pred$A,pred$B,pred$C))

pred$max <- apply(pred, 1, which.max)

pred$max_name <- colnames(pred)[pred$max]


pred$isCorrect <- ifelse(pred$max_name == testing$CLASS,1,0)

mean(pred$isCorrect)

resultData <- data.frame(TestingData, prediction)






names(resultData)[1] <- paste("Id")
names(resultData)[2] <- paste("Prediction")

write.csv(resultData,file="submission_20150327_1.csv",row.names = FALSE)

library(caret)
inTrain <- createDataPartition(y = trainData$revenue, p = 0.75, list = FALSE)




