from sys import stdin
from math import *
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 10/3/2019 
Nota: Me base en la expliacion de Pham Trung de la pagina:
https://stackoverflow.com/questions/30520246/radar-installation-uva
ademas emplee el codigo de Activity scheduling algorithm (greedy approach)
https://bitbucket.org/snippets/hquilo/x6p5x

            . (x,y)
           /|\
          / | \ d
 0 ______/__|_ \_______  
        a   x   b
"""

def act_sch(a):
	a.sort(key=lambda x : x[1])   # sort activities by earliest finish time
	ans,n,N = 0,0,len(a)
	while n!=N:
		best,n,ans = n,n+1,ans+1
		while n!=N and a[n][0]<a[best][1]:
			n += 1
	return ans

def solve(A,n,d,ok):
	for i in range(n):
		x,y, = [ int(i) for i in stdin.readline().split() ]
		a, b = 0, 0
		sqrtd = (d**2)-(y**2)
		if d<y or sqrtd<0:
			ok = False
		elif d==y:
			a,b = x-d,x+d
		else:
			a,b = x-sqrt(sqrtd), x+sqrt(sqrtd)
		A.append([a,b])
	if ok == False:
		return("-1")
	else:
		return(act_sch(A))

def main():
	n = stdin.readline().strip().split()
	A,d,case,ok = [],int(n[1]),1,True
	while(n[0]!= '0' and n[1] != '0'):
		print("Case {}:".format(case),solve(A,int(n[0]),d,ok))
		n = stdin.readline()
		n = stdin.readline().strip().split()
		A,d,case,ok = [],int(n[1]), case + 1, True
main()
