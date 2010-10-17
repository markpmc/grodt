require('ttrTests')
require('quantmod')
require('timeSeries')

plotSignal<-function(x, signal)
{
	plot(x, type="l")
	abline(v=which(signal<0), col="red")
	abline(v=which(signal>0), col="green")
}


source('generateTaSignals.R')
source('dataImportUtility.R')

mydata<-readSeries('data/omxs30_10Years.csv', sep=',')
mydata<-removeNA(Cl(mydata))

returnStats(mydata$ABB.ST.Close)
