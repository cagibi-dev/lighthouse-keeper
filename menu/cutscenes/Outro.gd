extends Node2D

func _input(event: InputEvent):
	if event.is_action_pressed("shoot") or event.is_action_pressed("ui_accept"):
		_on_Skip_pressed()

func _on_Skip_pressed():
	$Go.play("go")
	$Music.stop()
	yield(get_tree().create_timer(1.0), "timeout")
	var ok := get_tree().change_scene("res://menu/TitleScreen.tscn")
	assert(OK == ok)
