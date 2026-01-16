class_name Player
extends CharacterBody3D

# Player movement variables
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 5
@export var sprint_speed = 10
var jump_speed = 15
var mouse_sensitivity = 0.002

@export var max_stamina = 100
var stamina = max_stamina
@export var max_health : float = 100.0
var health : float

# Degradation and viewport variables
@export_category("Viewport Settings")
var snapshot_texture : Texture
@export var shitport_max_width : int = 256
@export var shitport_max_height : int = 144
var shitport_degradation : float = 1
@export var max_degradation : float = 0.1
@export var deg_decrease = 0.9
@export var evil_deg_decrease = 0.5

@export var max_snaps_after_limit : int = 3
var break_value : int = 0

# Get the different stuff the player has for ease of access
@onready var interaction_cast: RayCast3D = $Camera3D/InteractionCast
@onready var player_cam: Camera3D = $Camera3D
@onready var shitport_cam: Camera3D = $"ShitPort/Camera3D"
@onready var shit_port: SubViewport = $ShitPort
@onready var good_port: SubViewport = $GoodPort
@onready var goodport_cam: Camera3D = $"GoodPort/Camera3D"
var hud: PlayerHud


func _ready():
	# Capture the mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Disables the camera3d node so the scene is rendered twice
	player_cam.current = false
	
	# Declares the player in the global manager
	GlobalManager.player = self
	
	# Sets the size of the shitport to be the max width and height set in the editor
	shit_port.size = Vector2i(shitport_max_width, shitport_max_height)

func _process(_delta):
	# Sets the shitport and goodport cameras to match the player camera's transform
	if shitport_cam:
		shitport_cam.global_transform = player_cam.global_transform
	if goodport_cam:
		goodport_cam.global_transform = player_cam.global_transform
	
	# Controls to let the mouse escape and recapture it
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("primary_action"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Check if the interactioncast raycast is colliding with an Interactable
	if interaction_cast.is_colliding():
		var collision_object = interaction_cast.get_collider()
		if collision_object is Interactable:
			if hud:
				hud.set_interactable_hover(true)
			if Input.is_action_just_pressed("interact"):
				collision_object.interact()
		elif collision_object is not Interactable:
			hud.set_interactable_hover(false)
	elif hud:
		hud.set_interactable_hover(false)


func _physics_process(delta):
	# Handle actual player movement
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	
	if Input.is_action_pressed("sprint"):
		velocity.x = movement_dir.x * sprint_speed
		velocity.z = movement_dir.z * sprint_speed
	else:
		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed

	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed

func _input(event):
	# Handle player camera rotation
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

# Updates the goodport texture
func take_snapshot():
	var evil_sphere_visible: bool = false
	good_port.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	snapshot_texture = good_port.get_texture()
	
	# Detects EVIL SPHERES and doubles degradation if detected
	for sphere in get_tree().get_nodes_in_group("evil_spheres"):
		if sphere.currently_visible:
			evil_sphere_visible = true
			break
	
	if evil_sphere_visible:
		set_shitport_degradation(shitport_degradation * evil_deg_decrease)
	else:
		set_shitport_degradation(shitport_degradation * deg_decrease)
	
	# Break the goodport cam if shitport degradation is maxed out
	if shitport_degradation == max_degradation:
		break_value += 1
	
	if break_value >= max_snaps_after_limit:
		GlobalManager.display.set_display_broken(true)
	
	return snapshot_texture

# Sets the shitport degradation
func set_shitport_degradation(degradation : float):
	shitport_degradation = clamp(degradation, max_degradation, 1)
	shit_port.size = Vector2i(floor(shitport_max_width * shitport_degradation), floor(shitport_max_height * shitport_degradation))
