require(quantmod)
require(nnet)

source('dataImportUtility.R')

# Fetch and process data
myData<-fetchData('abb.st')
myCl<-Cl(myData)
myDataset<-data.frame(myCl, lag(myCl, 1), lag(myCl, 2), lag(myCl, 3), lag(myCl, 4), 
	lag(myCl, 5), lag(myCl, 6), lag(myCl, 7), lag(myCl, 8), lag(myCl, 9), 
	lag(myCl, 10), lag(myCl, 11), lag(myCl, 12))
myDataset<-myDataset[-c(1:12), ]

# Build a model
lmfit<-lm(abb.st.Close ~ ., data=myDataset)
lmfit2<-step(lmfit)

df<-data.frame(Target=myDataset[, 1], Predicted=predict(lmfit2))

