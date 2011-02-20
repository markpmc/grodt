require(TTR)
require(quantmod)

source('dataImportUtility.R')

generateChart<-function(stock, fname)
{
	png(paste(fname, ".png", sep=""))
	chartSeries(stock, TA=c(addBBands(), addRSI(21), addMFI(21), addROC(10), addWMA(30), addWMA(100), addOBV(), addTDI()))
	dev.off()
}

mySymbols<-scan('SymbolsYahoo.csv', what=character())

# Load the data
#myData<-readSeries('data/data_1year_yahoo_symbols.csv', sep=',')
myData<-fetchData(mySymbols, 360)

for(stockName in mySymbols){
	#browser()
	cols<-grep(stockName, colnames(myData))
	try(generateChart(myData[, cols], stockName))
}


