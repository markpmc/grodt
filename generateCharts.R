require(TTR)
require(quantmod)

source('dataImportUtility.R')

generateChart<-function(stock, fname)
{
	png(paste(fname, ".png", sep=""), width=1280, height=600, pointsize=19)
	#try(chartSeries(stock, name=fname, TA=c(addBBands(), addRSI(21), addMFI(21), addROC(10), addWMA(30), addWMA(100), addOBV(), addTDI())))
	try(chartSeries(stock, name=fname, TA=c(addBBands(), addRSI(21), addMFI(21), addROC(10), addWMA(30), addWMA(100), addTDI(), addVo())))
	dev.off()
}

mySymbols<-scan('SymbolsYahoo.csv', what=character())

# Load the data
#myData<-readSeries('data/data_1year_yahoo_symbols.csv', sep=',')
#myData<-fetchData(mySymbols, 360)

# Delete old charts
if(file.exists("charts")) unlink("charts", recursive=TRUE)
dir.create("charts")

for(stockName in mySymbols){
	cols<-grep(stockName, colnames(myData))
	generateChart(myData[, cols], paste("charts/", stockName, sep=""))
}


