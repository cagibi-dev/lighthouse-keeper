extends Sprite

func init(number: int):
	vframes = 1
	match number:
		100:
			vframes = 4
			frame = randi()%4
		500:
			texture = preload("res://items/plus500.png")
		2000:
			texture = preload("res://items/plus2000.png")
		5000:
			texture = preload("res://items/plus5000.png")

func _on_Timer_timeout():
	queue_free()
