require(ttrTests)
source('taSignals.R')

# All of these TTR functions should return positions, i.e., return 1 as long as we are on a buy signal. Not just when the signal is issued.

smaSignal<-function(x, params=c(30,100), burn=0, short=FALSE)
{
	ret<-rep(0, length(x))
	d<-SMA(x, n=params[1])-SMA(x, n=params[2])
	d<-ifelse(d<0,0,1)
	d[is.na(d)]<-0
	ret<-d
	ret
}

# This should maybe be positive a longer time? Perhaps all the way until we hit 50?
rsiPosition<-function(x, params=c(21, 30, 70), burn=0, short=FALSE)
{
	ret<-rsiSignal(x, params)
	ret
}

# Experimental rsi testing if buying at 30 and keeping for a few days works
rsiSignal2<-function(x, params=c(21, 30, 70, 7), burn=0, short=FALSE)
{
	ret<-rep(0, length(x))
	overSold<-params[2]
	overBought<-params[3]
	y<-RSI(x, params[1])
	y[is.na(y)]<-50
	ret[y<overSold]<-1
	ret[y>overBought]<-0
	inds<-which(ret>0)
	for(i in inds) ret[seq(i,(i+params[4]))]<-1
	ret
}

macdSignal<-function(x, params=c(12, 26, 9), burn=0, short=FALSE)
{
	ret<-rep(0, length(x))
	y<-MACD(as.vector(x), params[1], params[2], params[3])
	y<-y[, "macd"]-y[, "signal"]
	d<-ifelse(y<0,0,1)
	d[is.na(d)]<-0
	ret<-d
	ret
}

bollingerSignal<-function(x, params=c(20, 2), burn=0, short=FALSE)
{
	ret<-rep(0, length(x))
	y<-BBands(x, n=params[1], sd=params[2])
	ret[x>y[,"up"]]<-0
	ret[x<y[,"dn"]]<-1
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


