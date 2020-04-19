extends Sprite

func _process(_delta):
	var pos = 1
	for number in get_children():
		if number is Sprite:
			number.frame = int(str(Globals.score + 100000000).substr(pos, 1))
			pos += 1
