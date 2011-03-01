require(fAssets)

source('dataImportUtility.R')

mySymbols<-scan('SymbolsYahoo.csv', what=character())

# Load the data from disk
#myData<-readSeries('data/omxs30_10Years.csv', sep=',')
# Load the data online
myData<-fetchData(mySymbols, 365)

# Use only Close prices and remove missing values
myClose<-removeNA(myData)
myClose<-Cl(myClose)

# Build a correlation tree and arrange the securities in that order and select the top 10
hc<-assetsSelect(myClose)
myClose<-myClose[, assetsArrange(myClose, "hclust")]
mySelected<-myClose[, 1:10]
print(colnames(mySelected))
