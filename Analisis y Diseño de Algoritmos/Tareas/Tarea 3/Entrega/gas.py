from sys import stdin

"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 7/3/2019 
Nota: Empleando el minimalCovering visto en clase del 7/3/2019 
https://bitbucket.org/snippets/hquilo/z6KbA
"""
def minimalCovering(L,H,a):
  a.sort()
  ans,low,n,ok,N = list(),L,0,True,len(a)
  while ok and low<H and n!=N:
    ok = a[n][0]<=low
    best,n = n,n+1
    while ok and n!=N and a[n][0]<=low:
      if a[n][1]>a[best][1]:
        best = n
      n += 1
    ans.append(best)
    low = a[best][1]
  if(low < H):
  	ok = False
  if not ok:
    ans = list()
  return ans

def solve(A,l):
	ans = minimalCovering(0,l,A)
	if(ans == []):
		return -1
	else:
		return(len(A)-len(ans))

def main():
	n = stdin.readline().strip().split()
	A,l = [],int(n[0])
	while(n[0]!= '0' and n[1] != '0'):
		for i in range(int(n[1])):
			n = stdin.readline().strip().split()
			A.append([int(n[0])-int(n[1]),int(n[0])+int(n[1])])
		print(solve(A,l))
		n = stdin.readline().strip().split()
		A,l = [],int(n[0])
main()
