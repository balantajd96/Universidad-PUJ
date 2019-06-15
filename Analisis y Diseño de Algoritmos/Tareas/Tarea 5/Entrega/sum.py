from sys import stdin
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 15/4/2019 
Nota:Me base en la explicacion de la pagina:
https://www.redgreencode.com/more-recursive-backtracking-uva-574/
y analizando el algoritmo:
https://gist.github.com/KT-Yeh/9442562
"""
RESUL, NUM, V= list(),list(),list()

def backtracking(ind, sumi, V,t,n):
  global RESUL, NUM
  if(sumi == t): #Si la suma es igual a t mira si lo imprimio o no
    for c in RESUL:
      if(c == str(V)):
        return
    else:
      RESUL.append(str(V))
      text=str(V[0])
      for i in range(1,len(V)):
        text+='+'+str(V[i])
      print(text)
      return

  for i in range(ind,n):
    V.append(NUM[i])
    if(sumi+ NUM[i] <= t or ind != n):
      backtracking(i + 1, sumi + NUM[i], V,t,n)
    V.pop()

def solve(A):
  global RESUL, NUM , V
  RESUL, NUM, V= list(),list(),list()
  for i in range(2,len(A)):
    NUM.append(int(A[i]))
  backtracking(0, 0, V,int(A[0]),int(A[1]))
  return(RESUL)


def main():
  A = stdin.readline().strip().split()
  while(A[0]!='0' and A[1]!='0'):
    print("Sums of {}:".format(A[0]))
    if(solve(A) == []):
      print("NONE");
    A= stdin.readline().strip().split()
main()