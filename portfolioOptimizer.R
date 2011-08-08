require(fPortfolio)
require(quantmod)

source('dataImportUtility.R')
source('dataUtility.R')

getRollingWeights<-function(myret, Spec, Constraints)
{
	a<-rollingWindows(myReturns, period="3m", by="1m")
	b<-rollingTangencyPortfolio(myReturns, Spec, Constraints, from=a$from, to=a$to)
	myWeights<-getWeights(b[[1]]@portfolio)
	for(i in 2:length(b)){
		tmp<-getWeights(b[[i]]@portfolio)
		myWeights<-rbind(myWeights, tmp)
	}
	rownames(myWeights)<-as.character(a$from)
	myWeights
}

mySymbols<-c('jm.st', 'hm.st', 'noki-sek.st', 'par-sek.st')
mySymbols<-scan('SymbolsYahoo.csv', what=character())
mySymbols<-scan('OMXS30SymbolsYahoo.csv', what=character())

# Load the data
#myData<-fetchData(mySymbols, 365, "daily")
#myData<-Cl(myData)
#colnames(myData)<-gsub(".Close", "", colnames(myData))
#myData<-apply(myData, 2, interpolateNA)
#myData<-removeNA(myData)

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
