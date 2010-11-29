require(fImport)
require(fPortfolio)
require(quantmod)

source('dataImportUtility.R')
source('taSignals.R')

mySymbols<-c("ABB.ST", "ALFA.ST", "ASSA-B.ST", "AZN.ST", "ATCO-A.ST", "ATCO-B.ST", "BOL.ST", "ELUX-B.ST", "ERIC-B.ST",
	"GETI-B.ST", "HMB.ST", "INVE-B.ST", "LUPE.ST", "MTG-B.ST", "NOKI-SEK.ST", "NDA-SEK.ST", "SAND.ST", "SCA-B.ST",
	"SCV-B.ST", "SEB-A.ST", "SECU-B.ST", "SKA-B.ST", "SKF-B.ST", "SSAB-A.ST", "SHB-A.ST", "SWED-A.ST", "SWMA.ST",
	"TEL2-B.ST", "TLSN.ST", "VOLV-B.ST")  

# Load the data from disk
#myData<-readSeries('data/omxs30_10Years.csv', sep=',')
#myData<-removeNA(Cl(myData))

# Load the data online
myData<-fetchData(mySymbols, 365)
myData<-removeNA(Cl(myData))
#myReturns<-returns(Cl(myData))

# Analyze the data
colNames<-gsub(".Close", "", colnames(myData))
nRows<-nrow(myData)
nCols<-ncol(myData)
interestingStocks<-data.frame(Symbol=character(0), RSI=numeric(0), MACD=numeric(0), SMA=numeric(0), 
	Interesting=character(0))
buySellDf<-data.frame(Symbol=character(0), RSI=character(0), MACD=character(0), SMA=character(0))

for(i in 1:nCols){
	closePrices<-myData[, i]
	
	# RSI
	rsiIndicator<-RSI(closePrices, 21)[nRows]
	rsiBuySell<-"Sell"
	if(rsiIndicator >= 40 && rsiIndicator <= 60) rsiBuySell<-"Neutral"
	if(rsiIndicator <= 30) rsiBuySell<-"Buy"
	
	# MACD
	macdIndicator<-MACD(as.vector(closePrices), 30, 100, 9)
	macdIndicator<-macdIndicator[nRows, "macd"]-macdIndicator[nRows, "signal"]
	macdBuySell<-"Sell"
	if(macdIndicator > 0) macdBuySell<-"Buy"
	
	# SMA
	smaIndicator<-SMA(closePrices, 30)[nRows]/SMA(closePrices, 100)[nRows]
	smaBuySell<-"Sell"
	if(smaIndicator>1) smaBuySell<-"Buy"
	
	interesting<-"No"
	if(rsiIndicator <= 30 || rsiIndicator >= 70) interesting<-"Yes"
	interestingStocks<-rbind(interestingStocks, 
		data.frame(Symbol=as.character(colNames[i]), RSI=rsiIndicator, MACD=macdIndicator, SMA=smaIndicator, Interesting=interesting))
	buySellDf<-rbind(buySellDf, data.frame(Symbol=as.character(colNames[i]), RSI=rsiBuySell, MACD=macdBuySell, SMA=smaBuySell))
}

