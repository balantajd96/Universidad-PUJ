math.randomseed(os.time())
--192.168.1.31
--Network Variables
socket = require "socket"
udp = socket.udp()
udp:settimeout(0)
udp:setsockname("*",2222)--general port for this game is 2222
get = nil
updaterate = 0.5 -- how long to wait, in seconds, before requesting an update
time = 0
timeSend = 0

--Server Variables
serverStatus = ""-- WON,LOSE, nil
serverType={}--serverType["ip"]='SERVER'/'CLIENT{P1,P2,P3,P4}'
masterServerIp= ''
connected = false
serverOff = false
reconnect=0
port = 2222
--Game Variables
world = {} -- the empty world-state
score = '0'
player= 0
skin = ''
delta = 0
dead=false

s1='0'
s2='0'
s3='0'
s4='0'
--Love Configuration

--window
love.window.setTitle("Pacman Cliente")
love.window.setMode(600,600)

--love functions
function love.textinput(key)
	textUser = textUser .. key
end

function love.keypressed(key)
	if connected == false then
		if key == "backspace" then
			textUser= eraseText(textUser)
		elseif key == "down" then
			textUser= textUser .. "\n"
		elseif key == "up"  then
			masterServerIp= textUser
			udp:sendto("CLIENT",masterServerIp,2222)
		elseif key == "escape" then
			love.event.quit()
		end
	else
		if timeSend >= 0.5 then
			if key == "w"  then
				udp:sendto("UP",masterServerIp,2222)
			elseif key == "s"  then
				udp:sendto("DOWN",masterServerIp,2222)
			elseif key == "a"  then
				udp:sendto("LEFT",masterServerIp,2222)
			elseif key == "d"  then
				udp:sendto("RIGHT",masterServerIp,2222)
			elseif key == "escape" then
				love.event.quit()
			elseif key == "1" then
				love.audio.stop(music1)
				love.audio.stop(music2)
				love.audio.stop(music3)
				love.audio.stop(music4)
				love.audio.stop(music5)
				love.audio.stop(music6)
				love.audio.stop(music7)
				love.audio.stop(music8)
				love.audio.stop(music9)
				love.audio.stop(music0)
				love.audio.play(music1)
				love.audio.stop(theme)
			elseif key == "2" then
				love.audio.stop(music1)
				love.audio.stop(music2)
				love.audio.stop(music3)
				love.audio.stop(music4)
				love.audio.stop(music5)
				love.audio.stop(music6)
				love.audio.stop(music7)
				love.audio.stop(music8)
				love.audio.stop(music9)
				love.audio.stop(music0)
				love.audio.play(music2)
				love.audio.stop(theme)
			elseif key == "3" then
				love.audio.stop(music1)
				love.audio.stop(music2)
				love.audio.stop(music3)
				love.audio.stop(music4)
				love.audio.stop(music5)
				love.audio.stop(music6)
				love.audio.stop(music7)
				love.audio.stop(music8)
				love.audio.stop(music9)
				love.audio.stop(music0)
				love.audio.play(music3)
				love.audio.stop(theme)
			elseif key == "4" then
				love.audio.stop(music1)
				love.audio.stop(music2)
				love.audio.stop(music3)
				love.audio.stop(music4)
				love.audio.stop(music5)
				love.audio.stop(music6)
				love.audio.stop(music7)
				love.audio.stop(music8)
				love.audio.stop(music9)
				love.audio.stop(music0)
				love.audio.play(music4)
				love.audio.stop(theme)
			elseif key == "5" then
				love.audio.stop(music1)
				love.audio.stop(music2)
				love.audio.stop(music3)
				love.audio.stop(music4)
				love.audio.stop(music5)
				love.audio.stop(music6)
				love.audio.stop(music7)
				love.audio.stop(music8)
				love.audio.stop(music9)
				love.audio.stop(music0)
				love.audio.play(music5)
				love.audio.stop(theme)
			elseif key == "6" then
				love.audio.stop(music1)
				love.audio.stop(music2)
				love.audio.stop(music3)
				love.audio.stop(music4)
				love.audio.stop(music5)
				love.audio.stop(music6)
				love.audio.stop(music7)
				love.audio.stop(music8)
				love.audio.stop(music9)
				love.audio.stop(music0)
				love.audio.play(music6)
				love.audio.stop(theme)
			elseif key == "7" then
				love.audio.stop(music1)
				love.audio.stop(music2)
				love.audio.stop(music3)
				love.audio.stop(music4)
				love.audio.stop(music5)
				love.audio.stop(music6)
				love.audio.stop(music7)
				love.audio.stop(music8)
				love.audio.stop(music9)
				love.audio.stop(music0)
				love.audio.play(music7)
				love.audio.stop(theme)
			elseif key == "8" then
				love.audio.stop(music1)
				love.audio.stop(music2)
				love.audio.stop(music3)
				love.audio.stop(music4)
				love.audio.stop(music5)
				love.audio.stop(music6)
				love.audio.stop(music7)
				love.audio.stop(music8)
				love.audio.stop(music9)
				love.audio.stop(music0)
				love.audio.play(music8)
				love.audio.stop(theme)
			elseif key == "9" then
				love.audio.stop(music1)
				love.audio.stop(music2)
				love.audio.stop(music3)
				love.audio.stop(music4)
				love.audio.stop(music5)
				love.audio.stop(music6)
				love.audio.stop(music7)
				love.audio.stop(music8)
				love.audio.stop(music9)
				love.audio.stop(music0)
				love.audio.play(music9)
				love.audio.stop(theme)
			elseif key == "0" then
				love.audio.stop(music1)
				love.audio.stop(music2)
				love.audio.stop(music3)
				love.audio.stop(music4)
				love.audio.stop(music5)
				love.audio.stop(music6)
				love.audio.stop(music7)
				love.audio.stop(music8)
				love.audio.stop(music9)
				love.audio.stop(music0)
				love.audio.play(music0)
				love.audio.stop(theme)
			end
			timeSend = 0
		end
	end
