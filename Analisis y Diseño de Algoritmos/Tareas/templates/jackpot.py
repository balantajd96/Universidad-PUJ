from sys import stdin

MAX = 10010
bet = [None for i in range(10010)]


def solve(low,hi):
  # place your code here
  pass

def main():
  global bet
  inp = stdin
  n = int(inp.readline().strip())
  while n!=0:
    tok = inp.readline().strip().split()
    for i in range(n): bet[i] = int(tok[i])
    ans = solve(0,n)
    if ans<=0: print('Losing streak.')
    else: print('The maximum winning streak is {0}.'.format(ans))
    n = int(inp.readline().strip())

main()
