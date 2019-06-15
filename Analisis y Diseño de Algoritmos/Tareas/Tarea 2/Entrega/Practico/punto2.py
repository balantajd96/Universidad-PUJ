 INF = 99999999999

def Sequencebreaks(L, TablaCorte, i, j):
    if (j - i >= 2):
        print ("Break at",L[k])
        Sequencebreaks(L, TablaCorte, i, k)
        Sequencebreaks(L, TablaCorte, k, j)

def BreakingString(n, L):
    #Ej: L:[20 17 14 11 25]
    L= L.sort()
    L.insert(1, 0)
    L.append(n)
    # Ej: L:[0 20 17 14 11 2 5 n]
    m = len(L)
    #Nuevas tablas
    TablaCosto = [[1 for i in range(m)] for i in range(m)] 
    TablaCorte = [[1 for i in range(m)] for i in range(m)]
    for i in range(1,len(m)):
        TablaCosto[i, i],TablaCosto[i, i + 1] = 0, 0
    TablaCosto[m, m] = 0
    for lon in range(3,m):
        for i in range(1,m - lon + 1)
            j = i + lon - 1
            TablaCosto[i, j] = INF
            for k in range(i + 1, j - 1)
                if (TablaCosto[i, k] + TablaCosto[k, j] < TablaCosto[i, j]):
                    TablaCosto[i, j] = TablaCosto[i, k] + TablaCosto[k, j]
                    TablaCorte[i, j] = k
            TablaCosto[i, j] = TablaCosto[i, j] + L[j] - L[i]
    print ("The minimum cost of breaking the string is", TablaCosto[1, m])
    Sequencebreaks(L, TablaCorte, 1, m)