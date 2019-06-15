from sys import stdin
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 24/2/2019
Nota: codigo de Knapsack Problem (Knapsack 0-1) por tabulacion ahorrando espacio
https://bitbucket.org/snippets/hquilo/KRBB9/ks-with-tabulation-and-space-optimization
input: v[0..N) and w[0..N) arrays of natural numbers, N>=0, and C>=0
"""
NINF= -9999999999999999
def ks_tab_opt(v,w,C):
	N = len(v)
	tab = [ NINF for c in range(C+1) ]
	tab[0]=0
	n,c = 1,C
	while n!=N+1:
		if c==-1: n,c = n+1,C
		else:
			if w[n-1]<=c: tab[c] = max(tab[c],v[n-1]+tab[c-w[n-1]])
			c -= 1
	print(tab)
	ans = 0
	for i in range(C-199):   # rango de 0 a C
		ans = max(ans,tab[i])
	for i in range(2001,C+1):   # rango de 2001 a C+200
		ans = max(ans,tab[i])
	return ans
def solve(m,P,F):
	return(ks_tab_opt(F,P,m+200))

def main():
	n = stdin.readline().strip().split()
	while(len(n) == 2):
		m, n1, P, F= int(n[0]), int(n[1]), [], []
		for i in range(int(n1)):
			n = stdin.readline().strip().split()
			P.append(int(n[0])), F.append(int(n[1]))
		n = stdin.readline().strip().split()
		print(solve(m,P,F))

main()