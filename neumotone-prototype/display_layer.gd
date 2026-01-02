extends CanvasLayer
@onready var shit_port: SubViewport = $"../Player/ShitPort"
@onready var good_port: SubViewport = $"../Player/GoodPort"
@onready var player: CharacterBody3D = $"../Player/CharacterBody3D"

@onready var low_res_display: TextureRect = $"Low-Res Display"

func _ready():
	low_res_display.texture = shit_port.get_texture()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("primary_action"):
		snap()

func snap():
	low_res_display.texture = await player.take_snapshot()
	await get_tree().create_timer(0.5).timeout
	low_res_display.texture = shit_port.get_texture()
