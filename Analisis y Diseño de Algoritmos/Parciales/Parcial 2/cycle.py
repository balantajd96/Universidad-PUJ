from sys import stdin
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 24/3/2019 
Nota: Empleando el algoritmo de kruskal visto en clase
https://drive.google.com/file/d/1paBCNXbl6AV4zzP0AyYvGBujl82taocz/view
"""

class dforest(object):
  """Disjoint-Union implementation with disjoint forests using path
  compression and ranking"""

  def __init__(self, size=100):
    """create an empty disjoint forest"""
    self.__parent = [ i for i in range(size) ]
    self.__rank = [ 0 for _ in range(size) ]

  def __str__(self):
    """return the string representation"""
    return str(self.__parent)
  
  def find(self, x):
    """return the representative of x"""
    if self.__parent[x]!=x: self.__parent[x] = self.find(self.__parent[x])
    return self.__parent[x]

  def union(self, x, y):
    """perform the union of the collections where x and y belong"""
    rx,ry = self.find(x),self.find(y)
    if rx!=ry:
      krx,kry = self.__rank[rx],self.__rank[ry]
      if krx>=kry:
        self.__parent[ry] = rx
        if krx==kry: self.__rank[rx] += 1
      else:
        self.__parent[rx] = ry

def kruskal(G, lenv):
  ans = list()
  G.sort(key=lambda x: x[2])
  df = dforest(lenv)
  for u,v,w in G:
    if df.find(u)!=df.find(v):
      df.union(u, v)
    else:
      ans.append((u, v, w))
  return ans

def solve(A,n):
  result,ans = kruskal(A, n), ""
  if(result != []):
    for i in result:
      ans += str(i[2])+ ' '
    return ans.rstrip(' ')
  else:
    return "forest"


def main():
  n = stdin.readline().strip().split()
  A = list()
  while((n[0]== '0' and n[1] == '0')==False):
    v = int(n[0])
    for i in range(int(n[1])):
      n = stdin.readline().strip().split()
      A.append((int(n[0]),int(n[1]),int(n[2])))
    print(solve(A,v))
    A = list()
    n = stdin.readline().strip().split()
main()