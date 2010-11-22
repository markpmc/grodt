# This should maybe be positive a longer time? Perhaps all the way until we hit 50?
rsiSignal<-function(x, params=c(21, 30, 70))
{
	ret<-rep(0, length(x))
	overSold<-params[2]
	overBought<-params[3]
	y<-RSI(x, params[1])
	y[is.na(y)]<-50
	ret[y<overSold]<-1
	ret[y>overBought]<--1
	ret
}

smaSignal<-function(x, params=c(30,100))
{
	ret<-rep(0, length(x))
	d<-SMA(x, n=params[1])-SMA(x, n=params[2])
	d<-ifelse(d<0,-1,1)
	d[is.na(d)]<-0
	ret<-d
	ret
}

