from sys import stdin

"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 18/2/2019
Nota:

?1?

   i
   ^
   |
[ [1] [0] [1] ]-> j
[ [1] [1] [1] ]
[ [1] [0] [1] ]
Discutido con: 
Jhoan Sebastian Lozano Rojas
"""
INF= 999999999

def suma(A):
	sumi=0
	for i in A:
		sumi +=i
	return (sumi)


def solve(A):
	N=len(A)
	tab=[[0 for _ in range(N)] for _ in range(N)]
	for i in range(N):
		if(A[i]=='?'):
			for j in range(N):
				tab[i][j] = 1
		else:
			for j in range(N):
				tab[i][j] = 0
			if(ord(A[i])>=48 and ord(A[i])<=57):
				tab[i][int(A[i])-1]= 1
			else:
				tab[i][10 + ord(A[i]) - ord('A') - 1]= 1

	for i in range(1,N):
		for j in range(N):
			if(tab[i][j]!=0):
				if(j==0):
					tab[i][j]=suma(tab[i-1])-tab[i-1][j]-tab[i-1][j+1]
				elif(j==N-1):
					tab[i][j]=suma(tab[i-1])-tab[i-1][j-1]-tab[i-1][j]
				else:
					tab[i][j]=suma(tab[i-1])-tab[i-1][j-1]-tab[i-1][j]-tab[i-1][j+1]
	return(sum(tab[N-1]))

def main():
	n = stdin.readline().strip()
	while(len(n) != 0):
		print(solve(n))
		n = stdin.readline().strip()

main()
