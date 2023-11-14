extends Node2D

@onready var hitbox := $Area2D

# when player overlaps the hitbox, emit signal to level script
signal player_overlapping_goal

var active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	active = false
	get_parent().start_level.connect(_on_start_level)

func _on_start_level():
	active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!active): return
	# check all overlapping bodies every frame LOLLLL
	var overlaps = hitbox.get_overlapping_bodies()
	for i in range(overlaps.size()):
		if (overlaps[i] is CharacterBody2D):
			player_overlapping_goal.emit()
