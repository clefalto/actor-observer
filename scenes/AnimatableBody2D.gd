extends AnimatableBody2D

var mouse_inside : bool = false
var holding : bool = false

#func _physics_process(delta):
#	self.position = get_parent().position

func _on_level_reset():
	holding = false
	mouse_inside = false

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
