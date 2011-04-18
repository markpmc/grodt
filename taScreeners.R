taScreenerValues<-function(symbols, mydata)
{
	require(TTR)
	require(quantmod)	
	# Remove missing values
	myData<-removeNA(mydata)
	myClose<-Ad(myData)
	myVolume<-Vo(myData)

	# Analyze the data
	colNames<-gsub(".Adjusted", "", colnames(myClose))
	nCols<-ncol(myClose)
	stockTaData<-data.frame(Symbol=character(nCols), RSI=numeric(nCols), MACD=numeric(nCols), SMA=numeric(nCols), MOM=numeric(nCols),
	Volatility=numeric(nCols), Liquidity=numeric(nCols), Interesting=character(nCols), stringsAsFactors=FALSE)

	for(i in 1:nCols){
		ohlcPrices<-myData[, grep(colNames[i], colnames(myData))]
		liq<-myVolume[, grep(colNames[i], colnames(myVolume))]
		closePrices<-myClose[, i]
		closePrices<-removeNA(closePrices)
		if(nrow(closePrices)==0) next
		
		# RSI
		rsiIndicator<-last(RSI(closePrices, 21))
		# MACD
		macdIndicator<-last(MACD(closePrices, 12, 26, 9))
		# SMA
		smaIndicator<-last(TTR::SMA(closePrices, 30) - TTR::SMA(closePrices, 100))
		# Momentum (ROC)
		momIndicator<-last(ROC(closePrices, 10))
		# Volatility
		volIndicator<-last(TTR::volatility(ohlcPrices, n=22))
		# Liquidity risk
		liqRisk<-last(liq)
	
		interesting<-"No"
		if(rsiIndicator <= 30 || rsiIndicator >= 70) interesting<-"Yes"
		stockTaData[i,]<-data.frame(Symbol=as.character(colNames[i]), RSI=rsiIndicator, MACD=macdIndicator, 
			SMA=smaIndicator, MOM=momIndicator, Volatility=volIndicator, Liquidity=liqRisk, Interesting=interesting, stringsAsFactors=FALSE)
	}
	stockTaData
}

taScreenerSignal<-function(symbols, mydata)
{
	require(TTR)
	require(quantmod)	
	# Remove missing values
	myData<-removeNA(mydata)
	myClose<-Ad(myData)
	myVolume<-Vo(myData)

	# Analyze the data
	colNames<-gsub(".Adjusted", "", colnames(myClose))
	nCols<-ncol(myClose)
	stockTaData<-data.frame(Symbol=character(nCols), RSI=numeric(nCols), MACD=numeric(nCols), SMA=numeric(nCols), MOM=numeric(nCols),
	Volatility=numeric(nCols), Liquidity=numeric(nCols), Interesting=character(nCols), stringsAsFactors=FALSE)

	for(i in 1:nCols){
		ohlcPrices<-myData[, grep(colNames[i], colnames(myData))]
		liq<-myVolume[, grep(colNames[i], colnames(myVolume))]
		closePrices<-myClose[, i]
		closePrices<-removeNA(closePrices)
		if(nrow(closePrices)==0) next
		
		# RSI
		tmp<-last(RSI(closePrices, 21))
		rsiIndicator<-ifelse(tmp<=30, 1, ifelse(tmp>=70, -1, 0))
		
		# MACD
		tmp<-last(MACD(closePrices, 12, 26, 9))
		macdIndicator<-ifelse(tmp<=0, -1, 1)
		# SMA
		tmp<-last(TTR::SMA(closePrices, 30) - TTR::SMA(closePrices, 100))
		smaIndicator<-ifelse(tmp<0,-1,1)
		# Momentum (ROC)
		tmp<-last(ROC(closePrices, 10))
		momIndicator<-ifelse(tmp<0,-1,1)
		# Volatility
		volIndicator<-last(TTR::volatility(ohlcPrices, n=22))
		# Liquidity risk
		liqRisk<-last(liq)
	
		interesting<-""
		stockTaData[i,]<-data.frame(Symbol=as.character(colNames[i]), RSI=rsiIndicator, MACD=macdIndicator, 
			SMA=smaIndicator, MOM=momIndicator, Volatility=volIndicator, Liquidity=liqRisk, Interesting=interesting, stringsAsFactors=FALSE)
	}
	stockTaData
}

