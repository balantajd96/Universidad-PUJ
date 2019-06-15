 INF = 99999999999
  
def printingNeatly (l, M):
    n = len(l) 
    extras = [[0 for i in range(n)] for i in range(n)] 
        
    # lc[i][j] es la matriz que tiene los costos
    lc = [[0 for i in range(n)] for i in range(n)] 
               
    # c[i] tendra los costos totales del arreglo de palbras desde 0 hasta i
    c = [0 for i in range(n)] 
      
    # p[] p es el arreglo usado para impimir el resultado
    p = [0 for i in range(n)] 
      
    # indica los espacios adicionales, si las palabras de la palabra i y j se colocan en una sola linea
    for i in range(n): 
        extras[i][i] = M - l[i] 
        for j in range(i + 1, n): 
            extras[i][j] = (extras[i][j - 1] - 
                                    l[j - 1] - 1) 
                                      
    # Calcula el costo de linea
    for i in range(n): 
        for j in range(i, n): 
            if extras[i][j] < 0: 
                lc[i][j] = INF; 
            elif j == n and extras[i][j] >= 0: 
                lc[i][j] = 0
            else: 
                lc[i][j] = (extras[i][j] * 
                            extras[i][j]) 
  
    # Calcula el minimo costo del arreglo
    c[0] = 0
    for j in range(1, n): 
        c[j] = INF 
        for i in range(1, j): 
            if ((c[i - 1] + lc[i][j]) < c[j]): 
                c[j] = c[i-1] + lc[i][j] 
                p[j] = i 
    return(p, c) 