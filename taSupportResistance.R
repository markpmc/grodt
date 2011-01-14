library(quantmod)
source('dataImportUtility.R')

getSupportResistanceLines<-function(stock, howmany=3)
{
	a<-hist(stock, plot=FALSE)
	prices<-a$mids[order(a$counts)]
	ret<-prices[(length(prices)-howmany+1):length(prices)]
	ret
}

stock<-fetchData('SWED-A.ST', 500)
stock<-Cl(stock)
chartSeries(stock, log.scale=TRUE)
abline(h=getSupportResistanceLines(stock, 4), col='red')
