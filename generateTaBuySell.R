require(fPortfolio)
require(quantmod)

source('dataImportUtility.R')
source('taSignals.R')

mySymbols<-scan('SymbolsYahoo.csv', what=character())

# Load the data from disk
#myData<-readSeries('data/omxs30_10Years.csv', sep=',')
#myData<-removeNA(Cl(myData))

# Load the data online
#myData<-fetchData(mySymbols, 365)
#a<-myData
myData<-Cl(myData)

# Analyze the data
colNames<-gsub(".Close", "", colnames(myData))
nCols<-ncol(myData)
interestingStocks<-data.frame(Symbol=character(0), RSI=numeric(0), MACD=numeric(0), SMA=numeric(0), 
	Volatility=numeric(0), Interesting=character(0))
buySellDf<-data.frame(Symbol=character(0), RSI=character(0), MACD=character(0), SMA=character(0))
nDays<-1
for(i in 1:nCols){
	closePrices<-myData[, i]
	closePrices<-removeNA(closePrices)
	if(nrow(closePrices)==0) next
	
	# RSI
	rsiIndicator<-last(RSI(closePrices, 21), nDays)
	rsiBuySell<-"Sell"
	if(rsiIndicator >= 40 && rsiIndicator <= 60) rsiBuySell<-"Neutral"
	if(rsiIndicator <= 30) rsiBuySell<-"Buy"
	
	# MACD
	macdIndicator<-last(MACD(as.vector(closePrices), 12, 26, 9), nDays)
	macdIndicator<-macdIndicator["macd"]-macdIndicator["signal"]
	macdBuySell<-"Sell"
	if(macdIndicator > 0) macdBuySell<-"Buy"
	
	# SMA
	smaIndicator<-last(SMA(closePrices, 30), nDays)/last(SMA(closePrices, 100), nDays)
	smaBuySell<-"Sell"
	if(smaIndicator>1) smaBuySell<-"Buy"
	
	# Volatility
	volIndicator<-last(TTR::volatility(closePrices, n=22), nDays)
	
	interesting<-"No"
	if(rsiIndicator <= 30 || rsiIndicator >= 70) interesting<-"Yes"
	interestingStocks<-rbind(interestingStocks, 
		data.frame(Symbol=as.character(colNames[i]), RSI=rsiIndicator, MACD=macdIndicator, 
		SMA=smaIndicator, Volatility=volIndicator, Interesting=interesting))
	buySellDf<-rbind(buySellDf, data.frame(Symbol=as.character(colNames[i]), RSI=rsiBuySell, MACD=macdBuySell, 
		SMA=smaBuySell, Volatility=volIndicator))
}

