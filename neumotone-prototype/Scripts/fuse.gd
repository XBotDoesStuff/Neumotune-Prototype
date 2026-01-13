class_name Fuse
extends Interactable

@export var max_repair = 1
@onready var player = GlobalManager.player
@onready var display = GlobalManager.display

func interact():
	player.set_shitport_degradation(max_repair)
	display.set_display_broken(false)
	player.break_value = 0
	queue_free()
