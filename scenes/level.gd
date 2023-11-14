extends Node2D

# general level script
# manages starting and ending the level

@onready var player := $Player
@onready var player_spawn := $PlayerSpawn
@onready var goal := $Goal
@export var next_level : PackedScene
var current_level : PackedScene

var playing : bool = false

signal level_change
signal level_reset
signal start_level

# Called when the node enters the scene tree for the first time.
func _ready():
	goal.player_overlapping_goal.connect(_on_player_overlapping_goal)
	player.player_die.connect(_on_player_die)
	playing = false
	player.reset(player_spawn.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_overlapping_goal():
	player.change_state("paused")
	if (self.next_level):
		go_to_next_level()

func go_to_next_level() -> void:
	var next_level = self.next_level
	get_tree().change_scene_to_packed(next_level)

func _on_player_die():
	reset_level()

func _on_play_button_pressed():
	play()

func _unhandled_key_input(event):
	if (event.is_action_pressed("play")):
		play()

func play() -> void:
	if (!playing):
		start_level.emit()
		playing = true
		player.activate()
	else:
		playing = false
		reset_level()


func reset_level() -> void:
	# place player at correct player spawn position for this level
	player.reset(player_spawn.position)
	# reset other objects that we don't know about
	level_reset.emit()
	playing = false
	# honestly can just reload the scene
	get_tree().reload_current_scene()
