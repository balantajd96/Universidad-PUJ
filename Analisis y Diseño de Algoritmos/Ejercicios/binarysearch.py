def binsearch(A,x):
	low,hi = 0, len(A)-1
	while low <= hi:
		mid= (hi+low)//2
		if x == A[mid]:
			return mid
		elif x<A[mid]: 
			hi = mid-1
		else:
			low = mid+1
	return -1