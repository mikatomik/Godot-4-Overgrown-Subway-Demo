extends Control

@onready var env = get_parent().environment.get_environment()
@export var fps_readout : Label

signal scene_initialized

func _process(_delta):
	if fps_readout.visible: #Only ask to print out FPS if we can see it, otherwise its a waste
		fps_readout.text = "FPS: " + str(Engine.get_frames_per_second())
		
	if Input.is_action_just_pressed("pause"):
		if self.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			self.visible = false
			get_tree().paused = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			self.visible = true
			$MarginContainer/VBoxContainer/resume.grab_focus()
			get_tree().paused = true

func _on_ssil_button_toggled(_button_pressed):
	env.set("ssil_enabled", !env.get("ssil_enabled"))


func _on_ssao_button_toggled(_button_pressed):
	env.set("ssao_enabled", !env.get("ssao_enabled"))


func _on_glow_toggled(_button_pressed):
	env.set("glow_enabled", !env.get("glow_enabled"))


func _on_resume_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	get_tree().paused = false


func _on_quit_pressed():
	get_tree().quit()


func _on_fps_toggle_toggled(_button_pressed):
	fps_readout.visible = !fps_readout.visible


func _on_gamepad_invert_toggled(_button_pressed):
	ControlSettings.controller_invert_y = !ControlSettings.controller_invert_y


func _on_mouse_sens_value_changed(value):
	#This is divided by 1000 to bring the value into a usable sensitivity range while keeping
	#a nice looking 0-10 slider for the user in the UI
	ControlSettings.mouse_sens = value / 1000.0
	$MarginContainer/VBoxContainer/HBoxContainer/mouse_sens_readout.text = str(value).pad_decimals(1)


func _on_control_sens_value_changed(value):
	ControlSettings.controller_look_sens = value
	$MarginContainer/VBoxContainer/HBoxContainer2/control_sens_readout.text = str(value).pad_decimals(1)


func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 10.0))
	#Value is divided by 10 because slider reads 0-10 for user's eyes but linear_to_db needs 0-1
	
	$MarginContainer/VBoxContainer/HBoxContainer3/volume_readout.text = str(value).pad_decimals(1)
