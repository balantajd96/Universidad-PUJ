math.randomseed(os.time())
--192.168.1.31
--math.random(0,100) para los fantasmas
socket = require "socket"

love.window.setTitle("Pacman")
love.window.setMode(600,600)

delta = 0
puntaje = 0
player= 0
skin = ''
--networking
conectado = false
modo = false
lastpacket = ""
get=""
reintento=0
reintentoIP=0

--system["ip"]='SERVER'/'CLIENTE{P1,P2,P3,P4}'
system={}
ipMaestro=""
serveroff=false
--map
map = {}

function love.load()
	logo = love.graphics.newImage("Resources/Menu/pacmanclip.png")
	logo2 = love.graphics.newImage("Resources/Menu/pacmanclip2.png")

	font = love.graphics.newFont("Resources/Font/Fipps-Regular.otf", 15)
	font2 = love.graphics.newFont("Resources/Font/ARCADE__.TTF", 15)

	text = ""
	love.keyboard.setKeyRepeat(true)
end

function love.draw()
	
	if conectado==false then
		love.graphics.setColor(1,1,1)
		love.graphics.draw(logo, 180, 50,0,0.2,0.2)
		love.graphics.draw(logo2, 500, 500,0,0.2,0.2)
		love.graphics.setFont(font)
		love.graphics.setColor(1,1,0)
		love.graphics.print("Bienvenido a Pacman Online",130,150,0)
		love.graphics.print("Digite la ip del servidor maestro y \n presione flecha arriba",100,250,0)
		love.graphics.printf(text, 50, 450, love.graphics.getWidth())
	else
		if serveroff==false then
			if get ~= nil then
				delta = delta + love.timer.getDelta( )			
			end
			love.graphics.setFont(font)
			love.graphics.setColor(0,0,0)
			love.graphics.print(string.format("Tiempo: %d",delta), 10, 10)
			love.graphics.print(string.format("Puntaje: %d",puntaje), 410, 10)
			love.graphics.print(string.format("Jugador: %d",player), 10, 70)
			distX=125
			distY=150
			love.graphics.setFont(font2)
			love.graphics.print(string.format(skin,player), 160, 80)
			love.graphics.setBackgroundColor(1,1,1)
			for i=0,#map do
				for j=0,#map[0] do
					if map[i][j] == nil then 
						love.graphics.print('#', distX, distY, 0)
					else
						love.graphics.print(map[i][j], distX, distY, 0)
					end
					distX= distX+20
				end
				distX=125
				distY=distY+20
			end
			love.graphics.setFont(font)
		else
			love.graphics.print("No hay servidores disponibles",130,150,0)
		end
	end
	
end

function love.update(dt)
	if modo == true then
		get,ip,port = udp:receivefrom()
		if get ~= nil then
			if get:sub(1,1) == "P" then
				conectado=true
				player=get:sub(2,2)
				if player =='1' then
					skin= 'p'
				elseif player =='2' then
					skin= 'y'
				elseif player =='3' then
					skin= 'l'
				elseif player =='4' then
					skin= 'f'
				end
			elseif get == "YoSoyMaestro" then
				ipMaestro=ip
			elseif get:sub(1,1) == "@" then
				GetIPText(get)
			else
				reintento = 0
				lastpacket = get
				udp:sendto("Maptrue",ip,port)
				--Recibe la matriz y la actualiza
				matrixUpdateText(get)
			end
		elseif conectado==true then
			udp:sendto("Maptrue",ipMaestro,2222)
			reintento = reintento + 1
			indice=0
			listaIP={}
			for k,v in pairs(system) do
				print(k,v)
				if v == "SERVER" then
					listaIP[indice]=k
					indice= indice + 1
				end
			end
			indice=0
		end
		if reintento >= 500 and player=="1" then
			if listaIP[indice] ~= nil then
				print("aiudaaaa")
				print(listaIP[indice])
				udp:sendto("MiMaestro",listaIP[indice],2222)
				if reintentoIP==100 then
					indice=indice+1
					reintentoIP=0
				end
				reintentoIP=reintentoIP+1
			else
				serveroff=true
			end
		end
	end
	
end

function cliente()
	modo=true
	matrixUpdateTable()
	udp = socket.udp()
	udp:setsockname("*",2222)
	udp:settimeout(0)
	udp:sendto("CLIENTE",ipMaestro,2222)
end

function love.textinput(key)
	text = text .. key
end

function love.keypressed(k)
	if k == "backspace" then
		text= borrarTexto(text)
	elseif k == "down" then
		text= text .. "\n"
	elseif k == "up" and conectado == false then
		ipMaestro= text
		cliente()
	elseif k == "w" and conectado == true then
		udp:sendto("up",ipMaestro,2222)
	elseif k == "s" and conectado == true then
		udp:sendto("down",ipMaestro,2222)
	elseif k == "a" and conectado == true then
			udp:sendto("left",ipMaestro,2222)
	elseif k == "d" and conectado == true then
			udp:sendto("right",ipMaestro,2222)	
	elseif k == "escape" then
		love.event.quit()
	end
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
			lineText= lineText .. textip:sub(i,i)
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
			elseif character =='b' then
			 	map[lineInd][characterInd]= 'h'
			elseif character =='c' then
			 	map[lineInd][characterInd]= 'h'
			elseif character =='d' then
			 	map[lineInd][characterInd]= 'h'
			elseif character =='1' then
			 	map[lineInd][characterInd]= 'p'
			elseif character =='2' then
			 	map[lineInd][characterInd]= 'y'
			elseif character =='3' then
			 	map[lineInd][characterInd]= 'l'
			elseif character =='4' then
			 	map[lineInd][characterInd]= 'f'
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