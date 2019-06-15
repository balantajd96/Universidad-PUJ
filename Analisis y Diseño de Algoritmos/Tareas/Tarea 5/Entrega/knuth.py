from sys import stdin
from collections import deque
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 14/4/2019 
Nota: 
"""
def cambio(resul):
  text,P='',[]
  for c in range(len(resul)):
    text+=resul[c]+ ' '
  P.append(text)
  for j in range(len(resul)-1):
    text=''
    resul[j],resul[j+1]=resul[j+1],resul[j]
    for c in range(len(resul)):
      text+=resul[c]+' '
    P.append(text)
  return(P)

def solve(St):
  ans,resul,ok,tam,L =list(),St[0],True,len(St),[St[0]]
  for i in range(1,tam-1):
    #
    resul= St[i]+' '+resul
    P= cambio(resul.split())
    P.pop(0)
    ans.append(P)
    L.append(St[i])
    #
  resul= St[tam-1]+' '+resul
  P= cambio(resul.split())
  ans.append(P)
  L.append(St[tam-1])
  while (ans!=[]):
    P=ans.pop()
    if(tam==len(P[0])//2):
      for j in P:
        text=''
        for k in j.split():
          text+=k
        print(text)
    else:
      c=len(P)-1
      for _ in range(0,len(P)):
        R= cambio((L[len(P[0])//2]+' '+P[c]).split())
        ans.append(R)
        c-=1
  return('')

def main():
  n = stdin.readline().strip()
  while (len(n)>0):
    if(len(n)==1):
      print(n+'\n')
    else:
      print(solve(n))
    n = stdin.readline().strip()
main()