from sys import stdin
from collections import deque
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 26/3/2019 
Nota: me base en en el algoritmo bfs de la clase de AGRA 2018-2
https://drive.google.com/file/d/1_1SXDIg9S6QgZibb7DvvNeg6xBoerXq8/view
"""
board = None
deltar = [ -1, -1, -1, 0, 0, 1, 1, 1 ]
deltac = [ -1, 0, 1, -1, 1, -1, 0, 1 ]
visited = None

def bfs(row,col):
  global visited
  node = deque()
  node.append((row,col,0))
  ans=0
  while len(node)!=0:
    r,c,ans = node.popleft()
    for i in range(len(deltar)):
      dr,dc = r+deltar[i],c+deltac[i]
      if (0<=dr<len(board) and 0<=dc<len(board[0])):
        if(board[dr][dc]==1 and visited[dr][dc]==0):
          node.append((dr, dc,ans+1))
          visited[dr][dc] = 1
        elif(board[dr][dc]==0):
          return(ans+1)
    visited[r][c] = 2
  return 0

def solve(a,board):
  global visited
  visited = [ [ 0 for _ in range(len(board[0])) ] for _ in range(len(board)) ]
  ans = bfs(a[0],a[1])
  if(ans!=0):
    return "Minimal possible length of a trip is "+str(ans)
  else:
    return "King Peter, you can't go now!"


def main():
  global board
  n = stdin.readline().strip().split()
  for i in range(int(n[0])):
    n = stdin.readline().strip().split()
    board=[[1 for _ in range(int(n[1]))] for _ in range(int(n[0]))]
    for j in range(int(n[0])):
      n = stdin.readline().strip()
      for k in range(len(n)):
        if(n[k]== '.'):
          pass
        elif(n[k]== 'Z' and board[j][k]!=0):
          board[j][k]='H'
          if(k-2>=0 and j-1>=0):
            board[j-1][k-2]='H'
          if(k-1>=0 and j-2>=0):
            board[j-2][k-1]='H'
          if(k+2<=len(board[0])-1 and j-1>=0):
            board[j-1][k+2]='H'
          if(k+1<=len(board[0])-1 and j-2>=0):
            board[j-2][k+1]='H'
          if(k-2>=0 and j+1<=len(board)-1):
            board[j+1][k-2]='H'
          if(k-1>=0 and j+2<=len(board)-1):
            board[j+2][k-1]='H'
          if(k+2<=len(board[0])-1 and j+1<=len(board)-1):
            board[j+1][k+2]='H'
          if(k+1<=len(board[0])-1 and j+2<=len(board)-1):
            board[j+2][k+1]='H'
        elif(n[k]== 'A'):
          c1=(j,k)
        elif(n[k]== 'B'):
          c2=(j,k)
    board[c2[0]][c2[1]]=0
    print(solve(c1,board))
main()