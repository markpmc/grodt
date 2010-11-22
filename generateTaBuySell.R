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
myData<-readSeries('data/omxs30_10Years.csv', sep=',')
myData<-removeNA(Cl(myData))

# Load the data online
#myData<-fetchData(mySymbols, 365)
#myData<-removeNA(Cl(myData))
#myReturns<-returns(Cl(myData))

# Analyze the data
colNames<-gsub(".Close", "", colnames(myData))
nRows<-nrow(myData)
nCols<-ncol(myData)
interestingStocks<-data.frame(Symbol=factor(nCols, levels=colNames), RSI=numeric(nCols), MACD=numeric(nCols), SMA=numeric(nCols), 
	Interesting=factor(nCols, levels=c("Yes", "No")))

for(i in 1:nCols){
	closePrices<-myData[, i]
	
	# RSI
	rsiIndicator<-RSI(closePrices, 21)[nRows]
	
	# MACD
	macdIndicator<-MACD(as.vector(closePrices), 30, 100, 9)
	macdIndicator<-macdIndicator[nRows, "macd"]-macdIndicator[nRows, "signal"]
	
	# SMA
	smaIndicator<-SMA(closePrices, 30)[nRows]/SMA(closePrices, 100)[nRows]
	
	interesting<-"No"
	if(rsiIndicator <= 30 || rsiIndicator >= 70) interesting<-"Yes"

	interestingStocks[i, ]<-cbind(Symbol=as.character(colNames[i]), RSI=rsiIndicator, MACD=macdIndicator, SMA=smaIndicator, Interesting=interesting)	
}

