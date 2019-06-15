from sys import stdin

"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 5/2/2019

Este codigo fue implimentado con lo visto en la clase del jueves
"""

MAX = 10010
bet = [None for i in range(10010)]


def solve(low,hi):
  maximo,suma = 0, 0
  for i in range(0,hi):
    suma += bet[i]
    if suma<0: suma = 0
    if suma>maximo: maximo = suma
  return maximo

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
