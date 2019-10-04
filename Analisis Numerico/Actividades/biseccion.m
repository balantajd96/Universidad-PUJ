function biseccion(func,low,high,tol,N)
  for i = 0:N
    middle= (low+hi)/2;
    flow=func(low)
    fhigh=func(high)
    fmid=func(middle)
    if (flow * fmid)>=0
      high= middle
    endif
    if (fmid * fhigh)>=0
      low= middle
    endif
  endfor
endfunction