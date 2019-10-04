close
clear all

%graficos 3d

%z= -6*pi:0.1:6*pi;
%x= sin(z);
%y= cos(z);
%plot3(x,y,z)

%malla 3d
%grid on
%x= -3:0.1:3;
%y=x;
%[X,Y]=meshgrid(x,y);
%Z=X.^2+5*Y.^2;
%mesh(X,Y,Z)
%surf(X,Y,Z)

%x=-10:0.1:10;
%y=x;
%[X,Y]=meshgrid(x,y);
%Z1= sqrt(X.^2+Y.^2)./(X.^2+Y.^2+1);
%surf(X,Y,Z1)

%booleanos
%A=[4 5 -1 0];
%disp(A)
%dis('Hola')


%Matrices con for
for x=1 : 5
	A(x,1)=1;, A(1,x)=1;
endfor

for x=2:5
	for y=2:5
		A(x,y)= A(x-1,y)+A(x,y-1);
	endfor
endfor

A
