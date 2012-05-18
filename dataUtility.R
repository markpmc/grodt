getStock<-function(name, data)
{
  ret<-data[,grep(name, colnames(data))]
  ret
}

# Finds and stores the distribution of the number of consecutive ups and downs over the x period
# x should typically be a log return series of a stock
findDownUpDistributions<-function(x)
{
	pos<-numeric(0)
	neg<-numeric(0)
	cnt<-1
	for(i in 2:length(x)){
		xp<-x[i-1]
		xn<-x[i]
		if(xn*xp < 0){ #different signs
			if(xp < 0) neg<-c(neg, cnt)
			else pos<-c(pos, cnt)
			cnt<-1
		}else
			cnt<-cnt+1
	}
	if(x[length(x)] < 0) neg<-c(neg, cnt)
	else pos<-c(pos, cnt)
	list(Pos=pos, Neg=neg)
}


# Find all NA and do a linear interpolation of them
interpolateNA<-function(x)
{
	#stopifnot(any(is.data.frame(x), is.xts(x), is.matrix(x)))
	inds<-which(is.na(x))
	if(length(inds)>0) try({x[inds]<-approx(x, xout=inds)$y})
	x
}

# This removes columns if all rows in that column is NA. It removes a row if any column in that row is NA.
removeNA<-function(data)
{
	x<-data
	na.col<-apply(is.na(x), 2, all)
  if(all(na.col)) return(NULL)
	if(length(na.col) > 0) x<-x[, !na.col]
	na.row<-apply(is.na(x), 1, any)
	if(length(na.row) > 0) x<-x[!na.row, ]
	x
}

# Create a time lagged dataset for autoregressive prediction
createTimeLaggedDataSet<-function(x, lags)
{
	mydf<-data.frame(lag(x, k=c(0,lags)))
	colnames(mydf)<-c("Y", paste("X", lags, sep=""))
	mydf<-mydf[-lags, ]
	mydf
}
