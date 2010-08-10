require(fImport)

# Write the data out to a file
writeData<-function(mydat, fname)
{
	write.csv(mydat, file=fname)
}

# Fetch the data from yahooImport
fetchData<-function(stocks, ndays=365)
{
	myData<-c()
	for(symbol in stocks)
	{
		tmp<-yahooSeries(symbol, nDaysBack=ndays)
		myData<-cbind(myData, tmp)
		Sys.sleep(1)
	}
	colnames(myData)<-gsub(".Adj.Close", ".Adjusted", colnames(myData))
	myData
}



