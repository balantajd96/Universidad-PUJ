math.randomseed(os.time())

--192.168.1.45
--172.17.1.129
--math.random(0,100) para los fantasmas
socket = require "socket"

love.window.setTitle("Pacman")
love.window.setMode(600,600)

--networking
Maestro = false
Esclavo = false
lastpacket = ""
get=""

--system["ip"]='SERVER'/'CLIENTE{P1,P2,P3,P4}'
system={}
ipMaestro=""
--map
map = {}

--positions
a={}
b={}
c={}
d={}

a1={}
b2={}
c3={}
d4={}

function love.load()
	logo = love.graphics.newImage("Resources/Menu/pacmanclip.png")
	logo2 = love.graphics.newImage("Resources/Menu/pacmanclip2.png")

	font = love.graphics.newFont("Resources/Font/Fipps-Regular.otf", 15)
	font2 = love.graphics.newFont("Resources/Font/ARCADE__.TTF", 15)

	text = ""
	love.keyboard.setKeyRepeat(true)
end

function love.draw()
	
	if Maestro then
		love.graphics.setBackgroundColor(0,0,0)
		love.graphics.setColor(1,1,1)
		love.graphics.print("Modo 'Servidor Maestro'",40,25,0)
		love.graphics.print("Escuchando...",50,75,0)
		if get ~= nil then
			love.graphics.print("Accedido", 50,175,0)
		end
	elseif Esclavo then
		love.graphics.setBackgroundColor(1,1,1)
		love.graphics.setColor(0,0,0)
		love.graphics.print("Modo 'Servidor Esclavo'",50,25,0)
		--love.graphics.print(lastpacket, 50,335,0)
		love.graphics.print("Digite la ip del 'Servidor Maestro',\npara continuar presione 'flecha arriba'",50,135,0)
		love.graphics.printf(text, 50, 255, love.graphics.getWidth())
		if get ~= nil then
			love.graphics.print("Conectado",50,315,0)
		end

	else
		love.graphics.draw(logo, 180, 50,0,0.2,0.2)
		love.graphics.draw(logo2, 500, 500,0,0.2,0.2)
		love.graphics.setFont(font)
		love.graphics.setColor(1,1,1)
		love.graphics.print("Bienvenido a Pacman Server",130,150,0)
		love.graphics.print("Presione 'm' para acceder al modo \n servidor maestro",100,250,0)
		love.graphics.print("Presione 'e' para acceder al modo \n servidor esclavo",100,350,0)
	end
	
end

function love.update(dt)
	
	if Maestro then
		get,ip,port = udp:receivefrom()
		if get ~= nil then
			lastpacket = get
			--adquiere las ip's
			if get == "SERVER" then
				if system[ip] == nil then--guarda la IP
					system[ip] = get
				else
					for k, v in pairs(system) do
						print(k,v)
					end
				end
			elseif get == "CLIENTE" then
				numeroPlayer=1
				for k, v in pairs(system) do
					if v~= "SERVER"then
						numeroPlayer = numeroPlayer+1
					end
				end
				if system[ip] ~= nil then
					numeroPlayer= numeroPlayer-1
				end
				system[ip] = string.format("P%d",numeroPlayer)
				udp:sendto(string.format("P%d",numeroPlayer),ip,port)
			--envia la informacion
			elseif get == "Maptrue" then
				udp:sendto(textIP(),ip,port)
				udp:sendto(matrixCreateText(),ip,port)
			end
		end
	elseif Esclavo then
		get,ip,port = udp:receivefrom()
		if get ~= nil then
			lastpacket = get
			if get == "MiMaestro" then
				Maestro = true
				Esclavo = false
				for k, v in pairs(system) do
					udp:sendto("yoSoyMaestro",k,2222)
				end
			elseif get == "yoSoyMaestro" then
				ipMaestro= ip
			elseif get:sub(1,1) == "@" then
				GetIPText(get)
			else
				udp:sendto("Maptrue",ip,port)
				--Recibe la matriz y la actualiza
				matrixUpdateText(get)

			end
		else
			udp:sendto("Maptrue",ipMaestro,2222)
		end
	end
	
