require(fImport)
require(fPortfolio)
require(quantmod)

source('dataImportUtility.R')

mySymbols<-c('lupe.st', 'bets-b.st', 'bp', 'abb.st', 'eric-b.st', 'fing-b.st', 'msft', 'noki-sek.st', 'par-sek.st', 'prec.st', 'pve.st', 'tel2-b.st')

# Load the data online or offline
#myData<-fetchData(mySymbols, 365)
myData<-readSeries('data/omxs30_10Years.csv', sep=',')

# Get the log returns
myReturns<-returns(Cl(myData))
# Add day of week and convert to data frame
myDf<-as.data.frame(myReturns)
myDf<-cbind(myDf, Day=weekdays(as.Date(rownames(myReturns))))
myDf<-cbind(myDf, Month=months(as.Date(rownames(myReturns))))
myDf<-cbind(myDf, Quarter=quarters(as.Date(rownames(myReturns))))
# Calculate the average return per weekday
dayStats<-stats::aggregate(myDf$bets.b.st.Close, list(Day=myDf$Day), mean)
monthStats<-stats::aggregate(myDf$bets.b.st.Close, list(Month=myDf$Month), mean)
quarterStats<-stats::aggregate(myDf$bets.b.st.Close, list(Quarter=myDf$Quarter), mean)

