 INF = 99999999999
  
 def CoinChange(D,x):
    ans,i=0, len(D)-1
    while(x>0):
        if D[i]<= x:
            monedas= x//D[i]
            x-= monedas*D[i]
            ans+=monedas
        else:
            i-=1
    return (ans)