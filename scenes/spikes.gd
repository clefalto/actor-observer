extends Node2D

signal spikes_overlap_body(body)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (not $Area2D.get_overlapping_bodies().is_empty()):
		spikes_overlap_body.emit($Area2D.get_overlapping_bodies()[0])
