from sys import stdin
"""
Nombre: Ivan David Valderrama Corredor
Código de estudiante: 1887703
Código de honor del curso:
Como miembro de la comunidad académica
de la Pontificia Universidad JaverianaCali
me comprometo a seguir los más altos estándares
de integridad académica.
Fecha: 15/5/2019 
Nota:
#La siguiente funcion es basada en la explicacion de los choose's 
del profesor Camilo Rocha

def choose(c,n):
  ans,fac= 1,1
  if(c==2):
    return (n*(n-1))>>1
  else:
    for i in range(1,c):
      fac*=i
      ans*=(n-i)
    fac*=c
    return((n*ans)//fac)

#Las siguentes funciones fueron usadas para calcular las cotas maximas
que pueden llegar a tener los choose.

def BSCotaMax(f,c):
  m = 10**15
  hi = 10**15
  low = 0
  while (low+1 !=hi):
    mid = (low+hi)//2
    val = f(c,mid)
    if (val < m):
      low = mid
    else:
      hi = mid
  return hi

CHOOSE= [x for x in range(2,29)]

def cotaMax():
  ANS=[]
  for c in CHOOSE:
    ANS.append(BSCotaMax(choose,c))
  print(ANS)
cotaMax()

Estos son los siguientes N maximos:
Choose  2      3       4      5    6    7    8    9    10  11    12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27
N=[44721361, 181714, 12449, 2608, 950, 473, 286, 197, 148, 119, 100, 87, 78, 72, 67, 63, 61, 59, 57, 56, 55, 54, 54, 54, 54, 54]
"""

# choose2 -> (n,2)

def choose2(n):
  return (n*(n-1))>>1


# choose3 -> (n,3)

def choose3(n):
  return (n*(n-1)*(n-2))//6

#Busqueda binaria empleando las funciones choose
def BSChoose(f,hi,m):
  low = 0
  while (low+1 !=hi):
    mid = (low+hi)//2
    val = f(mid)
    if(val == m):
      return (mid,True)
    elif (val < m):
      low = mid
    else:
      hi =mid
  return low,False

""" La siguiente funcion fue adaptada de la pagina geeksforgeeks
https://www.geeksforgeeks.org/space-and-time-efficient-binomial-coefficient/
"""
def binomialCoeff(n, k):
  res = 1 
  #Since C(n, k) = C(n, n-k) 
  if ( k > n - k ):
    k = n - k
    # Calculate value of [n * (n-1) *---* (n-k+1)] / [k * (k-1) *----* 1] 
  for i in range(k):
    res *= (n - i) 
    res /= (i + 1)
  return round(res)

#Si solo se usaran las funciones choose, el tiempo de ejecucion se torna muy largo,
#por lo que se hace necesario precalcular la mayor cantidad de datos que podamos.
#La estructura que estoy empleando para guardar los m son listas de arreglos de tuplas.
#{ m0:[(n0,k0),(n1,k1),...,(nn,kn)], m1:[(n0,k0),(n1,k1),...,(nn,kn)], ..., mn:[(n0,k0),(n1,k1),...,(nn,kn)]}
def precalcular():
  DIC={}
  N2=[12449, 2608, 950,473, 286, 197, 148, 119, 100, 87, 78, 72, 67, 63, 61, 59, 57, 56, 55, 54, 54, 54, 54, 54]
  for i in range(len(N2)):
    for j in range(i+4,N2[i]+1):
      m=binomialCoeff(j,i+4) # j = n, K= i+4
      if(m not in DIC.keys()):
        DIC[m]=[(m,1)]#Tener en cuenta el primer caso que es el mismo m combinado 1
      DIC[m].append((j,i+4))

      #Debemos tener en cuenta el caso cuando k<n-k
      if(i+4< j-i-4):
        DIC[m].append((j,j-i-4))
  return(DIC)

PRECAL=precalcular()

#
def solve(m):
  global PRECAL
  CHOOSE= [choose2,choose3]
  CHOOSECOTA=[44721361, 181714]
  ANS=[]
  ANS.append((m,1))#Tener en cuenta el primer caso que es el mismo m combinado 1
  # Debemos tener en cuenta el caso cuando k<n-k
  if(1<m-1):
        ANS.append((m,m-1))
  for c in range(2,4):
    ans=BSChoose(CHOOSE[c-2],CHOOSECOTA[c-2],m)
    if(ans[1]==True):
      ANS.append((ans[0],c))

      # Debemos tener en cuenta el caso cuando k<n-k
      if(c<ans[0]-c):
        ANS.append((ans[0],ans[0]-c))

  pre= PRECAL.get(m)
  if(pre != None):
    for i in pre:
      ANS.append(i)
  ANS=list(set(ANS))
  ANS.sort()

  text='('+str(ANS[0][0])+','+str(ANS[0][1])+')'
  for i in range(1,len(ANS)):
    text+=' '+'('+str(ANS[i][0])+','+str(ANS[i][1])+')'
  print(len(ANS))
  print(text)

def main():
  c = stdin.readline().strip()
  for i in range(int(c)):
    n= stdin.readline().strip()
    solve(int(n))
#main()
print(choose2(1))