end

function maestro()
	Maestro = true
	udp = socket.udp()
	udp:setsockname("*",2222)
	udp:settimeout(0)
end

function esclavo()
	Esclavo = true
	udp = socket.udp()
	udp:setsockname("*",2222)
	udp:settimeout(0)
end

function love.textinput(key)
	text = text .. key
end

function love.keypressed(key)
	if key == "e" and Esclavo == false then
		matrixUpdateTable()
		esclavo()
	elseif key == "m" and Maestro == false then
		matrixUpdateTable()
		maestro()

	elseif key == "escape" then
		love.event.quit()
	elseif(Esclavo== true) then
		if key == "backspace" then
			text= borrarTexto(text)
	    elseif key == "down" then
    	    text= text .. "\n"
	    elseif key == "up" then
    	    ipMaestro= text
    	    udp:sendto("SERVER",ipMaestro,2222)
    	    udp:sendto("Maptrue",ipMaestro,2222)
		end
	end
end

function textIP()
	textip="@"
	for k, v in pairs(system) do
		textip =textip .. k .. '-' .. v .. '_'
	end
	return textip
end

function GetIPText(textip)
	system={}
	ipText=""
	typeText=""
	lineText=""
	for i=2, #textip do
		if textip:sub(i,i)=='-' then
			ipText=lineText
			lineText=""
		elseif textip:sub(i,i)=='_' then
			typeText=lineText
			lineText=""
			system[ipText] = typeText
		else
			lineText = lineText .. textip:sub(i,i)
		end
	end
end

function matrixUpdateTable()
	filename = "1map.txt"
	lineInd=0

	for line in love.filesystem.lines(filename) do
		map[lineInd] = {}
		characterInd=0
		for character in line:gmatch"." do
			if character =='#' then
			 	map[lineInd][characterInd]= 'q'
			elseif character =='.' then
			 	map[lineInd][characterInd]= '9'
			elseif character =='-' then
			 	map[lineInd][characterInd]= ' '
			elseif character =='a' then
			 	map[lineInd][characterInd]= 'h'
			 	a[0]=lineInd
			 	a[1]=characterInd
			elseif character =='b' then
			 	map[lineInd][characterInd]= 'h'
			 	b[0]=lineInd
			 	b[1]=characterInd
			elseif character =='c' then
			 	map[lineInd][characterInd]= 'h'
			 	c[0]=lineInd
			 	c[1]=characterInd
			elseif character =='d' then
			 	map[lineInd][characterInd]= 'h'
			 	d[0]=lineInd
			 	d[1]=characterInd
			elseif character =='1' then
			 	map[lineInd][characterInd]= 'p'
			 	a1[0]=lineInd
			 	a1[1]=characterInd
			elseif character =='2' then
			 	map[lineInd][characterInd]= 'y'
			 	b2[0]=lineInd
			 	b2[1]=characterInd
			elseif character =='3' then
			 	map[lineInd][characterInd]= 'l'
			 	c3[0]=lineInd
			 	c3[1]=characterInd
			elseif character =='4' then
			 	map[lineInd][characterInd]= 'f'
			 	d4[0]=lineInd
			 	d4[1]=characterInd
			end
			characterInd=characterInd+1
		end
		lineInd = lineInd+1
	end
end

function matrixUpdateText(Maptext)
	map={}
	lineInd=0
	characterInd=0
	map[lineInd] = {}
	for i=1, #Maptext-1 do
		if(Maptext:sub(i,i)=='\n') then
			characterInd=0
			lineInd = lineInd+1
			map[lineInd] = {}
		else
			map[lineInd][characterInd]= Maptext:sub(i,i)
			characterInd=characterInd+1
		end
	end
end

function matrixCreateText()
	texto=""
	for i=0,#map do
		linea=""
		for j=0,#map[0] do
			linea=linea .. map[i][j]
	    end
	    texto=texto .. linea .. '\n'
	end
	return texto
end

function borrarTexto(text)
	nuevoTexto= ""
    for i=1, #text -1 do
    	nuevoTexto=nuevoTexto .. text:sub(i,i)
    end
    return nuevoTexto
end