class_name PlayerDisplay
extends CanvasLayer

@onready var player: CharacterBody3D = GlobalManager.player
@onready var shit_port: SubViewport = player.shit_port
@onready var good_port: SubViewport = player.good_port

var static_texture = load("res://protov1/textures/static.jpg")

@onready var low_res_display: TextureRect = $"Low-Res Display"
@onready var high_res_display: TextureRect = $"High-Res Display"

var display_broken : bool = false

func _ready():
	GlobalManager.display = self
	low_res_display.texture = shit_port.get_texture()
	high_res_display.texture = good_port.get_texture()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("primary_action"):
		snap()
	
	$DebugContainer/DisplaySize.text = str(GlobalManager.player.shit_port.size)
	$DebugContainer/SnapLimit.text = str(GlobalManager.player.break_value)

func snap():
	if not display_broken:
		high_res_display.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		high_res_display.texture = await player.take_snapshot()
	else:
		high_res_display.stretch_mode = TextureRect.STRETCH_TILE
		high_res_display.texture = static_texture

func set_display_broken(broken : bool):
	display_broken = broken
