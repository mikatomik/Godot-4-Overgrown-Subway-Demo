extends Node3D

@export var player : CharacterBody3D
@export var anim_player : AnimationPlayer
@export var environment : WorldEnvironment

func _ready() -> void:
	anim_player.play("fade_in")

func enable_character_movement() -> void: #This is called at the end of the animation "fade_in"
	player.is_player_in_control = true
	anim_player.queue_free()
