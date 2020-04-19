extends Node2D

func _input(event):
	if event.is_action_pressed("shoot") or event.is_action_pressed("ui_accept"):
		_on_Skip_pressed()

func _on_Skip_pressed():
	get_tree().change_scene("res://world/World.tscn")
