require(fImport)

# Fetch the data from yahooImport
fetchData<-function(stocks, ndays=365, freq="daily")
{
	myData<-c()
	for(symbol in stocks)
	{
		tmp<-0
		try(tmp<-yahooSeries(symbol, nDaysBack=ndays, frequency=freq))
		if(is.timeSeries(tmp)) myData<-cbind(myData, tmp)
		Sys.sleep(1)
	}
	colnames(myData)<-gsub(".Adj.Close", ".Adjusted", colnames(myData))
	myData
}

# This removes columns if all rows in that column is NA. It removes a row if any column in that row is NA.
removeNA<-function(data)
{
	x<-data
	na.col<-apply(is.na(x), 2, all)
	if(length(na.col) > 0) x<-x[, !na.col]
	na.row<-apply(is.na(x), 1, any)
	if(length(na.row) > 0) x<-x[!na.row, ]
	x
}