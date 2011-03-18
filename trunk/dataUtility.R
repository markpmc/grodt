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

