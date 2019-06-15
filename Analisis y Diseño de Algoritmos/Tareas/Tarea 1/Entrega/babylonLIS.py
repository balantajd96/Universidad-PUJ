from sys import stdin
import itertools
#Estudiante: Lina Marcela Valencia Castañeda
#_Basado en el código de LIS explicado por el profesor en clase
#_Se le hacen modificaciones para que las permutaciones no sean repetidas en la lista de bloques
#suponiendo que una vez gastado, ya no lo pueda usar sobre otro
#_Usa una función auxiliar prove que permite ver si es posible poner un bloque sobre otro

def permute(i):
  if (i[0] == i[1] and i[0]== i[2]and i[1]== i[2]):
    blocks.append(i)
  elif (i[0] == i[1] and i[0]!= i[2]and i[1]!= i[2]):
    blocks.append(i)
    blocks.append([i[2],i[0],i[1]])
    blocks.append([i[0],i[2],i[1]])

  elif (i[0] != i[1] and i[0]!= i[2]and i[1]== i[2]):
    blocks.append(i)
    blocks.append([i[1],i[0],i[2]])
    blocks.append([i[1],i[2],i[0]])
  else:
    blocks.append(i)
    blocks.append([i[0],i[2],i[1]])
    blocks.append([i[1],i[0],i[2]])
    blocks.append([i[1],i[2],i[0]])
    blocks.append([i[2],i[0],i[1]])
    blocks.append([i[2],i[1],i[0]])

def prove(i,n):
  #funcion valida si puedo poner un bloque sobre otro respetando las reglas de la torre.
  if (blocks[n][0]<blocks[i][0] and blocks[n][1]<blocks[i][1]):
    return True
  else:
    return False

def solve():
  ans, N = 0, len(blocks)
  if N!= 0:
    tab =[0 for _ in range(N)]
    ans, tab[0], n = 1, blocks[0][2], 1#n es el contador de los bloques que voy a poner
    while n!= N:
      tab[n], i = blocks[n][2], 0     
      while i != n :#i son los que ya pasaron y están calculados en Tab.
        if (prove(i,n) == True and tab[i]+blocks[n][2]>tab[n]) :#(puedo extender?) & (es lo mejor para extender?)
          tab[n] = tab[i]+blocks[n][2]
        i += 1
      ans, n = max(ans, tab[n]), n+1
  return ans

def main():
  global inputs, blocks
  n = int(stdin.readline().strip())
  case = 1
  while n!=0:
    blocks = []
    for i in range(n):
      x, y, z = map(int, stdin.readline().strip().split())
      permute((x,y,z))#Realiza las permutaciones de la tupla (x,y,z) simulando las rotaciones permitidas

    blocks = sorted(sorted(blocks, key = lambda x : x[2]), key = lambda x : x[0], reverse = True)
    ans = solve()
    print('Case {0}: maximum height = {1}'.format(case, ans))
    n = int(stdin.readline().strip())
    case += 1

main()
