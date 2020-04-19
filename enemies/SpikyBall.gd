extends Area2D

var velocity = Vector2.ZERO

func _physics_process(delta):
	position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func hurt():
	$Explosion.play()
	$Explosion2.emitting = true
	$Sprite.hide()
	$Light2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$Zooming.stop()
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()

func _on_area_entered(_area):
	hurt()
