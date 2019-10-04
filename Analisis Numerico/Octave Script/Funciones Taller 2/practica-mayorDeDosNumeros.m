%Defina una funcion que de el mayor de 2 numeros dados
function resultado= practica-mayorDeDosNumeros(x,y)
	if(y>x)
		resultado=y;
	elseif(x>y)
		resultado=x;
	else
		resultado=nil;
	endif
endfunction
