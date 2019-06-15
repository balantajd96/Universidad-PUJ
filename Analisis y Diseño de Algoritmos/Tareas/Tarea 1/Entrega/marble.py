from sys import stdin

"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 6/2/2019
Nota: hay que tener en cuenta de que las canicas pueden estar repetidas

"""

marble,lenm = None,None
def binsearch(A,x):
  primero=True
  low,hi = 0, len(A)-1
  while low <= hi:
    mid= (hi+low)//2
    if A[mid] == x:
      while primero==True:
        if A[mid-1] != x:
          return mid
        else:
          mid-=1
    elif x<A[mid]: 
      hi = mid-1
    else:
      low = mid+1
  return -1

def solve(x):
  return binsearch(marble,x)

def main():
  global marble,lenm
  case = 1
  lenm,lenq = [ int(x) for x in stdin.readline().split() ]
  while lenm+lenq!=0:
    marble = [ int(stdin.readline()) for i in range(lenm) ]
    marble.sort()
    print('CASE# {0}:'.format(case))
    for q in range(lenq):
      x = int(stdin.readline())
      ans = solve(x)
      if ans==-1 or marble[ans]!=x:
        print('{0} not found'.format(x))
      else:
        print('{0} found at {1}'.format(x,ans+1))
    lenm,lenq = [ int(x) for x in stdin.readline().split() ]
    case += 1

main()
