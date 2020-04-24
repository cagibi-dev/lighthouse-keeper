extends Node2D

func _input(event: InputEvent):
	if event.is_action_pressed("shoot") or event.is_action_pressed("ui_accept"):
		_on_Skip_pressed()

func _on_Skip_pressed():
	$Music/FadeTween.interpolate_property($Music, "volume_db", -3, -60, 1.0, Tween.TRANS_EXPO)
	$Music/FadeTween.start()
	$Background/Waves.stop()
	$Go.play("go")
	yield(get_tree().create_timer(1.0), "timeout")
	var ok := get_tree().change_scene("res://world/World.tscn")
	assert(OK == ok)
