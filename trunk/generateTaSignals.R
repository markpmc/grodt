require(ttrTests)

sma30100<-function(x, params, burn=0, short=FALSE)
{
	ret<-rep(0, length(x))
	d<-100-30
	inds<-which(SMA(x[-(1:d)], n=30)>SMA(x, n=100))
	ret[inds+d-1]<-1
	ret
}

magicTTR<-function(x, params, burn=0, short=FALSE)
{
	ret<-rep(0, length(x))
	smaShort<-30
	smaLong<-100
	rsiPar<-50
	d<-smaLong-smaShort
	xsmall<-x[-c(1:d)]
	mySma<-SMA(xsmall, n=smaShort) - SMA(x, n=smaLong)
	myMacd<-macd4(x[-c(1:(smaLong-1))])
	myRsi<-RSI(x, 21)
	myRsi<-myRsi[-c(1:(smaLong-1))]
	inds<-intersect(intersect(which(mySma>0), which(myMacd>0)), which(myRsi<rsiPar))
	ret[inds+d-1]<-1
	ret
}


