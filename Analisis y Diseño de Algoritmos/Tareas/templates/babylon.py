from sys import stdin

MAX = 35
blocks = [None for i in range(MAX)]

def solve():
  # place your code here
  pass

def main():
  n = int(stdin.readline().strip())
  case = 1
  while n!=0:
    for i in range(n):
      x, y, z = map(int, stdin.readline().strip().split())
      blocks.append((x, y, z))
    ans = solve()
    print('Case {0}: maximum height = {1}'.format(case, ans))
    n = int(stdin.readline().strip())
    case += 1

main()
