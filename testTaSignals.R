require('ttrTests')
require('quantmod')
require('timeSeries')

# Plot the financial time series and the buy and sell signals indicated by +1 and -1 respectively
plotSignal<-function(x, signal)
{
	#chartSeries(x, TA=c(addMACD(30,100,15),addBBands(),addRSI(21)))
	chartSeries(x, TA=c(addBBands(),addRSI(21),addMomentum(10)))
	#abline(v=which(signal<0), col="red")
	abline(v=which(signal>0), col="green", lty="dotted")
}

source('taSignals.R')
source('dataImportUtility.R')

mydata<-readSeries('data/omxs30_10Years.csv', sep=',')
myclose<-removeNA(Cl(mydata))

stock<-myclose[, "AZN.ST.Close"]
stock<-as.xts(stock)
#stock<-as.xts(stock[300:400])
plotSignal(stock, diff(rsiSignal(stock, params=c(21,30,70))))
#plotSignal(stock, diff(macdSignal(stock, params=c(30,100,15))))
#plotSignal(stock, diff(smaSignal(stock, params=c(30,100))))
#plotSignal(stock, diff(bollingerSignal(stock, params=c(20,2))))
plotSignal(stock, diff(rsiSignalWithMomentum(stock, params=c(12,30,70,12,10))))

# Check statistical validity this function requires a vector or a timeSeries with "Close" attribute
returnStats(as.vector(stock), ttr=rsiSignalWithMomentum, params=c(12, 30, 70, 12, 10))
