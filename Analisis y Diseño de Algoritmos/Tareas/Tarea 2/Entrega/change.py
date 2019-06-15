from sys import stdin

"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 18/2/2019
Ayuda: coinChange optimizado, visto en clase.


Monedas  5   10    20    50    $1   $2
Arreglo['0', '0', '15', '0', '14', '0', '4.30']
         0    1    2     3     4    5  |   6  

Monedas  1   2     4     10    20   40
Arreglo  0   0     15    0     14    0 |  86
         0   1     2     3     4     5 |   6  

Discutido con: 
Antonio Yu Chen
"""
INF= 999999999

def coinChange(D,X):
	N = len(D)
	tab = [ INF for x in range(X+1) ]
	tab[0] = 0
	n,x = 1,0
	while n!=N+1:
		if x==X+1:
			n,x = n+1,0
		else:
			if D[n-1]<=x:
				tab[x] = min(tab[x],1+tab[x-D[n-1]])
			x += 1
	return (tab[X])

def solve(A,D,x):# calcula la minima cantidad de monedas para formar un valor
	cantidadMonedas = [ int(A[i]) for i in range(len(A)-1) ]
	ans=0
	for i in reversed(range(len(cantidadMonedas))):
		if D[i]<= x:
			monedas= min(x//D[i],cantidadMonedas[i])# minimo entre las monedas necesarias y las monedas que se tiene 
			x-= monedas*D[i]
			ans+=monedas
	if(x!=0):
		return(INF)
	else:
		return (ans)

def main():
	D= [1,2,4,10,20,40]
	tuplaMoneda = [ (i,coinChange(D,i)) for i in range(1,41) ]#tublas de valores de las monedas con la minima cantidad de monedas
	n = stdin.readline().strip().split()
	while(n != ['0', '0', '0', '0', '0', '0']):
		x = int(round(float(n[6])*100,0)/5)
		valor = solve(n,D,x)
		for v,c in tuplaMoneda: #v valor | c cantidad de monedas
			valor=min(valor,solve(n,D,x+v)+c)#el minimo entre el valor y pagando de mas 
		n = stdin.readline().strip().split()
		espacio, valor="", str(valor)
		for _ in range(3-len(valor)):
			espacio+=' '
		print(espacio+valor)
main()
