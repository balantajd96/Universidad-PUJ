def QCR(A):
  A.sort()
  ans,low,n,ok,N = 0,A[0],True,len(A)
  while ok and low<A[len(A)-1] and n!=N:
    ok = A[n]<=low
    best,n = n,n+1
    while ok and n!=N and A[n][0]<=low:
      if A[n]>A[best]:
        best = n
      n += 1
    ans+=best
    low = A[best]
  ok = ok and low>=A[len(A)-1]
  if ok==False:
    ans = 0
  return ans