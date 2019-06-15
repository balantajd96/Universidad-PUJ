from sys import stdin

marble,lenm = None,None

def solve(x):
  # place your code here
  pass

def main():
  global marble,lenm
  case = 1
  lenm,lenq = [ int(x) for x in stdin.readline().split() ]
  while lenm+lenq!=0:
    marble = [ int(stdin.readline()) for i in range(lenm) ]
    print('CASE# {0}:'.format(case))
    for q in range(lenq):
      x = int(stdin.readline())
      ans = solve(x)
      if ans==-1 or marble[ans]!=x:
        print('{0} not found'.format(x))
      else:
        print('{0} found at {1}'.format(x,ans+1))
    lenm,lenq = [ int(x) for x in stdin.readline().split() ]
    case += 1

main()
