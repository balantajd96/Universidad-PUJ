extends CanvasLayer

signal start_gameS
signal start_gameF

func show_message(text):
	$Message.text = text
	$Message.show()
	$TimerMessage.start()
	
func game_over():
	show_message('Game Over')
	yield($TimeMessage, "timeout")
	$Button_Solitario.show()
	$Button_Fiesta.show()
	$Message.text = "Bomber Wars"
	$Message.show()

func update_score(Points):
	$Score.text = str(Points)

func _on_TimerMessage_timeout():
	$Message.hide()


func _on_Button_Solitario_pressed():
	$Button_Solitario.hide()
	$Button_Fiesta.hide()
	emit_signal("start_gameS")


func _on_Button_Fiesta_pressed():
	$Button_Solitario.hide()
	$Button_Fiesta.hide()
	$Score.show()
	$Panel.show()
	emit_signal("start_gameF")
