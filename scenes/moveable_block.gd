extends AnimatableBody2D

# https://www.youtube.com/watch?v=4Ff1eEMsa_0

@onready var sprite := $Sprite

@export var reg_sprite : Texture2D
@export var outline_sprite : Texture2D

# define endpoints of rail that this block is on
@export var min_pos_offset : Vector2
@export var max_pos_offset : Vector2
enum AXIS {x, y}
@export var move_axis : AXIS

var holding : bool = false
var mouse_inside : bool = false
var start_position : Vector2

var player_riding : bool = false

var active : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = self.position
	holding = false
	mouse_inside = false
	active = false
	get_parent().start_level.connect(_on_start_level)

func _on_start_level():
	active = true
#	if (get_parent().level_reset):
#		get_parent().level_reset.connect(_on_level_reset)

#func _on_level_reset():
#	holding = false
#	mouse_inside = false
#	self.position = start_position
#	self.linear_velocity = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (!active): return
	if (holding):
		followMouse()
		sprite.texture = outline_sprite
#		var collision_info
#		test_move(self.transform, self.position + Vector2.UP, collision_info)
#		if (collision_info.get_collider().is_in_group("Player")):
#			collision_info.get_collider().position
	elif (mouse_inside):
		sprite.texture = outline_sprite
	elif (!mouse_inside):
		sprite.texture = reg_sprite
	
	

#func _integrate_forces(state):
#	var lv = state.get_linear_velocity()
#
#	if holding:
#		lv = (get_global_mouse_position() - self.position) * 16
#		if (move_axis == AXIS.x):
#			lv.y = 0
#		else:
#			lv.x = 0
#
#	state.set_linear_velocity(lv)
#	# restrict position to be on the rail defined by min_pos and max_pos
#	self.position = Vector2(clamp(self.position.x, start_position.x + min_pos_offset.x, start_position.x + max_pos_offset.x), 
#					   clamp(self.position.y, start_position.y - min_pos_offset.y, start_position.y - max_pos_offset.y))

func followMouse() -> void:
	var new_position = get_global_mouse_position()
	self.position = Vector2(clamp(new_position.x, start_position.x + min_pos_offset.x, start_position.x + max_pos_offset.x), 
							clamp(new_position.y, start_position.y - min_pos_offset.y, start_position.y - max_pos_offset.y))

func _mouse_enter() -> void:
	mouse_inside = true

func _mouse_exit() -> void:
	mouse_inside = false


func _input_event(viewport : Viewport, event : InputEvent, shape_idx : int) -> void:
	if (event is InputEventMouseButton) && (event.button_index == MOUSE_BUTTON_LEFT):
		if event.pressed:
			holding = true
		else:
			holding = false


func _input(event):
	if (event is InputEventMouseButton) && (event.button_index == MOUSE_BUTTON_LEFT):
		if (event.is_released) && holding:
			holding = false


