from sys import stdin
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 23/2/2019
Nota:

(m1+m2)/(n1+n2)= m'/n'
m1/n1 = 0/1
m2/n2 = 1/0
 
 m  (97)
 --------
 n   (3)

 m > n ---> R
 L <------- n > m
"""

def binsearch(m,n):
	m1,n1,m2,n2,hi,low = 0,1,1,0,1,1
	string=''
	while hi!=m and low!=n:
		if low*m < hi*n:
			string+='L'
			m2,n2 = hi,low
		else:
			string+='R'
			m1,n1 = hi,low
		hi,low = m1+m2, n1+n2
	return(string)
	
def solve(m, n):
	return(binsearch(m,n))

def main():
	n = stdin.readline().strip().split()
	while(len(n) == 2):
		if(n[0]!='1' and n[1] !='1'):
			print(solve(int(n[0]),int(n[1])))
		n = stdin.readline().strip().split()

main()