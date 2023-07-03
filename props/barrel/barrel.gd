extends Node3D

@onready var dynam_light = $dynam_light


#This is just to add a little flicker to the light coming from the barrel.

func _ready() -> void:
	randomize()
	$Timer.start()

func _on_timer_timeout():
	dynam_light.light_energy = randf_range(0.8, 1.0)
	dynam_light.omni_range = 8.0 + randf_range(-0.15, 0.15)
	dynam_light.position.x = randf_range(-0.01, 0.01)
	dynam_light.position.z = randf_range(-0.01, 0.01)
	dynam_light.position.y = 2.063 + randf_range(-0.01, 0.01)
