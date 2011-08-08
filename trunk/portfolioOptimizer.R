require(fPortfolio)
require(quantmod)

source('dataImportUtility.R')

mySymbols<-c('jm.st', 'hm.st', 'noki-sek.st', 'par-sek.st')
mySymbols<-scan('SymbolsYahoo.csv', what=character())
mySymbols<-scan('OMXS30SymbolsYahoo.csv', what=character())

# Load the data
myData<-fetchData(mySymbols, 365, "daily")
myData<-Cl(myData)
colnames(myData)<-gsub(".Close", "", colnames(myData))
myData<-apply(myData, 2, interpolateNA)
myData<-removeNA(myData)

# Get the returns
myReturns<-returns(myData)

# Settings for the portfolio optimizer
Spec = portfolioSpec()
setTargetReturn(Spec) = mean(colMeans(myReturns))
Constraints = "LongOnly"

# Optimized portfolios
#efport<-efficientPortfolio(myReturns, Spec, Constraints)
#minvarport<-minvariancePortfolio(myReturns, Spec, Constraints)
tanport<-tangencyPortfolio(myReturns, Spec, Constraints) # Generates the portfolio weigths with the optimal SharpRatio
portfront<-portfolioFrontier(myReturns, Spec, Constraints)

print(tanport)
