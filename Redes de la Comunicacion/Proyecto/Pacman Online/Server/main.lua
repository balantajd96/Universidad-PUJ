--Network Variables
socket = require "socket"
udp = socket.udp()
udp:settimeout(0)
udp:setsockname("*",2222)--general port for this game is 2222
get = nil
updaterate = 0.1 -- how long to wait, in seconds, before requesting an update
time = 0

--Server Variables
masterServerIp= ''
serverType={}--serverType["ip"]='SERVER'/'CLIENT{P1,P2,P3,P4}'
serverMode = ''--master/slave
connected = false
timeGhost = 0
canMove = false
offTime = 0

--Game Variables
world = {} -- the empty world-state
statusGame=nil
mapORscoreORitems="map"

--Positions

--ghosts
ghost=1
a={}
b={}
c={}
d={}

--ghost items
saveItemA = " "
saveItemB = " "
saveItemC = " "
saveItemD = " "

--players
a1={}
b2={}
c3={}
d4={}

--players
isDead1=nil
isDead2=nil
isDead3=nil
isDead4=nil

--score players total score 127
s1=0
s2=0
s3=0
s4=0
--Love Configuration

--window
love.window.setTitle("Pacman Servidor")
love.window.setMode(600,600)

--love functions
function love.textinput(key)
	textUser = textUser .. key
end

function love.keypressed(key)
	if key == "e" and serverMode ~= 'slave' then
		serverMode = 'slave'
	elseif key == "m" and serverMode ~= 'master' then
		serverMode = 'master'
	elseif key == "escape" then
		love.event.quit()
	elseif serverMode == 'slave' then
		if key == "backspace" then
			textUser= eraseText(textUser)
	    elseif key == "down" then
    	    textUser= textUser .. "\n"
	    elseif key == "up" then
    	    masterServerIp= textUser
    	    udp:sendto("SERVER",masterServerIp,2222)
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
end

