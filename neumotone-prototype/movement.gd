extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 20
var jump_speed = 15
var mouse_sensitivity = 0.002

var snapshot_texture : Texture

@onready var player_cam: Camera3D = $Camera3D
@onready var shitport_cam: Camera3D = $"../ShitPort/Camera3D"
@onready var shit_port: SubViewport = $"../ShitPort"
@onready var good_port: SubViewport = $"../GoodPort"
@onready var goodport_cam: Camera3D = $"../GoodPort/Camera3D"


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player_cam.current = false


func _process(_delta):
	shitport_cam.global_transform = player_cam.global_transform
	goodport_cam.global_transform = player_cam.global_transform
	
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("primary_action"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
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
	good_port.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	snapshot_texture = good_port.get_texture()
	return snapshot_texture
