extends Area2D

var velocity := Vector2.ZERO
var invincible := false

func _physics_process(delta: float):
	position += velocity * delta

func destroy():
	if not invincible:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
