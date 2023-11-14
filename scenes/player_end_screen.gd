extends Sprite2D

func _process(delta):
	self.rotation += randf_range(0.01, 0.1)
