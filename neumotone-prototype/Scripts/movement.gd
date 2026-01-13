class_name Player
extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 5
@export var sprint_speed = 10
var jump_speed = 15
var mouse_sensitivity = 0.002

@export var max_stamina = 100
var stamina = max_stamina

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

var inventroy = []

@onready var interaction_cast: RayCast3D = $Camera3D/InteractionCast
@onready var player_cam: Camera3D = $Camera3D
@onready var shitport_cam: Camera3D = $"ShitPort/Camera3D"
@onready var shit_port: SubViewport = $ShitPort
@onready var good_port: SubViewport = $GoodPort
@onready var goodport_cam: Camera3D = $"GoodPort/Camera3D"


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player_cam.current = false
	GlobalManager.player = self
	shit_port.size = Vector2i(shitport_max_width, shitport_max_height)

func _process(_delta):
	if shitport_cam:
		shitport_cam.global_transform = player_cam.global_transform
	if goodport_cam:
		goodport_cam.global_transform = player_cam.global_transform
	
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("primary_action"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if interaction_cast.is_colliding():
		var collision_object = interaction_cast.get_collider()
		if collision_object is Interactable and Input.is_action_just_pressed("interact"):
			collision_object.interact()


func _physics_process(delta):
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
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func take_snapshot():
	var evil_sphere_visible: bool = false
	good_port.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	snapshot_texture = good_port.get_texture()
	
	for sphere in get_tree().get_nodes_in_group("evil_spheres"):
		if sphere.currently_visible:
			evil_sphere_visible = true
			break
	
	if evil_sphere_visible:
		set_shitport_degradation(shitport_degradation * evil_deg_decrease)
	else:
		set_shitport_degradation(shitport_degradation * deg_decrease)
	
	if shitport_degradation == max_degradation:
		break_value += 1
	
	if break_value >= max_snaps_after_limit:
		GlobalManager.display.set_display_broken(true)
	
	return snapshot_texture

func set_shitport_degradation(degradation : float):
	shitport_degradation = clamp(degradation, max_degradation, 1)
	shit_port.size = Vector2i(floor(shitport_max_width * shitport_degradation), floor(shitport_max_height * shitport_degradation))
