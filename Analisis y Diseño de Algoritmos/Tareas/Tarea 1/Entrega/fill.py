from sys import stdin
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 22/2/2019

para la parte de la busqueda binaria, me base en el codigo de morris
https://github.com/morris821028/UVa/blob/master/volume114/11413%20-%20Fill%20the%20Containers.c

"""

def binsearch(A,x,maxi,suma):
	low,hi = maxi, suma
	while low < hi:
		mid= (hi+low)//2
		sig, cantidadActual = 1 , 0
		for i in range(len(A)):
			if(A[i]+cantidadActual>mid):
				sig += 1
				cantidadActual=0
			cantidadActual += A[i]
		if sig>x:
			low = mid + 1
		else:
			hi = mid
	return low
	
def solve(A, M):
	suma = 0
	for i in range(len(A)):
		suma+= A[i]
	maxi=max(A)
	if(len(A)<=M):
		return maxi
	elif(M==1):
		return(suma)
	else:
		return(binsearch(A,M,maxi,suma))

def main():
  line = stdin.readline()
  while len(line)!=0:
    n,M = [ int(x) for x in line.split() ]
    A = [ int(x) for x in stdin.readline().split() ]
    print(solve(A, M))
    line = stdin.readline()

main()