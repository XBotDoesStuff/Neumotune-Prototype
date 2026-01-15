class_name PlayerHud
extends Control

@onready var crosshair: TextureRect = $Crosshair

const NON_INTERACT_CROSSHAIR = preload("uid://ydhjwtify55i")
const INTERACT_CROSSHAIR = preload("uid://edbd6v152kbm")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crosshair.texture = NON_INTERACT_CROSSHAIR

func set_interactable_hover(is_hovering: bool):
	if is_hovering:
		crosshair.texture = INTERACT_CROSSHAIR
	else:
		crosshair.texture = NON_INTERACT_CROSSHAIR
