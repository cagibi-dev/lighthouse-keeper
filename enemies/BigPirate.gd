extends "res://enemies/SmallPirate.gd"

signal shoot(position, bullet)
var hp := 3
var bullet := preload("res://enemies/SpikyBall.tscn")

func hurt():
	hp -= 1
	if hp > 0:
		$Hurt.play()
		$Sprite/AnimationPlayer.play("hurt")
	else:
		$ShootTimer.stop()
		.hurt()

func _on_ShootTimer_timeout():
	$Shoot.play()
	emit_signal("shoot", global_position, bullet)


func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "hurt":
		$Sprite/AnimationPlayer.play("default")
