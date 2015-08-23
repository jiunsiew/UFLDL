

#clear all
rm(list = ls())



readMNIST <- function(image = "R/ex1/train-images.idx3-ubyte", pred = "R/ex1/train-labels.idx1-ubyte") {
  img <- file(image, "rb")
  hdr <- readBin(img, 'integer', n=4, endian="big")
  X <- t(sapply(seq_len(hdr[2]), function(ii) {
    readBin(img, 'integer', size=1, n=prod(hdr[3:4]), endian="big")
  }))  
  close(img)
  lab <- file(pred, "rb")
  readBin(lab, "integer", n = 1, size = 4, endian = "big")
  n <- readBin(lab, integer(), n=1, size=4, endian="big")
  y <- readBin(lab, integer(), n=n, size=1, signed=FALSE)  
  close(lab)
  cbind.data.frame(y=factor(y), X)
}  

getMNISTBinaryTrainingData <- function(){

# check out https://gist.github.com/johnbaums/882ad1e458e13b96a3d1 For the original code.
# this reads the MNIST data.

X <- readMNIST()

# only get 0's and 1's for this example.
x <- X[X$y == 1 | X$y == 0,]
y <- x[,1]

#shift the data by the mean and scale according to the standard deviation. 
m <- rowMeans(x[,2:ncol(x)], dims = 1)
s <- apply(x[,2:ncol(x)],1,sd)

#Get our normalised training set.
Train <- data.frame(y,(x[,2:ncol(x)] - m) / (s+0.1))

#set up an index and permute the training set.
index <- 1:nrow(Train)
permIndex <- sample(index)

Train <- Train[permIndex,]

Train$intercept = 1


#Do the same for our test set. Set this up as a new function to retrieve the training / test data.
Y <- readMNIST(image = "R/ex1/t10k-images.idx3-ubyte", pred = "R/ex1/t10k-labels.idx1-ubyte")

x <- Y[Y$y == 1 | Y$y == 0,]
y <- x[,1]

#shift the data by the mean and scale according to the standard deviation. 
m <- rowMeans(x[,2:ncol(x)], dims = 1)
s <- apply(x[,2:ncol(x)],1,sd)

#Get our normalised training set.
Test <- data.frame(y,(x[,2:ncol(x)] - m) / (s+0.1))

Test$intercept = 1


#test <- read('t10k')
#list(train=train, test=test)



# To visualise the data.
#                to.read <- file("R/ex1/train-images.idx3-ubyte", "rb")
#                to.pred <- file("R/ex1/train-labels.idx1-ubyte", "rb")
#                
#                # read the header. 2051 images, 28 rows, 28 columns per image.
#                readBin(to.read, integer(), n=4, endian="big")
#                readBin(to.pred, integer(), n=1, endian="big")
#                
#                # read this data into a matrix.
#                m <- matrix(readBin(to.read,integer(), size=1, n=28*28, endian="big"),28,28)
#                
#                #flip it to make it readable.
#                m <- apply(m,2,rev)
#                m <- apply(m,1,rev)
#                m <- apply(m,1,rev)
#                
#                #have a look at the image.
#                image(m)

return(Train)
}

#reusing x and y... This should be changed.