end

function love.load()
	logo = love.graphics.newImage("Resources/Menu/pacmanclip.png")
	logo2 = love.graphics.newImage("Resources/Menu/pacmanclip2.png")

	font = love.graphics.newFont("Resources/Font/Fipps-Regular.otf", 15)
	font2 = love.graphics.newFont("Resources/Font/ARCADE__.TTF", 15)

	textUser = ""
	love.keyboard.setKeyRepeat(true)

	matrixUpdateTable("1map.txt")
	theme = love.audio.newSource("Resources/Themes/Pac-man themeremixByArsenic1987.mp3", "stream")
	music1 = love.audio.newSource("Resources/Themes/StarWarsMainTheme.mp3", "stream")
	music2 = love.audio.newSource("Resources/Themes/StarWarsTheImperialMarch.mp3", "stream")
	music3 = love.audio.newSource("Resources/Themes/SupermanTheme.mp3", "stream")
	music4 = love.audio.newSource("Resources/Themes/PiratesOfTheCaribbeanThemeSong.mp3", "stream")
	music5 = love.audio.newSource("Resources/Themes/IndianaJonesThemeSong[HD].mp3", "stream")
	music6 = love.audio.newSource("Resources/Themes/HarryPotter-HedwigsTheme.mp3", "stream")
	music7 = love.audio.newSource("Resources/Themes/HaloThemeSongOriginal.mp3", "stream")
	music8 = love.audio.newSource("Resources/Themes/300OST-ReturnsaKing.mp3", "stream")
	music9 = love.audio.newSource("Resources/Themes/007JamesBond Theme.mp3", "stream")
	music0 = love.audio.newSource("Resources/Themes/BestringtonefromSamsungS8.mp3", "stream")
end

