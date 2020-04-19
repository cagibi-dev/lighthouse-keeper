extends "res://enemies/SmallPirate.gd"

var player: Node2D

func _physics_process(_delta):
	var rot := global_position.angle_to_point(player.global_position)
	velocity = lerp(velocity, Vector2(-velocity.length(), 0).rotated(rot), 0.05)

func _on_GameOver():
	set_physics_process(false)
