extends Node

var score := 0 setget set_score
var high_score := 0
var message := "Mouse: move      Left click: shoot" setget set_message

func _ready():
	OS.window_size = 4*Vector2(256, 144)
	OS.center_window()

func set_message(msg: String):
	message = msg
	yield(get_tree().create_timer(5.0), "timeout")
	while message != "":
		yield(get_tree().create_timer(0.1), "timeout")
		message = message.substr(1)

func set_score(new_score: int):
	if new_score >= high_score:
		if score < high_score and high_score > 0:
			set_message("New record! Previous highest score was " + str(high_score))
		high_score = new_score
	score = new_score
