require(quantmod)
require(fImport)

source('dataImportUtility.R')

# Load the data online
myts<-yahooSeries('^OMX', from="2005-01-01", to="2010-12-31")
myts<-fixColnames(myts)
myxts<-as.xts(myts)

# Convert to monthly and quarterly
myMonthly<-Cl(to.monthly(myxts))
myQuarterly<-Cl(to.quarterly(myxts))

# Decompose into trend, seasonality and irregular
stlMonthly<-stl(ts(as.vector(myMonthly), start=c(2005, 01), freq=12), s.window="per")
stlQuarterly<-stl(ts(as.vector(myQuarterly), start=c(2005, 1), freq=4), s.window="per")

# Plot the monthly seasonality
png(file="Omxs30 monthly seasonality.png")
barplot(stlMonthly[[1]][, "seasonal"][1:12], name=month.name, las=2, main="Monthly Seasonality of the OMXS30 Index", ylab="Index value")
dev.off()

png(file="Omxs30 quarterly seasonality.png")
barplot(stlQuarterly[[1]][, "seasonal"][1:4], name=c("Q1", "Q2", "Q3", "Q4"), main="Quarterly Seasonality of the OMXS30 Index", ylab="Index value")
dev.off()
