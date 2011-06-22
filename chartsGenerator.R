source('dataImportUtility.R')
require(quantmod)

generateChart<-function(stock, fname)
{
	require(quantmod)
	png(paste(fname, ".png", sep=""), width=1280, height=600, pointsize=19)
	#try(chartSeries(stock, name=fname, TA=c(addBBands(), addRSI(21), addMFI(21), addROC(10), addWMA(30), addWMA(100), addOBV(), addTDI())))
	try(chartSeries(stock, name=fname, TA=c(addBBands(), addRSI(21), addMFI(21), addROC(10), addSMA(30), addSMA(100), addVo())))
	dev.off()
}

generateCharts<-function(stocks, mydat, path='charts')
{
	# Delete old charts
	if(file.exists(path)) unlink(path, recursive=TRUE)
	dir.create(path)
	# Generate new charts
	for(stockName in stocks){
		cols<-grep(stockName, colnames(mydat))
		generateChart(mydat[, cols], paste(path, "/", stockName, sep=""))
	}
}

