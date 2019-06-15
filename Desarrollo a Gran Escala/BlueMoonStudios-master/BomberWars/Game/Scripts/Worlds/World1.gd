extends Node

export (PackedScene) var Bomb
var Score

func _ready():
	pass
	
func NewGame():
	Score=0
	$Player1.start($InitialPosition.position) #Initial position for player1
	$Player2.start($InitialPosition2.position) #Initial position for player 2
	$Player3.start($InitialPosition3.position) #Initial position for player3
	$Player4.start($InitialPosition4.position) #Initial position for player 4
	$TimerWorld.start()
	$Interface.show_message("Ready?")
	$Interface.update_score(Score)
	
func _on_Player_collision():
	$TimerScore.stop()
	
func _on_TimerWorld_timeout():
	$TimerScore.start()
	
func _on_TimerScore_timeout():
	Score += 1
	$Interface.update_score(Score)


func _on_Player_makeBomb(location):
	var B = Bomb.instance()
	add_child(B)
	B.position = location