function love.draw()
	if serverMode == 'master' then
		love.graphics.setBackgroundColor(0,0,0)
		love.graphics.setColor(1,1,1)
		love.graphics.print("Modo 'Servidor Maestro'",40,25,0)
		love.graphics.print("Escuchando...",50,75,0)
		if get ~= nil then
			love.graphics.print("Accedido", 50,175,0)
		end
	elseif serverMode == 'slave' then
		love.graphics.setBackgroundColor(1,1,1)
		love.graphics.setColor(0,0,0)
		love.graphics.print("Modo 'Servidor Esclavo'",50,25,0)
		--love.graphics.print(lastpacket, 50,335,0)
		love.graphics.print("Digite la ip del 'Servidor Maestro',\npara continuar presione 'flecha arriba'",50,135,0)
		love.graphics.printf(textUser, 50, 255, love.graphics.getWidth())
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
	time = time + dt
	timeGhost = timeGhost + dt
	if serverMode == 'master' then
		get,ip,port = udp:receivefrom()
		if get ~= nil then
			offTime= 0
			--get the ip's
			if get == "SERVER" then
				udp:sendto("CONNECTED",ip,port)
				if serverType[ip] == nil then--save the IP
					serverType[ip] = get
					textip=textIP(serverType)
					for k, v in pairs(serverType) do
						udp:sendto(textip,k,port)
					end
				else
					for k, v in pairs(serverType) do
						print(k,v)
					end
				end
			elseif get == "CLIENT" then
				canMove = true
				udp:sendto("CONNECTED",ip,port)
				if serverType[ip] == nil then
					numberPlayer=1
					for k, v in pairs(serverType) do
						if v~= "SERVER"then
							numberPlayer = numberPlayer+1
						end
					end
					serverType[ip] = string.format("P%d",numberPlayer)
					udp:sendto(serverType[ip],ip,port)
					textip=textIP(serverType)
					for k, v in pairs(serverType) do
						udp:sendto(textip,k,port)
					end
				else 
					udp:sendto(serverType[ip],ip,port)
					if serverType[ip] == "P1" then
						udp:sendto(string.format("+%d",s1),ip,port)
						if isDead1 == true then
							udp:sendto("DEAD",ip,port)
						end
					elseif serverType[ip] == "P2" then
						udp:sendto(string.format("+%d",s2),ip,port)
						if isDead2 == true then
							udp:sendto("DEAD",ip,port)
						end
					elseif serverType[ip] == "P3" then
						udp:sendto(string.format("+%d",s3),ip,port)
						if isDead3 == true then
							udp:sendto("DEAD",ip,port)
						end
					elseif serverType[ip] == "P4" then
						udp:sendto(string.format("+%d",s4),ip,port)
						if isDead4 == true then
							udp:sendto("DEAD",ip,port)
						end
					end
				end
			--send the information
			elseif get == "UPDATEIP" then
				textip=textIP(serverType)
				udp:sendto(textip,ip,port)
			elseif get == "UPDATEMAP" then
				udp:sendto(matrixCreateText(),ip,port)
			elseif get == "UPDATESCORE" then
				udp:sendto(textScores(),ip,port)
			elseif get == "UPDATEITEM" then
				udp:sendto(textItems(),ip,port)
			elseif get == "UP" or get == "DOWN" or get == "LEFT" or get == "RIGHT" then
				for k, v in pairs(serverType) do
					if k==ip then
						moveMatrix(v,get,ip,port)
					end
				end
			elseif get == "NEWMASTER" then
				for k, v in pairs(serverType) do
					udp:sendto("IMTHEMASTER",k,2222)
				end
				canMove = true
			end
		else
			offTime = offTime + 1
		end
	elseif serverMode == 'slave' then -- the slave
		get,ip,port = udp:receivefrom()
		if get ~= nil then
			if get == "NEWMASTER" then
				matrixUpdatePositions()
				serverMode = 'master'
				for k, v in pairs(serverType) do
					udp:sendto("IMTHEMASTER",k,2222)
				end
				canMove = true
			elseif get == "IMTHEMASTER" then
				masterServerIp= ip
			elseif get == "CONNECTED" then
				connected=true
			elseif get:sub(1,1) == "@" then
				GetIPText(get)
			elseif get:sub(1,1) == "&" then
				updateTextScores(get)
			elseif get:sub(1,1) == "%" then
				updateTextItems(get)
			else
				matrixUpdateText(get)
			end
		end
		if connected == true then
			if time > updaterate then
				if mapORscoreORitems== "map" then
					udp:sendto("UPDATEMAP",masterServerIp,2222)
					mapORscoreORitems="score"
				elseif mapORscoreORitems== "score" then
					udp:sendto("UPDATESCORE",masterServerIp,2222)
					mapORscoreORitems="item"
				elseif mapORscoreORitems== "item" then
					udp:sendto("UPDATEITEM",masterServerIp,2222)
					mapORscoreORitems="map"
				end
				time=0
			end
		end
	end
	if timeGhost >= 0.5 and canMove == true then
		moveGhost("a",math.random(1,4))
		moveGhost("b",math.random(1,4))
		moveGhost("c",math.random(1,4))
		moveGhost("d",math.random(1,4))
		timeGhost = 0
	end
	
	if s1+s2+s3+s4 >=125 then
		for k, v in pairs(serverType) do
			if v~= "SERVER"then
				udp:sendto(textScores(),k,2222)
				udp:sendto("WON",k,2222)
			end
		end
	elseif isDead1== true and isDead2== true and isDead3== true and isDead4== true then
		for k, v in pairs(serverType) do
			if v~= "SERVER"then
				udp:sendto(textScores(),k,2222)
				udp:sendto("LOSE",k,2222)
			end
		end
	end
	if offTime >= 200 then
		canMove = false
		offTime = 0
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
			 	a[0]=lineInd
			 	a[1]=characterInd
			elseif character =='b' then
			 	world[lineInd][characterInd]= 'h'
			 	b[0]=lineInd
			 	b[1]=characterInd
			elseif character =='c' then
			 	world[lineInd][characterInd]= 'h'
			 	c[0]=lineInd
			 	c[1]=characterInd
			elseif character =='d' then
			 	world[lineInd][characterInd]= 'h'
			 	d[0]=lineInd
			 	d[1]=characterInd
			elseif character =='1' then
			 	world[lineInd][characterInd]= 'p'
			 	a1[0]=lineInd
			 	a1[1]=characterInd
			elseif character =='2' then
			 	world[lineInd][characterInd]= 'y'
			 	b2[0]=lineInd
			 	b2[1]=characterInd
			elseif character =='3' then
			 	world[lineInd][characterInd]= 'l'
			 	c3[0]=lineInd
			 	c3[1]=characterInd
			elseif character =='4' then
			 	world[lineInd][characterInd]= 'f'
			 	d4[0]=lineInd
			 	d4[1]=characterInd
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
	local text=""
	for i=0,#world do
		local line=""
		for j=0,#world[0] do
			line=line .. world[i][j]
	    end
	    text=text .. line .. '\n'
	end
	return text
end

