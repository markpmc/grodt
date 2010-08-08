require(fImport)

omxs30Symbols<-c('ABB.ST', 'ALFA.ST', 'ASSA-B.ST', 'AZN.ST', 'ATCO-A.ST', 'ATCO-B.ST', 'BOL.ST', 'ELUX-B.ST', 'ERIC-B.ST', 'GETI-B.ST', 'HMB.ST', 'INVE-B.ST', 'LUPE.ST', 'MTG-B.ST', 'NOKI-SEK.ST', 'NDA-SEK.ST', 'SAND.ST', 'SCA-B.ST', 'SCV-B.ST', 'SEB-A.ST', 'SECU-B.ST', 'SKA-B.ST', 'SKF-B.ST', 'SSAB-A.ST', 'SHB-A.ST', 'SWED-A.ST', 'SWMA.ST', 'TEL2-B.ST', 'TLSN.ST', 'VOLV-B.ST')


writeData<-function(mydat)
{
	write.csv(mydat, file="omxs30.csv")
}

fetchData<-function(stocks)
{
	myData<-c()
	for(symbol in omxs30Symbols)
	{
		tmp<-yahooSeries(symbol, nDaysBack=3660)
		myData<-cbind(myData, tmp)
		Sys.sleep(1)
	}
	colnames(myData)<-gsub(".Adj.Close", ".Adjusted", colnames(myData))
	myData
}

# Load the data
myData<-fetchData(omxs30Symbols)
writeData(myData)

