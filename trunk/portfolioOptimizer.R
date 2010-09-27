require(fImport)
require(fPortfolio)
require(quantmod)

source('dataImportUtility.R')

mySymbols<-c('bets-b.st', 'bp', 'abb.st', 'eric-b.st', 'fing-b.st', 'msft', 'noki-sek.st', 'par-sek.st', 'prec.st', 'pve.st', 'tel2-b.st')

# Load the data
myData<-fetchData(mySymbols, 365)
myData<-removeNA(Cl(myData))
myReturns<-returns(Cl(myData))

# Settings for the portfolio optimizer
Spec = portfolioSpec()
setTargetReturn(Spec) = mean(colMeans(myReturns))
Constraints = "LongOnly"

efport<-efficientPortfolio(myReturns, Spec, Constraints)
tanport<-tangencyPortfolio(myReturns, Spec, Constraints)
minvarport<-minvariancePortfolio(myReturns, Spec, Constraints)
portfront<-portfolioFrontier(myReturns, Spec, Constraints)
