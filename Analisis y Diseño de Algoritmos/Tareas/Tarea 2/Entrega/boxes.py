from sys import stdin

"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 22/2/2019
Ayuda: Clase 19/02/2019

"""
INF= 999999999

def solve(W,L,M):
	N=len(L)
	tab=[[0 for _ in range(M+1)] for _ in range(N+1)]
	n,m=1,0
	while(n!=N+1):
		if m==M+1:
			n,m = n+1,0
		else:
			tab[n][m]=tab[n-1][m]
			if(W[n-1]<=m):
				tab[n][m]=max(tab[n][m],1+tab[n-1][min(m-W[n-1],L[n-1])])
			m+=1
	return tab[N][M]

def main():
	n = stdin.readline().strip().split()
	n = stdin.readline().strip().split()
	W,L,M= [],[],0
	while(n != ['0']):
		if(len(n) != 1):
			M=(max(M,int(n[0])+int(n[1])))
			W.append(int(n[0]))
			L.append(int(n[1]))
		else:
			W.reverse()
			L.reverse()
			print(solve(W,L,M))
			W,L,M= [],[],0
		n = stdin.readline().strip().split()
	W.reverse()
	L.reverse()
	print(solve(W,L,M))

main()