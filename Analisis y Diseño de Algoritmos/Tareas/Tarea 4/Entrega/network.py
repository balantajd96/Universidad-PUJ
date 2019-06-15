from sys import stdin
from collections import deque
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 25/3/2019 
Nota: me base en en el algoritmo bfs de "python in wonderland"
https://pythoninwonderland.wordpress.com/2017/03/18/how-to-implement-breadth-first-search-in-python/
"""

# visits all the nodes of a graph (connected component) using BFS
def bfs_connected_component(graph, start):
    altura = {}
    altura[start]= 0
    visitados= [start]

    explored = []
    # keep track of nodes to be checked
    queue = deque()
    queue.append(start)
    # keep looping until there are nodes still to be checked
    while queue:
       # pop shallowest node (first node) from queue
        node = queue.popleft()
        explored.append(node)
        neighbours = graph[node]
        # add neighbours of node to queue
        for neighbour in neighbours:
            if neighbour not in visitados:#para no visitar un nodo 2 veces
                queue.append(neighbour)
                visitados.append(neighbour)
                altura[neighbour]= altura[node]+1

    return altura

def solve(A,c1,c2):
  arbol = bfs_connected_component(A, c1)
  return int(arbol[c2])-1


def main():
  n = stdin.readline().strip().split()
  A,L = {}, list()
  for i in range(int(n[0])):
    n = stdin.readline()
    n = stdin.readline().strip().split()
    for j in range(int(n[0])):
      n = stdin.readline().strip().split()
      for k in range(2,len(n)):
        L.append(n[k])
      A[n[0]] = L
      L=list()
    n = stdin.readline().strip().split()
    print(n[0],n[1],solve(A,n[0],n[1]))
    print('')
main()