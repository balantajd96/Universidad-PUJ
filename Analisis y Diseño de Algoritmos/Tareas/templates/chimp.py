from sys import stdin

def solve(ladies, x):
  # place your code here
  pass

def main():
  inp = stdin
  inp.readline()
  ladies = [ int(x) for x in inp.readline().split() ]
  inp.readline()
  queries = [ int(x) for x in inp.readline().split() ]
  for x in queries:
    solve(ladies, x)

main()