function matrixUpdatePositions()
	isDead1=true
	isDead2=true
	isDead3=true
	isDead4=true
	for i=0,#world do
		for j=0,#world[0] do
			if world[i][j]=='h' and ghost==1 then
				a[0]=i
			 	a[1]=j
			 	ghost=2
			elseif world[i][j]=='h' and ghost==2 then
				b[0]=i
			 	b[1]=j
			 	ghost=3
			elseif world[i][j]=='h' and ghost==3 then
				c[0]=i
			 	c[1]=j
			 	ghost=4
			elseif world[i][j]=='h' and ghost==4 then
				d[0]=i
			 	d[1]=j
			 	ghost=0
			elseif world[i][j]=='p' then
				isDead1=nil
				a1[0]=i
			 	a1[1]=j
			elseif world[i][j]=='y' then
				isDead2=nil
				b2[0]=i
			 	b2[1]=j
			elseif world[i][j]=='l' then
				isDead3=nil
				c3[0]=i
			 	c3[1]=j
			elseif world[i][j]=='f' then
				isDead4=nil
				d4[0]=i
			 	d4[1]=j
			end
	    end
	end
end

function  moveGhost(ghost,command)
	--command: 1=UP, 2=DOWN, 3=LEFT, 4= RIGHT
	------
	if ghost== "a" then
		if command == 1 then--UP
			if world[a[0]-1][a[1]]== '9' then
				world[a[0]][a[1]]= saveItemA
				saveItemA='9'
				a[0]=a[0]-1
				world[a[0]][a[1]]= 'h'
			elseif world[a[0]-1][a[1]]== ' ' then
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[0]=a[0]-1
				world[a[0]][a[1]]= 'h'
			elseif world[a[0]-1][a[1]]== 'p' then --P1
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[0]=a[0]-1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[a[0]-1][a[1]]== 'y' then --P2
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[0]=a[0]-1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[a[0]-1][a[1]]== 'l' then --P3
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[0]=a[0]-1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[a[0]-1][a[1]]== 'f' then --P4
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[0]=a[0]-1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 2 then--DOWN
			if world[a[0]+1][a[1]]== '9' then
				world[a[0]][a[1]]= saveItemA
				saveItemA='9'
				a[0]=a[0]+1
				world[a[0]][a[1]]= 'h'
			elseif world[a[0]+1][a[1]]== ' ' then
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[0]=a[0]+1
				world[a[0]][a[1]]= 'h'
			elseif world[a[0]+1][a[1]]== 'p' then --P1
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[0]=a[0]+1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[a[0]+1][a[1]]== 'y' then --P2
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[0]=a[0]+1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[a[0]+1][a[1]]== 'l' then --P3
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[0]=a[0]+1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[a[0]+1][a[1]]== 'f' then --P4
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[0]=a[0]+1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 3 then--LEFT
			if world[a[0]][a[1]-1]== '9' then
				world[a[0]][a[1]]= saveItemA
				saveItemA='9'
				a[1]=a[1]-1
				world[a[0]][a[1]]= 'h'
			elseif world[a[0]][a[1]-1]== ' ' then
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[1]=a[1]-1
				world[a[0]][a[1]]= 'h'
			elseif world[a[0]][a[1]-1]== 'p' then --P1
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[1]=a[1]-1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[a[0]][a[1]-1]== 'y' then --P2
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[1]=a[1]-1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[a[0]][a[1]-1]== 'l' then --P3
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[1]=a[1]-1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[a[0]][a[1]-1]== 'f' then --P4
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[1]=a[1]-1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 4 then--RIGHT
			if world[a[0]][a[1]+1]== '9' then
				world[a[0]][a[1]]= saveItemA
				saveItemA='9'
				a[1]=a[1]+1
				world[a[0]][a[1]]= 'h'
			elseif world[a[0]][a[1]+1]== ' ' then
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[1]=a[1]+1
				world[a[0]][a[1]]= 'h'
			elseif world[a[0]][a[1]+1]== 'p' then --P1
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[1]=a[1]+1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[a[0]][a[1]+1]== 'y' then --P2
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[1]=a[1]+1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[a[0]][a[1]+1]== 'l' then --P3
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[1]=a[1]+1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[a[0]][a[1]+1]== 'f' then --P4
				world[a[0]][a[1]]= saveItemA
				saveItemA=' '
				a[1]=a[1]+1
				world[a[0]][a[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		end
	elseif ghost== "b" then-- ghost b
		if command == 1 then--UP
			if world[b[0]-1][b[1]]== '9' then
				world[b[0]][b[1]]= saveItemB
				saveItemb='9'
				b[0]=b[0]-1
				world[b[0]][b[1]]= 'h'
			elseif world[b[0]-1][b[1]]== ' ' then
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[0]=b[0]-1
				world[b[0]][b[1]]= 'h'
			elseif world[b[0]-1][b[1]]== 'p' then --P1
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[0]=b[0]-1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[b[0]-1][b[1]]== 'y' then --P2
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[0]=b[0]-1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[b[0]-1][b[1]]== 'l' then --P3
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[0]=b[0]-1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[b[0]-1][b[1]]== 'f' then --P4
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[0]=b[0]-1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 2 then--DOWN
			if world[b[0]+1][b[1]]== '9' then
				world[b[0]][b[1]]= saveItemB
				saveItemB='9'
				b[0]=b[0]+1
				world[b[0]][b[1]]= 'h'
			elseif world[b[0]+1][b[1]]== ' ' then
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[0]=b[0]+1
				world[b[0]][b[1]]= 'h'
			elseif world[b[0]+1][b[1]]== 'p' then --P1
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[0]=b[0]+1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[b[0]+1][b[1]]== 'y' then --P2
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[0]=b[0]+1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[b[0]+1][b[1]]== 'l' then --P3
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[0]=b[0]+1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[b[0]+1][b[1]]== 'f' then --P4
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[0]=b[0]+1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 3 then--LEFT
			if world[b[0]][b[1]-1]== '9' then
				world[b[0]][b[1]]= saveItemB
				saveItemB='9'
				b[1]=b[1]-1
				world[b[0]][b[1]]= 'h'
			elseif world[b[0]][b[1]-1]== ' ' then
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[1]=b[1]-1
				world[b[0]][b[1]]= 'h'
			elseif world[b[0]][b[1]-1]== 'p' then --P1
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[1]=b[1]-1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[b[0]][b[1]-1]== 'y' then --P2
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[1]=b[1]-1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[b[0]][b[1]-1]== 'l' then --P3
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[1]=b[1]-1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[b[0]][b[1]-1]== 'f' then --P4
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[1]=b[1]-1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 4 then--RIGHT
			if world[b[0]][b[1]+1]== '9' then
				world[b[0]][b[1]]= saveItemB
				saveItemB='9'
				b[1]=b[1]+1
				world[b[0]][b[1]]= 'h'
			elseif world[b[0]][b[1]+1]== ' ' then
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[1]=b[1]+1
				world[b[0]][b[1]]= 'h'
			elseif world[b[0]][b[1]+1]== 'p' then --P1
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[1]=b[1]+1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[b[0]][b[1]+1]== 'y' then --P2
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[1]=b[1]+1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[b[0]][b[1]+1]== 'l' then --P3
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[1]=b[1]+1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[b[0]][b[1]+1]== 'f' then --P4
				world[b[0]][b[1]]= saveItemB
				saveItemB=' '
				b[1]=b[1]+1
				world[b[0]][b[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		end
		------
	elseif ghost== "c" then-- ghost c
		if command == 1 then--UP
			if world[c[0]-1][c[1]]== '9' then
				world[c[0]][c[1]]= saveItemC
				saveItemC='9'
				c[0]=c[0]-1
				world[c[0]][c[1]]= 'h'
			elseif world[c[0]-1][c[1]]== ' ' then
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[0]=c[0]-1
				world[c[0]][c[1]]= 'h'
			elseif world[c[0]-1][c[1]]== 'p' then --P1
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[0]=c[0]-1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[c[0]-1][c[1]]== 'y' then --P2
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[0]=c[0]-1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[c[0]-1][c[1]]== 'l' then --P3
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[0]=c[0]-1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[c[0]-1][c[1]]== 'f' then --P4
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[0]=c[0]-1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 2 then--DOWN
			if world[c[0]+1][c[1]]== '9' then
				world[c[0]][c[1]]= saveItemC
				saveItemC='9'
				c[0]=c[0]+1
				world[c[0]][c[1]]= 'h'
			elseif world[c[0]+1][c[1]]== ' ' then
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[0]=c[0]+1
				world[c[0]][c[1]]= 'h'
			elseif world[c[0]+1][c[1]]== 'p' then --P1
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[0]=c[0]+1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[c[0]+1][c[1]]== 'y' then --P2
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[0]=c[0]+1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[c[0]+1][c[1]]== 'l' then --P3
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[0]=c[0]+1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[c[0]+1][c[1]]== 'f' then --P4
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[0]=c[0]+1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 3 then--LEFT
			if world[c[0]][c[1]-1]== '9' then
				world[c[0]][c[1]]= saveItemC
				saveItemC='9'
				c[1]=c[1]-1
				world[c[0]][c[1]]= 'h'
			elseif world[c[0]][c[1]-1]== ' ' then
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[1]=c[1]-1
				world[c[0]][c[1]]= 'h'
			elseif world[c[0]][c[1]-1]== 'p' then --P1
				world[c[0]][c[1]]= saveItemc
				saveItemc=' '
				c[1]=c[1]-1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[c[0]][c[1]-1]== 'y' then --P2
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[1]=c[1]-1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[c[0]][c[1]-1]== 'l' then --P3
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[1]=c[1]-1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[c[0]][c[1]-1]== 'f' then --P4
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[1]=c[1]-1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 4 then--RIGHT
			if world[c[0]][c[1]+1]== '9' then
				world[c[0]][c[1]]= saveItemC
				saveItemC='9'
				c[1]=c[1]+1
				world[c[0]][c[1]]= 'h'
			elseif world[c[0]][c[1]+1]== ' ' then
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[1]=c[1]+1
				world[c[0]][c[1]]= 'h'
			elseif world[c[0]][c[1]+1]== 'p' then --P1
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[1]=c[1]+1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[c[0]][c[1]+1]== 'y' then --P2
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[1]=c[1]+1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[c[0]][c[1]+1]== 'l' then --P3
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[1]=c[1]+1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[c[0]][c[1]+1]== 'f' then --P4
				world[c[0]][c[1]]= saveItemC
				saveItemC=' '
				c[1]=c[1]+1
				world[c[0]][c[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		end
	elseif ghost== "d" then-- ghost d
		if command == 1 then--UP
			if world[d[0]-1][d[1]]== '9' then
				world[d[0]][d[1]]= saveItemD
				saveItemD='9'
				d[0]=d[0]-1
				world[d[0]][d[1]]= 'h'
			elseif world[d[0]-1][d[1]]== ' ' then
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[0]=d[0]-1
				world[d[0]][d[1]]= 'h'
			elseif world[d[0]-1][d[1]]== 'p' then --P1
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[0]=d[0]-1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[d[0]-1][d[1]]== 'y' then --P2
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[0]=d[0]-1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[d[0]-1][d[1]]== 'l' then --P3
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[0]=d[0]-1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[d[0]-1][d[1]]== 'f' then --P4
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[0]=d[0]-1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 2 then--DOWN
			if world[d[0]+1][d[1]]== '9' then
				world[d[0]][d[1]]= saveItemD
				saveItemd='9'
				d[0]=d[0]+1
				world[d[0]][d[1]]= 'h'
			elseif world[d[0]+1][d[1]]== ' ' then
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[0]=d[0]+1
				world[d[0]][d[1]]= 'h'
			elseif world[d[0]+1][d[1]]== 'p' then --P1
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[0]=d[0]+1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[d[0]+1][d[1]]== 'y' then --P2
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[0]=d[0]+1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[d[0]+1][d[1]]== 'l' then --P3
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[0]=d[0]+1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[d[0]+1][d[1]]== 'f' then --P4
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[0]=d[0]+1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 3 then--LEFT
			if world[d[0]][d[1]-1]== '9' then
				world[d[0]][d[1]]= saveItemD
				saveItemD='9'
				d[1]=d[1]-1
				world[d[0]][d[1]]= 'h'
			elseif world[d[0]][d[1]-1]== ' ' then
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[1]=d[1]-1
				world[d[0]][d[1]]= 'h'
			elseif world[d[0]][d[1]-1]== 'p' then --P1
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[1]=d[1]-1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[d[0]][d[1]-1]== 'y' then --P2
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[1]=d[1]-1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[d[0]][d[1]-1]== 'l' then --P3
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[1]=d[1]-1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[d[0]][d[1]-1]== 'f' then --P4
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[1]=d[1]-1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		elseif command == 4 then--RIGHT
			if world[d[0]][d[1]+1]== '9' then
				world[d[0]][d[1]]= saveItemD
				saveItemD='9'
				d[1]=d[1]+1
				world[d[0]][d[1]]= 'h'
			elseif world[d[0]][d[1]+1]== ' ' then
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[1]=d[1]+1
				world[d[0]][d[1]]= 'h'
			elseif world[d[0]][d[1]+1]== 'p' then --P1
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[1]=d[1]+1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P1" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead1=true
			elseif world[d[0]][d[1]+1]== 'y' then --P2
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[1]=d[1]+1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P2" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead2=true
			elseif world[d[0]][d[1]+1]== 'l' then --P3
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[1]=d[1]+1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P3" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead3=true
			elseif world[d[0]][d[1]+1]== 'f' then --P4
				world[d[0]][d[1]]= saveItemD
				saveItemD=' '
				d[1]=d[1]+1
				world[d[0]][d[1]]= 'h'
				for k, v in pairs(serverType) do
					if v == "P4" then
						udp:sendto("DEAD",k,2222)
					end
				end
				isDead4=true
			end
		end
	end
end
----------------
function  moveMatrix(entity,command,ip,port)
	if entity == 'P1' and isDead1 ~= true then
		if command == "UP" then
			if world[a1[0]-1][a1[1]]== '9' then
				world[a1[0]][a1[1]]= ' '
				a1[0]=a1[0]-1
				world[a1[0]][a1[1]]= 'p'
				s1=s1+1
				udp:sendto(string.format("+%d",s1),ip,port)
			elseif world[a1[0]-1][a1[1]]== 'q' then
				print('un muro',entity)
			elseif world[a1[0]-1][a1[1]]== ' ' then
				world[a1[0]][a1[1]]= ' '
				a1[0]=a1[0]-1
				world[a1[0]][a1[1]]= 'p'
			elseif world[a1[0]-1][a1[1]]== 'h' then
				world[a1[0]][a1[1]]= ' '
				udp:sendto(string.format("DEAD",s1),ip,port)
				isDead1=true
			end
		elseif command == "DOWN" then
			if world[a1[0]+1][a1[1]]== '9' then
				world[a1[0]][a1[1]]= ' '
				a1[0]=a1[0]+1
				world[a1[0]][a1[1]]= 'p'
				s1=s1+1
				udp:sendto(string.format("+%d",s1),ip,port)
			elseif world[a1[0]+1][a1[1]]== 'q' then
				print('un muro',entity)
			elseif world[a1[0]+1][a1[1]]== ' ' then
				world[a1[0]][a1[1]]= ' '
				a1[0]=a1[0]+1
				world[a1[0]][a1[1]]= 'p'
			elseif world[a1[0]+1][a1[1]]== 'h' then
				world[a1[0]][a1[1]]= ' '
				udp:sendto(string.format("DEAD",s1),ip,port)
				isDead1=true
			end
		elseif command == "LEFT" then
			if world[a1[0]][a1[1]-1]== '9' then
				world[a1[0]][a1[1]]= ' '
				a1[1]=a1[1]-1
				world[a1[0]][a1[1]]= 'p'
				s1=s1+1
				udp:sendto(string.format("+%d",s1),ip,port)
			elseif world[a1[0]][a1[1]-1]== 'q' then
				print('un muro',entity)
			elseif world[a1[0]][a1[1]-1]== ' ' then
				world[a1[0]][a1[1]]= ' '
				a1[1]=a1[1]-1
				world[a1[0]][a1[1]]= 'p'
			elseif world[a1[0]][a1[1]-1]== 'h' then
				world[a1[0]][a[1]]= ' '
				udp:sendto(string.format("DEAD",s1),ip,port)
				isDead1=true
			end
		elseif command == "RIGHT" then
			if world[a1[0]][a1[1]+1]== '9' then
				world[a1[0]][a1[1]]= ' '
				a1[1]=a1[1]+1
				world[a1[0]][a1[1]]= 'p'
				s1=s1+1
				udp:sendto(string.format("+%d",s1),ip,port)
			elseif world[a1[0]][a1[1]+1]== 'q' then
				print('un muro',entity)
			elseif world[a1[0]][a1[1]+1]== ' ' then
				world[a1[0]][a1[1]]= ' '
				a1[1]=a1[1]+1
				world[a1[0]][a1[1]]= 'p'
			elseif world[a1[0]][a1[1]+1]== 'h' then
				world[a1[0]][a1[1]]= ' '
				udp:sendto(string.format("DEAD",s1),ip,port)
				isDead1=true
			end
		end 
	elseif entity == 'P2' and isDead2 ~= true then
		if command == "UP" then
			if world[b2[0]-1][b2[1]]== '9' then
				world[b2[0]][b2[1]]= ' '
				b2[0]=b2[0]-1
				world[b2[0]][b2[1]]= 'y'
				s2=s2+1
				udp:sendto(string.format("+%d",s2),ip,port)
			elseif world[b2[0]-1][b2[1]]== 'q' then
				print('un muro',entity)
			elseif world[b2[0]-1][b2[1]]== ' ' then
				world[b2[0]][b2[1]]= ' '
				b2[0]=b2[0]-1
				world[b2[0]][b2[1]]= 'y'
			elseif world[b2[0]-1][b2[1]]== 'h' then
				world[b2[0]][b2[1]]= ' '
				udp:sendto(string.format("DEAD",s2),ip,port)
				isDead2=true
			end
		elseif command == "DOWN" then
			if world[b2[0]+1][b2[1]]== '9' then
				world[b2[0]][b2[1]]= ' '
				b2[0]=b2[0]+1
				world[b2[0]][b2[1]]= 'y'
				s2=s2+1
				udp:sendto(string.format("+%d",s2),ip,port)
			elseif world[b2[0]+1][b2[1]]== 'q' then
				print('un muro',entity)
			elseif world[b2[0]+1][b2[1]]== ' ' then
				world[b2[0]][b2[1]]= ' '
				b2[0]=b2[0]+1
				world[b2[0]][b2[1]]= 'y'
			elseif world[b2[0]+1][b2[1]]== 'h' then
				world[b2[0]][b2[1]]= ' '
				udp:sendto(string.format("DEAD",s2),ip,port)
				isDead2=true
			end
		elseif command == "LEFT" then
			if world[b2[0]][b2[1]-1]== '9' then
				world[b2[0]][b2[1]]= ' '
				b2[1]=b2[1]-1
				world[b2[0]][b2[1]]= 'y'
				s2=s2+1
				udp:sendto(string.format("+%d",s2),ip,port)
			elseif world[b2[0]][b2[1]-1]== 'q' then
				print('un muro',entity)
			elseif world[b2[0]][b2[1]-1]== ' ' then
				world[b2[0]][b2[1]]= ' '
				b2[1]=b2[1]-1
				world[b2[0]][b2[1]]= 'y'
			elseif world[b2[0]][b2[1]-1]== 'h' then
				world[b2[0]][b2[1]]= ' '
				udp:sendto(string.format("DEAD",s2),ip,port)
				isDead2=true
			end
		elseif command == "RIGHT" then
			if world[b2[0]][b2[1]+1]== '9' then
				world[b2[0]][b2[1]]= ' '
				b2[1]=b2[1]+1
				world[b2[0]][b2[1]]= 'y'
				s2=s2+1
				udp:sendto(string.format("+%d",s2),ip,port)
			elseif world[b2[0]][b2[1]+1]== 'q' then
				print('un muro',entity)
			elseif world[b2[0]][b2[1]+1]== ' ' then
				world[b2[0]][b2[1]]= ' '
				b2[1]=b2[1]+1
				world[b2[0]][b2[1]]= 'y'
			elseif world[b2[0]][b2[1]+1]== 'h' then
				world[b2[0]][b2[1]]= ' '
				udp:sendto(string.format("DEAD",s2),ip,port)
				isDead2=true
			end
		end 
	elseif entity == 'P3' and isDead3 ~= true then
		if command == "UP" then
			if world[c3[0]-1][c3[1]]== '9' then
				world[c3[0]][c3[1]]= ' '
				c3[0]=c3[0]-1
				world[c3[0]][c3[1]]= 'l'
				s3=s3+1
				udp:sendto(string.format("+%d",s3),ip,port)
			elseif world[c3[0]-1][c3[1]]== 'q' then
				print('un muro',entity)
			elseif world[c3[0]-1][c3[1]]== ' ' then
				world[c3[0]][c3[1]]= ' '
				c3[0]=c3[0]-1
				world[c3[0]][c3[1]]= 'l'
			elseif world[c3[0]-1][c3[1]]== 'h' then
				world[c3[0]][c3[1]]= ' '
				udp:sendto(string.format("DEAD",s3),ip,port)
				isDead3=true
			end
		elseif command == "DOWN" then
			if world[c3[0]+1][c3[1]]== '9' then
				world[c3[0]][c3[1]]= ' '
				c3[0]=c3[0]+1
				world[c3[0]][c3[1]]= 'l'
				s3=s3+1
				udp:sendto(string.format("+%d",s3),ip,port)
			elseif world[c3[0]+1][c3[1]]== 'q' then
				print('un muro',entity)
			elseif world[c3[0]+1][c3[1]]== ' ' then
				world[c3[0]][c3[1]]= ' '
				c3[0]=c3[0]+1
				world[c3[0]][c3[1]]= 'l'
			elseif world[c3[0]+1][c3[1]]== 'h' then
				world[c3[0]][c3[1]]= ' '
				udp:sendto(string.format("DEAD",s3),ip,port)
				isDead3=true
			end
		elseif command == "LEFT" then
			if world[c3[0]][c3[1]-1]== '9' then
				world[c3[0]][c3[1]]= ' '
				c3[1]=c3[1]-1
				world[c3[0]][c3[1]]= 'l'
				s3=s3+1
				udp:sendto(string.format("+%d",s3),ip,port)
			elseif world[c3[0]][c3[1]-1]== 'q' then
				print('un muro',entity)
			elseif world[c3[0]][c3[1]-1]== ' ' then
				world[c3[0]][c3[1]]= ' '
				c3[1]=c3[1]-1
				world[c3[0]][c3[1]]= 'l'
			elseif world[c3[0]][c3[1]-1]== 'h' then
				world[c3[0]][c3[1]]= ' '
				udp:sendto(string.format("DEAD",s3),ip,port)
				isDead3=true
			end
		elseif command == "RIGHT" then
			if world[c3[0]][c3[1]+1]== '9' then
				world[c3[0]][c3[1]]= ' '
				c3[1]=c3[1]+1
				world[c3[0]][c3[1]]= 'l'
				s3=s3+1
				udp:sendto(string.format("+%d",s3),ip,port)
			elseif world[c3[0]][c3[1]+1]== 'q' then
				print('un muro',entity)
			elseif world[c3[0]][c3[1]+1]== ' ' then
				world[c3[0]][c3[1]]= ' '
				c3[1]=c3[1]+1
				world[c3[0]][c3[1]]= 'l'
			elseif world[c3[0]][c3[1]+1]== 'h' then
				world[c3[0]][c3[1]]= ' '
				udp:sendto(string.format("DEAD",s3),ip,port)
				isDead3=true
			end
		end 
	elseif entity == 'P4' and isDead4 ~= true then
		if command == "UP" then
			if world[d4[0]-1][d4[1]]== '9' then
				world[d4[0]][d4[1]]= ' '
				d4[0]=d4[0]-1
				world[d4[0]][d4[1]]= 'f'
				s4=s4+1
				udp:sendto(string.format("+%d",s4),ip,port)
			elseif world[d4[0]-1][d4[1]]== 'q' then
				print('un muro',entity)
			elseif world[d4[0]-1][d4[1]]== ' ' then
				world[d4[0]][d4[1]]= ' '
				d4[0]=d4[0]-1
				world[d4[0]][d4[1]]= 'f'
			elseif world[d4[0]-1][d4[1]]== 'h' then
				world[d4[0]][d4[1]]= ' '
				udp:sendto(string.format("DEAD",s4),ip,port)
				isDead4=true
			end
		elseif command == "DOWN" then
			if world[d4[0]+1][d4[1]]== '9' then
				world[d4[0]][d4[1]]= ' '
				d4[0]=d4[0]+1
				world[d4[0]][d4[1]]= 'f'
				s4=s4+1
				udp:sendto(string.format("+%d",s4),ip,port)
			elseif world[d4[0]+1][d4[1]]== 'q' then
				print('un muro',entity)
			elseif world[d4[0]+1][d4[1]]== ' ' then
				world[d4[0]][d4[1]]= ' '
				d4[0]=d4[0]+1
				world[d4[0]][d4[1]]= 'f'
			elseif world[d4[0]+1][d4[1]]== 'h' then
				world[d4[0]][d4[1]]= ' '
				udp:sendto(string.format("DEAD",s4),ip,port)
				isDead4=true
			end
		elseif command == "LEFT" then
			if world[d4[0]][d4[1]-1]== '9' then
				world[d4[0]][d4[1]]= ' '
				d4[1]=d4[1]-1
				world[d4[0]][d4[1]]= 'f'
				s4=s4+1
				udp:sendto(string.format("+%d",s4),ip,port)
			elseif world[d4[0]][d4[1]-1]== 'q' then
				print('un muro',entity)
			elseif world[d4[0]][d4[1]-1]== ' ' then
				world[d4[0]][d4[1]]= ' '
				d4[1]=d4[1]-1
				world[d4[0]][d4[1]]= 'f'
			elseif world[d4[0]][d4[1]-1]== 'h' then
				world[d4[0]][d4[1]]= ' '
				udp:sendto(string.format("DEAD",s4),ip,port)
				isDead4=true
			end
		elseif command == "RIGHT" then
			if world[d4[0]][d4[1]+1]== '9' then
				world[d4[0]][d4[1]]= ' '
				d4[1]=d4[1]+1
				world[d4[0]][d4[1]]= 'f'
				s4=s4+1
				udp:sendto(string.format("+%d",s4),ip,port)
			elseif world[d4[0]][d4[1]+1]== 'q' then
				print('un muro',entity)
			elseif world[d4[0]][d4[1]+1]== ' ' then
				world[d4[0]][d4[1]]= ' '
				d4[1]=d4[1]+1
				world[d4[0]][d4[1]]= 'f'
			elseif world[d4[0]][d4[1]+1]== 'h' then
				world[d4[0]][d4[1]]= ' '
				udp:sendto(string.format("DEAD",s4),ip,port)
				isDead4=true
			end
		end 
	end
end

function textItems()
	local textItem="%" .. saveItemA .. '-' .. saveItemB .. '-' .. saveItemC .. '-' .. saveItemD .. '-'
	return textItem
end

function updateTextItems(textItem)
	local index =1
	local newItem= ""
	for i=2, #textItem do
		if textItem:sub(i,i) == '-' then
			if index == 1 then
				saveItemA=newItem
				index =2
			elseif index == 2 then
				saveItemB=newItem
				index =3
			elseif index == 3 then
				saveItemC=newItem
				index =4
			elseif index == 4 then
				saveItemD=newItem
				index =0
			end
			newItem= ""
		else
			newItem=newItem .. textItem:sub(i,i)
		end
	end
end

function textScores()
	local textScore="&" .. tostring(s1) .. '-' .. tostring(s2) .. '-' .. tostring(s3) .. '-' .. tostring(s4) .. '-'
	return textScore
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

--Text functions

function eraseText(text)
	newText= ""
    for i=1, #text -1 do
    	newText=newText .. text:sub(i,i)
    end
    return newText
end

function textIP(serverType)
	local textip="@"
	for k, v in pairs(serverType) do
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
