from sys import stdin

def solve(A, M):
  # place your code here
  pass

def main():
  line = stdin.readline()
  while len(line)!=0:
    n,M = [ int(x) for x in line.split() ]
    A = [ int(x) for x in stdin.readline().split() ]
    print(solve(A, M))
    line = stdin.readline()

main()
