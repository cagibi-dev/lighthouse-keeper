extends Area2D

var velocity := Vector2.ZERO
var invincible := false

func _physics_process(delta: float):
	position += velocity * delta

func destroy():
	if not invincible:
		_plan_destruction()

func _on_VisibilityNotifier2D_screen_exited():
	_plan_destruction()

func _plan_destruction():
	$Sprite.self_modulate.a = 0
	$Sprite/Trail.set_deferred("emitting", false)
	$Light2D.hide()
	velocity *= 0
	$CollisionShape2D.set_deferred("disabled", true)
	$DeadTimer.call_deferred("start")

func _on_DeadTimer_timeout():
	queue_free()
