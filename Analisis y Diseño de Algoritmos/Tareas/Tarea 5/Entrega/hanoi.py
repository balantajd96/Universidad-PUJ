from sys import stdin
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 11/4/2019 
Nota: 
"""
mem = {}
def solve(a):
  A,ok,cant,i = [0 for _ in range(a)],True,1,0
  while (ok and i<len(A)):
    if(((A[i]+cant)**0.5)%1==0.0 or A[i]==0):
      A[i] = cant
      cant,i = cant+1, 0
    else:
      i+=1
  return(cant-1)


def main():
  global mem
  c = stdin.readline().strip()
  for i in range(int(c)):
    n= stdin.readline().strip()
    if(mem.get(n)!=None):
      print(mem[n])
    else:
      r=solve(int(n))
      mem[n]=r
      print(r)
main()