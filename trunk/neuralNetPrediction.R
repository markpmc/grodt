require(quantmod)
require(nnet)

source('dataImportUtility.R')


#1 2 3 4 5 6 7
#  2 3 4 5 6 7 8
#    3 4 5 6 7 8 9
 
# predict rolling
iteratedPredict<-function(model, obs, test, lags)
{
	nstart<-max(lags)+1
	pred<-obs
	pred[nstart:length(pred)]<-0
	for(i in nstart:length(pred)){
		mydf<-data.frame(rbind(pred[c(i-lags)]))
		colnames(mydf)<-paste("X", lags, sep="")
		pred[i]<-predict(model, newdata=mydf)
	}
	mydf<-data.frame(Target=as.numeric(obs), Predicted=as.numeric(pred))
	mydf
}

plotPredicted<-function(df)
{
	plot(df$Target, type='l')
	lines(df$Predicted, type='l', col='red')
}

# Fetch and process data
#myData<-fetchData('hmb.st', 180)
myCl<-Cl(myData)
myDataset<-data.frame(lag(myCl, k=0:20))
colnames(myDataset)<-c("Y", paste("X", c(1:20), sep=""))
myDataset<-myDataset[-c(1:20), ]


# Build a model
subInds<-c(1:100)
lmfit<-lm(Y ~ ., data=myDataset, subset=subInds)
#lmfit2<-step(lmfit)

# Fitted vs. Predicted
fitPredDf<-data.frame(Target=myDataset[subInds, 1], Predicted=predict(lmfit2))
predSingDf<-data.frame(Target=myDataset[, 1], Predicted=predict(lmfit2, new=myDataset))
predIteratedDf<-iteratedPredict(lmfit2, myCl, 0, c(1:20))

# Neural network
