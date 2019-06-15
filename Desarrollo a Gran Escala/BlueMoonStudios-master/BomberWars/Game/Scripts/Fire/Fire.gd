extends StaticBody2D
export (String) var NAME
func _ready():
	$AnimatedSprite.animation = NAME
	$AnimatedSprite.play()
	

func _on_AnimatedSprite_animation_finished():
	queue_free()
