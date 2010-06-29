require(fImport)

omxs30Symbols<-c('ABB.ST', 'ALFA.ST', 'ASSA-B.ST', 'AZN.ST', 'ATCO-A.ST', 'ATCO-B.ST', 'BOL.ST', 'ELUX-B.ST', 'ERIC-B.ST', 'GETI-B.ST', 'HMB.ST', 'INVE-B.ST', 'LUPE.ST', 'MTG-B.ST', 'NOKI-SEK.ST', 'NDA-SEK.ST', 'SAND.ST', 'SCA-B.ST', 'SCV-B.ST', 'SEB-A.ST', 'SECU-B.ST', 'SKA-B.ST', 'SKF-B.ST', 'SSAB-A.ST', 'SHB-A.ST', 'SWED-A.ST', 'SWMA.ST', 'TEL2-B.ST', 'TLSN.ST', 'VOLV-B.ST')

loadData<-function(stocks)
{
	ret<-yahooSeries(stocks, nDaysBack=366)
	ret
}

writeData<-function(mydat)
{
	write.csv(mydat, file="omxs30.csv")
}

# Load the data
myData<-loadData(omxs30Symbols)
writeData(myData)

