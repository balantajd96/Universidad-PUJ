from sys import stdin
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 6/2/2019
Nota: hay que optimizar
"""

MAX = 35
blocks = [None for i in range(MAX)]
matrizPer = []

def permutar(x,y,z,index):
  if(x == y and y == z):
    matrizPer.append(index)
    matrizPer[index]=[x,y,z]
    index+=1
  elif(x == y):
    matrizPer.append(index)
    matrizPer[index]=[x,y,z]
    index+=1
    matrizPer.append(index)
    matrizPer[index]=[x,z,y]
    index+=1
    matrizPer.append(index)
    matrizPer[index]=[z,x,y]
    index+=1
  elif(y == z):
    matrizPer.append(index)
    matrizPer[index]=[x,y,z]
    index+=1
    matrizPer.append(index)
    matrizPer[index]=[y,x,z]
    index+=1
    matrizPer.append(index)
    matrizPer[index]=[y,z,x]
    index+=1
  elif(x == z):
    matrizPer.append(index)
    matrizPer[index]=[x,y,z]
    index+=1
    matrizPer.append(index)
    matrizPer[index]=[y,x,z]
    index+=1
    matrizPer.append(index)
    matrizPer[index]=[x,z,y]
    index+=1
  else:
    matrizPer.append(index)
    matrizPer[index]=[x,y,z]
    index+=1
    matrizPer.append(index)
    matrizPer[index]=[x,z,y]
    index+=1
    matrizPer.append(index)
    matrizPer[index]=[y,x,z]
    index+=1
    matrizPer.append(index)
    matrizPer[index]=[y,z,x]
    index+=1
    matrizPer.append(index)
    matrizPer[index]=[z,x,y]
    index+=1
    matrizPer.append(index)
    matrizPer[index]=[z,y,x]
    index+=1
  return(index)

def solucion(A):
  A.sort(reverse = True)
  maxi = [A[0][2],A[0]]
  for i in range(1,len(A)):
    print(maxi,A[i],A[i][0],A[0],A[0][0])
    if(A[i][0]<A[0][0] and A[i][1]<A[0][1]):
      if(A[i][0] < maxi[1][0] and A[i][1] < maxi[1][1]):
        if(A[0][2] + A[i][2]+maxi[0]>maxi[0]):
  
          maxi = [A[0][2] + A[i][2],A[i]]
        else:
          maxi[0]= A[0][2] + A[i][2]
    else:
      if(A[i][2]>maxi[0]):
        maxi[0] = A[i][2]
  print(maxi)
  return(maxi[0])


def solve():
  return(solucion(matrizPer))

def main():
  n = int(stdin.readline().strip())
  case = 1
  index = 0
  while n!=0:
    for i in range(n):
      x, y, z = map(int, stdin.readline().strip().split())
      index =permutar(x,y,z,index)
    ans = solve()
    print('Case {0}: maximum height = {1}'.format(case, ans))
    n = int(stdin.readline().strip())
    case += 1

main()
