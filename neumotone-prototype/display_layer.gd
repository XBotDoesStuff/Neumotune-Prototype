extends CanvasLayer
@onready var shit_port: SubViewport = $"../Player/ShitPort"
@onready var good_port: SubViewport = $"../Player/GoodPort"
@onready var player: CharacterBody3D = $"../Player"

@onready var low_res_display: TextureRect = $"Low-Res Display"
@onready var high_res_display: TextureRect = $"High-Res Display"

func _ready():
	low_res_display.texture = shit_port.get_texture()
	high_res_display.texture = good_port.get_texture()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("primary_action"):
		snap()

func snap():
	high_res_display.texture = await player.take_snapshot()
