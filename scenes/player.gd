extends CharacterBody2D

@onready var sprite := $AnimatedSprite2D
@onready var crush_area := $CrushArea

@export var move_speed : float = 40.0 # px/s
var move_direction : int = 0 # -1 if moving left, 0 if still, 1 if moving right
var facing : int = 1

@export var fall_speed = 90.0 # px/s

var both_sides_grounded = true

# move to the left or right automatically when play button is pressed

enum {S_paused, S_walk, S_dead, S_tractor_beam}
var state = S_paused
var prev_state = S_paused

signal player_die

var active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	active = false
	get_parent().start_level.connect(_on_start_level)

func _on_start_level():
	active = true

func reset(pos : Vector2) -> void:
	self.position = pos
	self.facing = 1
	self.move_direction = 1
	self.state = S_paused
	self.both_sides_grounded = true

func activate() -> void:
	self.state = S_walk
	self.both_sides_grounded = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (!active): return
	update_sprite()
	check_collisions()
	
	if (self.state == S_paused):
		self.velocity = Vector2.ZERO
	
	elif (self.state == S_walk):
		do_gravity()
		both_sides_grounded = check_raycasts()
		if (self.is_on_wall()):
			# if touching wall, set move_direction to the normal of the wall (opposite direction of it)
			move_direction = get_wall_normal().x
			# flip sprite
			facing = move_direction
#		elif (!both_sides_grounded):
#			move_direction = -move_direction
#			facing = move_direction
		velocity.x = move_speed * move_direction
		
		# check if player is currently inside another collision object, if it is call crush
		
	
	
	elif (self.state == S_tractor_beam):
		self.velocity.y = 0
	
	move_and_slide()

func do_gravity() -> void:
	if !is_on_floor():
		velocity.y = fall_speed
	else:
		velocity.y = 0

func check_collisions() -> void:
	var overlapping_areas = crush_area.get_overlapping_areas()
	for i in range(overlapping_areas.size()):
		if (overlapping_areas[i].is_in_group("Spikes")):
			die()

func update_sprite() -> void:
	sprite.flip_h = facing < 0

func die() -> void:
	self.state = S_dead
	player_die.emit()

# used by tractor beam
func move(amount : Vector2):
	self.velocity = amount

# called by level script when play button is pressed and such
func change_state(state : String) -> void:
	if (state == "walk"):
		self.prev_state = self.state
		self.state = S_walk
	elif (state == "paused"):
		self.prev_state = self.state
		self.state = S_paused
	elif (state == "tractor_beam"):
		self.prev_state = self.state
		self.state = S_tractor_beam

func previous_state():
	self.state = self.prev_state;

func check_raycasts() -> bool:
	# position is in the center of the node so we need to subtract and add by ikoluahsdflkjsbndf
	return $RayCastRight.is_colliding() and $RayCastLeft.is_colliding()

#func _draw():
#	var global_min_bounds = ($CollisionShape2D.shape.get_rect().position)
#	#draw_circle(global_min_bounds, 1, Color.GREEN)
#	var global_max_bounds = ($CollisionShape2D.shape.get_rect().end)
#	#draw_circle(global_max_bounds, 1, Color.GREEN)
#
#	draw_line(Vector2(global_min_bounds.x, global_max_bounds.y), Vector2(global_min_bounds.x, global_max_bounds.y+2), Color.GREEN)
#	draw_line(Vector2(global_max_bounds.x, global_max_bounds.y), Vector2(global_max_bounds.x, global_max_bounds.y+2), Color.GREEN)
