from sys import stdin
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 5/2/2019
"""

def binsearch(A,x):
	low,hi = 0, len(A)-1
	while low <= hi:
		mid= (hi+low)//2
		if x == A[mid]:
			return mid-1,mid+1
		elif x<A[mid]: 
			hi = mid-1
		else:
			low = mid+1
	if(A[mid]>x):
		return mid-1,mid
	elif(A[mid]<x):
		if(mid<len(A)-1):
			return mid, mid+1
		else:
			return mid, -1
	else:
		return -1, -1


def solve(ladies, x):
	mini,maxi=binsearch(ladies,x)
	if(mini == -1):
		print('X',ladies[maxi])
	elif (maxi== -1):
		print(ladies[mini],'X')
	else:
		print(ladies[mini],ladies[maxi])



def main():
	inp = stdin
	inp.readline()
	ladies = [ int(x) for x in inp.readline().split() ]
	inp.readline()
	queries = [ int(x) for x in inp.readline().split() ]
	for x in queries:
		solve(ladies, x)
main()