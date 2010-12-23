require(fImport)

# Fetch the data from yahooImport
fetchData<-function(stocks, ndays=365, freq="daily")
{
	myData<-c()
	for(symbol in stocks)
	{
		tmp<-yahooSeries(symbol, nDaysBack=ndays, frequency=freq)
		myData<-cbind(myData, tmp)
		Sys.sleep(1)
	}
	colnames(myData)<-gsub(".Adj.Close", ".Adjusted", colnames(myData))
	myData
}
