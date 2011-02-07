require(quantmod)
require(nnet)

source('dataImportUtility.R')


1 2 3 4 5 6 7
  2 3 4 5 6 7 8
    3 4 5 6 7 8 9
 
# predict rolling
rollingPredict<-function(model, data, lags)
{
	nstart<-max(lags)+1
	data[nstart:length(data)]<-0
	df<-data.frame(lag(data, k=lags))
	colnames(df)<-paste("X", lags, sep="")
	
	for(i in nstart:length(data)){
		df<-data.frame(lag(lags[]))
	}
}

plotPredicted<-function(df)
{
	plot(df$Target, type='l')
	lines(df$Predicted, type='l', col='red')
}

# Fetch and process data
#myData<-fetchData('hmb.st', 180)
myCl<-Cl(myData)
myDataset<-data.frame(lag(myCl, k=0:12))
colnames(myDataset)<-c("Y", paste("X", c(1:12), sep=""))
myDataset<-myDataset[-c(1:12), ]


# Build a model
subInds<-c(1:100)
lmfit<-lm(Y ~ ., data=myDataset, subset=subInds)
lmfit2<-step(lmfit)

# Fitted vs. Predicted
fitPredDf<-data.frame(Target=myDataset[subInds, 1], Predicted=predict(lmfit2))
predSingDf<-data.frame(Target=myDataset[, 1], Predicted=predict(lmfit2, new=myDataset))
