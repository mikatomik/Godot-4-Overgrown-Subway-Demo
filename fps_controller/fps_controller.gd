extends CharacterBody3D

@onready var camera = $Camera3D
@onready var flashlight = $flashlight
@onready var flashlight_anchor = $flashlight_anchor

const walk_speed : int = 3
const sprint_speed : int = 5
const accel : float = 0.2
const gravity : float = -0.8
const terminal_velocity : int = -35
const jump_strength : int = 10

var is_player_in_control : bool = false
var is_flashlight_on : bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(_delta) -> void:
	
	update_flashlight_transform()
	
	if Input.is_action_just_pressed("toggle_flashlight") and is_player_in_control:
		if is_flashlight_on:
			$flashlight.light_energy = 0
			is_flashlight_on = false
		else:
			$flashlight.light_energy = 3
			is_flashlight_on = true
	
func _physics_process(delta) -> void:
	if is_player_in_control:
		set_movement_vec()
		handle_controller_look_input(delta)
		move_and_slide()
	
func set_movement_vec() -> void:
	var input_dir : Vector3 = Vector3.ZERO
	var h_axis : float = Input.get_axis("walk_left", "walk_right")
	var v_axis : float = Input.get_axis("walk_forward", "walk_backward")
	
	input_dir += self.global_transform.basis.x * h_axis
	input_dir += self.global_transform.basis.z * v_axis
	
	if input_dir.length() > 1:
		#Only normalize if length > 1. This way, analog joysticks
		#can scale the velocity with how far they are pushed
		input_dir = input_dir.normalized()
	
	if Input.is_action_pressed("sprint"): #Check for sprinting to decide which movement speed to use
		velocity.x = lerp(velocity.x, input_dir.x * sprint_speed, accel)
		velocity.z = lerp(velocity.z, input_dir.z * sprint_speed, accel)
	else:
		velocity.x = lerp(velocity.x, input_dir.x * walk_speed, accel)
		velocity.z = lerp(velocity.z, input_dir.z * walk_speed, accel)
		
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y < terminal_velocity:
			velocity.y = terminal_velocity
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_strength

func handle_controller_look_input(delta) -> void:
	#This is for controller look input
	var h_axis : float = Input.get_axis("look_right", "look_left")
	var v_axis : float = Input.get_axis("look_down", "look_up")
	
	self.rotate_y(h_axis * delta * ControlSettings.controller_look_sens)
	
	if ControlSettings.controller_invert_y: #Check control setting singleton to see if user wants up/down axis inverted
		camera.rotate_x(-v_axis * delta * ControlSettings.controller_look_sens)
		
	else:
		camera.rotate_x(v_axis * delta * ControlSettings.controller_look_sens)
		
		
	camera.rotation.x = clamp(camera.rotation.x, -1.2, 1.2) #Clamp the up/down rotation so we can't flip upside down

func update_flashlight_transform() -> void:
	flashlight.global_position = flashlight_anchor.global_position
	flashlight.global_rotation.y = lerp_angle(flashlight.global_rotation.y, flashlight_anchor.global_rotation.y, 0.2)
	flashlight.global_rotation.x = lerp_angle(flashlight.global_rotation.x, camera.global_rotation.x, 0.2)

func _input(event) -> void:
	#This is for mouse look
	if event is InputEventMouseMotion and is_player_in_control:
		self.rotate_y(-event.relative.x * ControlSettings.mouse_sens)
		camera.rotate_x(-event.relative.y * ControlSettings.mouse_sens)
		camera.rotation.x = clamp(camera.rotation.x, -1.2, 1.2)
