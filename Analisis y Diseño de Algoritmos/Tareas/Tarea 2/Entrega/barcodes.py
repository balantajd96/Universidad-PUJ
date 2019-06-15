from sys import stdin

"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 21/2/2019
Discutido con Juan Miguel Cardona y Juan Esteban Cardona
          (  1                                 n = k
phi(n,km){   O                                 n = 0 or k = 0 or k>n
          (  ans = phi(n-i,k-1,m)              1 <= i <= m and n-i>=0
"""
INF= 999999999

def solve(n,k,m):
	if tab[n][k][m] != INF:
		return tab[n][k][m]
	if n == k:
		return 1
	elif(n==0 or k==0 or k>n):
		return 0
	else:
		ans = 0
		for i in range(1,m+1):
			if(n-i<0):
				break
			else:
				ans+=solve(n-i,k-1,m)
		tab[n][k][m]=ans
		return ans

def main():
	global tab
	tab = [[[INF for k in range(51)] for j in range(51)] for i in range(51)]
	n = stdin.readline().strip().split()
	while(len(n) == 3):
		print(solve(int(n[0]),int(n[1]),int(n[2])))
		n = stdin.readline().strip().split()

main()
