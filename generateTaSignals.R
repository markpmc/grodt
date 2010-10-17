require(ttrTests)

smaSignal<-function(x, params=c(30,100), burn=0, short=FALSE)
{
	ret<-rep(0, length(x))
	d<-SMA(x, n=params[1])-SMA(x, n=params[2])
	d<-ifelse(d<0,-1,1)
	d<-diff(d)
	ret[d<0]<--1
	ret[d>0]<-1
	ret
}

rsiSignal<-function(x, params=c(21, 30, 70), burn=0, short=FALSE)
{
	ret<-rep(0, length(x))
	overSold<-params[2]
	overBought<-params[3]
	y<-RSI(x, params[1])
	ret[y<overSold]<-1
	ret[y>overBought]<--1
	ret
}

macdSignal<-function(x, params=c(12, 26, 9), burn=0, short=FALSE)
{
	ret<-rep(0, length(x))
	y<-MACD(x, params[1], params[2], params[3])
	y<-y[, "macd"]-y[, "signal"]
	d<-ifelse(y<0,-1,1)
	d<-diff(d)
	ret[d<0]<--1
	ret[d>0]<-1
	ret
}

# Not done, and not working. Need more work
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


