from sys import stdin
"""
Nombre: Ivan David Valderrama Corredor
Codigo: 1887703
Fecha: 18/5/2019 
Nota:
"""


def solve(S,Q):
	QB = [0 for i in range(len(Q))]
	indice = 0
	POS= []
	for i in range(len(S)):
		if(len(QB)!=0):
			if(S[i] == Q[indice]):
				if(Q[indice]==Q[0]):
					POS.append(i)
				elif(Q[indice]==Q[len(Q)-1]):
					POS.append(i)
				QB.pop()
				indice+=1
	if (len(QB)==0):
		print("Matched",POS[0],POS[len(POS)-1])
	else:
		print("Not matched")


def main():
	cadena = stdin.readline().strip()
	casos = stdin.readline().strip()
	for i in range(int(casos)):
		consultas= stdin.readline().strip()
		solve(cadena,consultas)
main()