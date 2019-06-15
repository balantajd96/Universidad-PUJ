extends Area2D

export (String) var UP
export (String) var LEFT
export (String) var RIGHT
export (String) var DOWN

export (int) var device
export (int) var velocity
export (int) var bombCapacity
export (int) var FireCapacity

var movement = Vector2()
var canMakeBomb = true
var screenLimit

signal collision
signal makeBomb

# Called when the node is added to the scene for the first time.
# Initialization here
func _ready():
	$AnimatedSprite.animation = DOWN
	hide()
	screenLimit = get_viewport_rect().size #Get the size of the screen

# Called every frame. Delta is time since last frame.
# Update game logic here.

func _process(delta):
	movement = Vector2() #Reset movements.
	if Input.is_joy_button_pressed(device,15) or Input.get_joy_axis(device,0)>= 0.3: #Rightward movement.
		movement.x +=1
	if Input.is_joy_button_pressed(device,14) or Input.get_joy_axis(device,0)<= -0.3: #Leftward movement.
		movement.x -=1
	if Input.is_joy_button_pressed(device,13) or Input.get_joy_axis(device,1)>= 0.3: #Upward movement.
		movement.y +=1
	if Input.is_joy_button_pressed(device,12) or Input.get_joy_axis(device,1)<= -0.3: #Downward movement.
		movement.y -=1
	if Input.is_joy_button_pressed(device,0): # Making bombs
		if(bombCapacity>0 and canMakeBomb == true):
			emit_signal("makeBomb",position)
			bombCapacity-=1
			canMakeBomb=false
			$Cooldown.start()
		
	if movement.length() > 0: #Check if it is moving.
		movement = movement.normalized() * velocity #If so, it normalizes the speed.
		$AnimatedSprite.play()
		
	position += movement * delta #Update movements (delta is the constant speed of the game).
	position.x = clamp(position.x,0, screenLimit.x) #Limit of the screen in x.
	position.y = clamp(position.y,0, screenLimit.y) #Limit of the screen in y.
	
#Movement animation.
	
	if(movement.x > 0):
		$AnimatedSprite.animation = RIGHT
	elif(movement.x < 0):
		$AnimatedSprite.animation = LEFT
	elif(movement.y > 0):
		$AnimatedSprite.animation = DOWN
	elif(movement.y < 0):
		$AnimatedSprite.animation = UP
	else:
		$AnimatedSprite.stop()
		
#Collisions
	
func _on_Player_body_entered(body):
	if(body.is_in_group("DD")):
		queue_free()
		emit_signal("collision")
	
#Start games function
	
func start(initialPosition):
	position = initialPosition
	show()
	
#cooldown for bobms
func _on_Cooldown_timeout():
	canMakeBomb = true