from sys import stdin
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 26/3/2019 
Nota: me base en en el algoritmo bfs de la clase de AGRA 2018-2
https://drive.google.com/file/d/1_1SXDIg9S6QgZibb7DvvNeg6xBoerXq8/view
"""
deltar = [ -1, 0, 0, 1 ]
deltac = [  0, -1, 1, 0]
visited = None
def dfs(row,col):
  global visited
  node = [ (row, col) ] ; visited[row][col] = 1
  ans=0
  while len(node)!=0:
    ok = True
    r,c = node.pop()
    for i in range(len(deltar)):
      dr,dc = r+deltar[i],c+deltac[i]
      if (0<=dr<len(board) and 0<=dc<len(board[0])):
        if(board[dr][dc]==2):
          visited[dr][dc] = 1
          ok=False
    if(ok== True):
      for i in range(len(deltar)):
        dr,dc = r+deltar[i],c+deltac[i]
        if (0<=dr<len(board) and 0<=dc<len(board[0])):
          if(board[dr][dc]==1 and visited[dr][dc]==0):
            node.append((dr, dc))
            visited[dr][dc] = 1
          elif(board[dr][dc]==3 and visited[dr][dc]==0):
            node.append((dr, dc))
            visited[dr][dc] = 1
            ans+=1
    visited[r][c] = 2
  return ans

def solve(a,board):
  global visited
  visited = [ [ 0 for _ in range(len(board[0])) ] for _ in range(len(board)) ]
  return dfs(a[0],a[1])

def main():
  global board
  n = stdin.readline().strip().split()
  while (len(n)!=0):
    board=[[1 for _ in range(int(n[0]))] for _ in range(int(n[1]))]
    for j in range(int(n[1])):
      n = stdin.readline().strip().split()
      for k in range(len(n[0])):
        if(n[0][k] == '#'):
          board[j][k]=0
        elif(n[0][k] == '.'):
          pass
        elif(n[0][k] == 'T'):
          board[j][k]=2
        elif(n[0][k] == 'G'):
          board[j][k]=3
        elif(n[0][k] == 'P'):
          c1=(j,k)
    print(solve(c1,board))
    n = stdin.readline().strip().split()
main()