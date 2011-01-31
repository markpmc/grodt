require(TTR)
require(quantmod)
require(fTrading)

source('dataImportUtility.R')
source('taSignals.R')

mySymbols<-scan('SymbolsYahoo.csv', what=character())

# Load the data
#myData<-readSeries('data/data_1year_yahoo_symbols.csv', sep=',')
myData<-fetchData(mySymbols, 365)

# Remove missing values
myData<-removeNA(myData)
myClose<-Cl(myData)
myVolume<-Vo(myData)

# Analyze the data
colNames<-gsub(".Close", "", colnames(myClose))
nCols<-ncol(myClose)
stockTaData<-data.frame(Symbol=character(nCols), RSI=numeric(nCols), MACD=numeric(nCols), SMA=numeric(nCols), MOM=numeric(nCols),
	Volatility=numeric(nCols), Liquidity=numeric(nCols), Interesting=character(nCols), stringsAsFactors=FALSE)
nDays<-1
for(i in 1:nCols){
	ohlcPrices<-myData[, grep(colNames[i], colnames(myData))]
	liq<-myVolume[, grep(colNames[i], colnames(myVolume))]
	closePrices<-myClose[, i]
	closePrices<-removeNA(closePrices)
	if(nrow(closePrices)==0) next
	
	# RSI
	rsiIndicator<-last(rsiTA(closePrices, 21), nDays)		
	# MACD
	macdIndicator<-last(cdoTA(closePrices, 12, 26, 9), nDays)
	# SMA
	smaIndicator<-last(TTR::SMA(closePrices, 10) - TTR::SMA(closePrices, 25), nDays)
	# Momentum (ROC)
	momIndicator<-last(rocTA(closePrices, 5), nDays)
	# Volatility
	volIndicator<-last(TTR::volatility(ohlcPrices, n=22), nDays)
	# Liquidity risk
	liqRisk<-last(liq, nDays)
	
	interesting<-"No"
	if(rsiIndicator <= 0.30 || rsiIndicator >= 0.70) interesting<-"Yes"
	stockTaData[i,]<-data.frame(Symbol=as.character(colNames[i]), RSI=rsiIndicator, MACD=macdIndicator, 
		SMA=smaIndicator, MOM=momIndicator, Volatility=volIndicator, Liquidity=liqRisk, Interesting=interesting, stringsAsFactors=FALSE)
}

