source('chartsGenerator.R')
source('taScreeners.R')

mySymbols<-scan('SymbolsYahoo.csv', what=character())
myData<-fetchData(mySymbols, 360)
#myData<-readSeries('data/data_1year_yahoo_symbols.csv', sep=',')

# Generate all charts from the symbols
generateCharts(mySymbols, myData, path="charts/")

# Screen all the stocks
myScreenV<-taScreenerValues(mySymbols, myData)
myScreenS<-taScreenerSignal(mySymbols, myData)