function love.draw()
	if connected==false then
		love.graphics.setColor(1,1,1)
		love.graphics.draw(logo, 180, 50,0,0.2,0.2)
		love.graphics.draw(logo2, 500, 500,0,0.2,0.2)
		love.graphics.setFont(font)
		love.graphics.setColor(1,1,0)
		love.graphics.print("Bienvenido a Pacman Online",130,150,0)
		love.graphics.print("Digite la ip del servidor maestro y \n presione flecha arriba",100,250,0)
		love.graphics.printf(textUser, 50, 450, love.graphics.getWidth())
	else
		if serverOff==false then
			if serverStatus == "" then
				delta = delta + love.timer.getDelta( )			
				love.graphics.setFont(font)
				love.graphics.setColor(0,0,0)
				love.graphics.print(string.format("Tiempo: %d",delta), 10, 10)
				love.graphics.print(string.format("Puntaje: %s",score), 410, 10)
				love.graphics.print(string.format("Jugador: %d",player), 10, 70)
				distX=125
				distY=150
				love.graphics.setFont(font2)
				love.graphics.print(skin, 160, 80)
				love.graphics.setBackgroundColor(1,1,1)
				for i=0,#world do
					for j=0,#world[0] do
						if world[i][j] == nil then 
							love.graphics.print('#', distX, distY, 0)
						else
							love.graphics.print(world[i][j], distX, distY, 0)
						end
						distX= distX+20
					end
					distX=125
					distY=distY+20
				end
				if dead == true then
					love.graphics.setFont(font)
					love.graphics.print("Has Muerto",240,70,0)
				end
			elseif serverStatus == "WON" then
				love.graphics.setFont(font)
				love.graphics.setColor(0,0,0)
				love.graphics.setBackgroundColor(1,1,1)
				love.graphics.print("!Lo han logrado!",180,50,0)
				love.graphics.print(string.format("Puntaje jugador 1      : %s",s1),130,150,0)
				love.graphics.print(string.format("Puntaje jugador 2      : %s",s2),130,200,0)
				love.graphics.print(string.format("Puntaje jugador 3      : %s",s3),130,250,0)
				love.graphics.print(string.format("Puntaje jugador 4      : %s",s4),130,300,0)
				love.graphics.setFont(font2)
				love.graphics.print("p", 358, 156)
				love.graphics.print("y", 358, 206)
				love.graphics.print("l", 358, 256)
				love.graphics.print("f", 358, 306)
			elseif serverStatus == "LOSE" then
				love.graphics.setFont(font)
				love.graphics.setColor(1,0,0)
				love.graphics.setBackgroundColor(1,1,1)
				love.graphics.print("!Perdieron!",210,50,0)
				love.graphics.print(string.format("Puntaje jugador 1      : %s",s1),130,150,0)
				love.graphics.print(string.format("Puntaje jugador 2      : %s",s2),130,200,0)
				love.graphics.print(string.format("Puntaje jugador 3      : %s",s3),130,250,0)
				love.graphics.print(string.format("Puntaje jugador 4      : %s",s4),130,300,0)
				love.graphics.setFont(font2)
				love.graphics.print("p", 358, 156)
				love.graphics.print("y", 358, 206)
				love.graphics.print("l", 358, 256)
				love.graphics.print("f", 358, 306)
			end
		else
			love.graphics.setFont(font)
			love.graphics.print("No hay servidores disponibles",130,150,0)
		end
	end
	
end

