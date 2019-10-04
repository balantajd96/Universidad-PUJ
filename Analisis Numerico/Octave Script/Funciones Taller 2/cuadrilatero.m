%Diseñe una función que dados los vertices de un cuadrilátero: 
%Grafique el cuadrilátero, susdiagonales y el punto en que se cortan.(cuadrilatero.m)

function resultado=cuadrilatero(x1,y1,x2,y2,x3,y3,x4,y4)
  x=[x1 x2 x3 x4 x1]; , y=[y1 y2 y3 y4 y1];
  a=(x,y)  % to plot polygon
  b=([x1 x3],[y1 y3])
  c=([x4 x2],[y4 y2])
  d=([x2/x3 x2/x3], [y2 y4]) 
  plot(a,b,c,d)
endfunction
