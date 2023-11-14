extends Node2D

@onready var texture_rect := $TextureRect
@onready var area := $Area2D
@onready var coll_shape := $Area2D/CollisionShape2D
@onready var raycast := $RayCast2D
@onready var player := $"../Player"

var was_overlapping_player : bool = false
var active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	coll_shape.shape.size = Vector2(0,0)
	texture_rect.size = Vector2(0,0)
	active = false
	get_parent().start_level.connect(_on_start_level)

func _on_start_level():
	active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (!active): return
	var collision = raycast.get_collider()
	
	# IN GLOBAL COORDS
	# point of collision of the raycast, collides with solid surfaces (anything that isn't a player)
	var point = raycast.get_collision_point()
	var extent = to_local(point)
	# set the size of the area2d to 9 wide and to the length of the extent
	coll_shape.shape.size = Vector2(9, abs(extent.y) + 8)
	
	texture_rect.size = Vector2(texture_rect.size.x, abs(extent.y) + 8)
	
	if (area.overlaps_body(player)):
		if (!was_overlapping_player):
			player.change_state("tractor_beam")
			was_overlapping_player = true
		player.move((point - self.position).normalized() * 30.0)
	else:
		if (was_overlapping_player):
			player.previous_state()
			was_overlapping_player = false
