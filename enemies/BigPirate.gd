extends "res://enemies/SmallPirate.gd"

signal shoot(position, bullet)
var hp = 3
var bullet = preload("res://enemies/SpikyBall.tscn")

func hurt():
	hp -= 1
	if hp > 0:
		$Hurt.play()
		$Sprite/AnimationPlayer.play("hurt")
	else:
		$Dead.play()
		$Sprite.hide()
		$Light2D.hide()
		$ShootTimer.stop()
		$Explosion.emitting = true
		collision_layer = 0
		$HitBox.collision_layer = 0
		$HitBox.collision_mask = 0
		call_deferred("drop_item")
		set_physics_process(false)
		emit_signal("add_score", score, global_position)
		yield(get_tree().create_timer(1.5), "timeout")
		queue_free()


func _on_ShootTimer_timeout():
	$Shoot.play()
	emit_signal("shoot", global_position, bullet)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hurt":
		$Sprite/AnimationPlayer.play("default")
