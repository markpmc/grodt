require(fPortfolio)
require(quantmod)

source('dataImportUtility.R')

mySymbols<-c('eric-b.st', 'msft', 'noki-sek.st', 'par-sek.st')

# Load the data
myData<-fetchData(mySymbols, 365, "daily")
myData<-removeNA(Cl(myData))

myReturns<-returns(Cl(myData))

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
