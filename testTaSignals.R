require('ttrTests')
require('quantmod')
require('timeSeries')

source('generateTaSignals.R')
source('dataImportUtility.R')

mydata<-readSeries('data/omxs30_10Years.csv', sep=',')
mydata<-removeNA(Cl(mydata))

returnStats(mydata$ABB.ST.Close)
