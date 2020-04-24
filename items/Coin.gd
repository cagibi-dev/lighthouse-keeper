extends Area2D

var plus_score := preload("res://items/PlusScore.tscn")

func _on_Coin_body_entered(body: PhysicsBody2D):
	effect(body)
	destroy()

func effect(_body):
	Globals.message = "You got some of the pirate's treasure!"

func destroy():
	Globals.score += 5000
	var new_plus_score = plus_score.instance()
	get_parent().add_child(new_plus_score)
	new_plus_score.global_position = global_position
	new_plus_score.init(5000)
	hide()
	collision_mask = 0
	$Caught.play()
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
