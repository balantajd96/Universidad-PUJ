from sys import stdin
from collections import deque
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 31/3/2019 
Nota: me base en en el algoritmo bfs de "python in wonderland"
https://pythoninwonderland.wordpress.com/2017/03/18/how-to-implement-breadth-first-search-in-python/
"""

# visits all the nodes of a graph (connected component) using BFS
def bfs_connected_component(graph, start):
    visitados= []
    # keep track of nodes to be checked
    queue = deque()
    queue.append(start)
    # keep looping until there are nodes still to be checked
    while queue:
       # pop shallowest node (first node) from queue
        node = queue.popleft()
        neighbours = graph[node]
        # add neighbours of no1de to queue
        for neighbour in neighbours:
            if neighbour not in visitados:#para no visitar un nodo 2 veces
                queue.append(neighbour)
                visitados.append(neighbour)
    return visitados

def solve(A,a,m):
  for i in range(1,int(a[0])+1):
    ans=''
    if(A[i]!=[]):
      visitados=bfs_connected_component(A, i)
      visitados.sort()
      indice=0
      for j in range(1,int(m)+1):
        if indice <len(visitados):
          if(j==visitados[indice]):
            indice+=1
          else:
            ans+=str(j)+' '
        else:
          ans+=str(j)+' '
      print((str(len(ans)//2)+' '+ans.lstrip(' ')).rstrip(' '))
      ans=''
    else:
      for j in range(1,int(m)+1):
        ans+=str(j)+' '
      print((str(len(ans)//2)+' '+ans.lstrip(' ')).rstrip(' '))
      ans=''


def main():
  m = stdin.readline().strip()
  A,L = [[] for _ in range(int(m)+1)], list()
  while((m[0]=='0' and len(m)==1)==False):
    n = stdin.readline().strip().split()
    while ((n[0]=='0' and len(n)==1)==False):
      for j in range(1,len(n)-1):
        L.append(int(n[j]))
      A[int(n[0])] = A[int(n[0])]+L
      L=list()
      n = stdin.readline().strip().split()
    n = stdin.readline().strip().split()
    solve(A,n,m)
    m = stdin.readline().strip()
    A,L = [[] for _ in range(int(m)+1)], list()
main()