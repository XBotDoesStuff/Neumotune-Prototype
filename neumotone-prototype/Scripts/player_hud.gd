
extends Control

@onready var crosshair: TextureRect = $Crosshair

const NON_INTERACT_CROSSHAIR = preload("uid://ydhjwtify55i")
const INTERACT_CROSSHAIR = preload("uid://edbd6v152kbm")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crosshair.texture = NON_INTERACT_CROSSHAIR

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
