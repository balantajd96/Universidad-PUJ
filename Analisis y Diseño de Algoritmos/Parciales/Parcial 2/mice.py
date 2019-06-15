from sys import stdin
from heapq import heappop,heappush
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 31/3/2019 
Nota: empleando algoritmo de Dijkstra clase de 2018-2 (problema: Distancia mínima de un vértice a todos los demás (SSSP))
https://drive.google.com/file/d/0B-Bk1ixpbgwJb0JiN1BiYWszWFU/view

Se debe invertir el grafo, debido a que el grafo es dirigido, a pesar de que haya un camino
de ida, eso no implica que haya uno de venida. 
"""

INF = float('inf')

def sssp(G,source,T):
  """G is a graph representation in adjacency list format with vertices
     in the set { 0, ..., |V|-1 } and source a vertex in G"""
  # dist[u] : "minimum distance detected from source to u
  mice = 0
  dist = [ INF for i in range(len(G)) ] ; dist[source] = 0
  visited = [ False for i in range(len(G)) ]
  heap = [ (0,source) ]
  while len(heap)!=0:
    d,u = heappop(heap)
    if not(visited[u]):
      visited[u] = True
      for v,w in G[u]:
        if dist[v]>d+w:
          dist[v] = d+w
          heappush(heap,(dist[v],v))
  for i in range(len(G)):
    if dist[i]<=T:
      mice+=1
  return mice

def solve(A,E,T):
  return sssp(A,E,T)


def main():
  n = stdin.readline().strip()
  stdin.readline()
  for _ in range(int(n)):
    N = stdin.readline().strip()# N≤100
    A = [list() for i in range(int(N)+1)]
    E = stdin.readline().strip()
    T = stdin.readline().strip()
    M = stdin.readline().strip()
    for _ in range(int(M)):
      m = stdin.readline().strip().split()
      a,b,t= int(m[0]),int(m[1]),int(m[2])# b->a
      A[b].append((a,t))
    print(solve(A,int(E),int(T)))
    print('')
    stdin.readline()
main()