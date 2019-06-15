def HighPerformanceComputing(n,X,S):
	mini = min(X)
	sumi=0
	j=0
	for i in range(0,n):
		if(X[i]==mini):
			j=i
		if(X[i]>=S[i-j]):
			sumi+=S[i-j]
		else:
			sumi += S[i-j]-X[i]
	return(sumi)