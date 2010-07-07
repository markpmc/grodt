require(ttrTests)

sma30100<-function(x, params, burn=0, short=FALSE)
{
	ret<-rep(0, length(x))
	inds<-which(SMA(x, n=30)>SMA(x, n=100))
	ret[inds]<-1
	ret
}
