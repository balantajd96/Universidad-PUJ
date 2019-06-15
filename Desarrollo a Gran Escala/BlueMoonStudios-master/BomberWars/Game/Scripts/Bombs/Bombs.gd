extends RigidBody2D

export (PackedScene) var Fire

var velocity = 150
var movement = Vector2()
var screenLimit
var bomb = 0

# Called when the node is added to the scene for the first time.
# Initialization here
func _ready():
	#hide()
	screenLimit = get_viewport_rect().size #Get the size of the screen

# Called every frame. Delta is time since last frame.
# Update game logic here.

func _process(delta):
	pass

func _on_Timer_timeout():
	if(bomb == 0):
		$AnimatedSprite.animation = "StandarBomb1"
		bomb +=1
	elif(bomb == 1):
		$AnimatedSprite.animation = "StandarBomb2"
		bomb +=1
	elif(bomb == 2):
		$AnimatedSprite.animation = "StandarBomb3"
		bomb +=1
	elif(bomb == 3):
		$AnimatedSprite.animation = "StandarBomb4"
		bomb +=1
	elif(bomb == 4): #When the bomb is going to explode 
		#Remove the bomb
		remove_child($AnimatedSprite)
		remove_child($CollisionShape2D)
		remove_child($Timer)
		#Create the fire
		var F = Fire.instance()
		add_child(F)
		F.position.x = -75
		F.position.y = -75