function love.update(dt)
	time = time + dt
	timeSend = timeSend  + dt
	if connected == true then
		get,ip,port = udp:receivefrom()
		if get ~= nil then
			reconnect=0
			serverOff = false
			if get:sub(1,1) == "P" then
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
			elseif get == "IMTHEMASTER" then
				masterServerIp=ip
			elseif get:sub(1,1) == "@" then
				GetIPText(get)
				print(serverType)
			elseif get:sub(1,1) == "&" then
				updateTextScores(get)
			elseif get:sub(1,1) == "+" then
				score=get:sub(2,#get)
			elseif get == "DEAD" then
				dead=true
			elseif get == "OFFSERVER" then
				love.graphics.setFont(font)
				serverOff=true
			elseif get == "WON" then
				serverStatus = "WON"
			elseif get == "LOSE" then
				serverStatus = "LOSE"
			else
				matrixUpdateText(get)
			end
		else
			if time > updaterate then
				if reconnect < 25 then
					udp:sendto("UPDATEMAP",masterServerIp,2222)
					reconnect = reconnect + 1
					index=0
					ipList={}
					for k,v in pairs(serverType) do
						print(k,v)
						if v == "SERVER" then
							ipList[index]=k
							index= index + 1
						end
					end
					index=0
					time=0
					reconnectIP=0
				elseif player=="1" then
					print("intentando")
					if ipList[index] ~= nil then
						print(ipList[index])
						udp:sendto("NEWMASTER",ipList[index],2222)
						if reconnectIP>=25 then
							index=index+1
							reconnectIP=0
						end
						reconnectIP=reconnectIP+1
					else
						serverOff=true
						for k,v in pairs(serverType) do
							print(k,v)
							if v ~= "SERVER" then
								udp:sendto("OFFSERVER",k,2222)	
							end
						end
					end
				end
			end
		end
	else
		get,ip,port = udp:receivefrom()
		if get ~= nil then
			if get == "CONNECTED" then
				connected= true
				love.audio.play(theme)
			end
		end
	end
end

--Extra tools
function matrixUpdateTable(filename)
	local lineInd=0

	for line in love.filesystem.lines(filename) do
		world[lineInd] = {}
		local characterInd=0
		for character in line:gmatch"." do
			if character =='#' then
			 	world[lineInd][characterInd]= 'q'
			elseif character =='.' then
			 	world[lineInd][characterInd]= '9'
			elseif character =='-' then
			 	world[lineInd][characterInd]= ' '
			elseif character =='a' then
			 	world[lineInd][characterInd]= 'h'
			elseif character =='b' then
			 	world[lineInd][characterInd]= 'h'
			elseif character =='c' then
			 	world[lineInd][characterInd]= 'h'
			elseif character =='d' then
			 	world[lineInd][characterInd]= 'h'
			elseif character =='1' then
			 	world[lineInd][characterInd]= 'p'
			elseif character =='2' then
			 	world[lineInd][characterInd]= 'y'
			elseif character =='3' then
			 	world[lineInd][characterInd]= 'l'
			elseif character =='4' then
			 	world[lineInd][characterInd]= 'f'
			end
			characterInd=characterInd+1
		end
		lineInd = lineInd+1
	end
end

function matrixUpdateText(worldtext)
	world={}
	lineInd=0
	characterInd=0
	world[lineInd] = {}
	for i=1, #worldtext-1 do
		if(worldtext:sub(i,i)=='\n') then
			characterInd=0
			lineInd = lineInd+1
			world[lineInd] = {}
		else
			world[lineInd][characterInd]= worldtext:sub(i,i)
			characterInd=characterInd+1
		end
	end
end

function matrixCreateText()
	texto=""
	for i=0,#world do
		linea=""
		for j=0,#world[0] do
			linea=linea .. world[i][j]
	    end
	    texto=texto .. linea .. '\n'
	end
	return texto
end

--Text functions
function eraseText(text)
	nuevoTexto= ""
    for i=1, #text -1 do
    	nuevoTexto=nuevoTexto .. text:sub(i,i)
    end
    return nuevoTexto
end

function textIP()
	local textip="@"
	for k, v in pairs(system) do
		textip =textip .. k .. '-' .. v .. '_'
	end
	return textip
end

function GetIPText(textip)
	serverType={}
	local ipText=""
	local typeText=""
	local lineText=""
	for i=2, #textip do
		if textip:sub(i,i)=='-' then
			ipText=lineText
			lineText=""
		elseif textip:sub(i,i)=='_' then
			typeText=lineText
			lineText=""
			serverType[ipText] = typeText
		else
			lineText = lineText .. textip:sub(i,i)
		end
	end
end

function updateTextScores(textScore)
	local index =1
	local newScore= ""
	for i=2, #textScore do
		if textScore:sub(i,i) == '-' then
			if index == 1 then
				s1=tonumber(newScore)
				index =2
			elseif index == 2 then
				s2=tonumber(newScore)
				index =3
			elseif index == 3 then
				s3=tonumber(newScore)
				index =4
			elseif index == 4 then
				s4=tonumber(newScore)
				index =0
			end
			newScore= ""
		else
			newScore=newScore .. textScore:sub(i,i)
		end
	end
end