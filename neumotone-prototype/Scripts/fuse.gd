class_name Fuse
extends Interactable

@export var max_repair = 1
@onready var player = GlobalManager.player

func interact():
	player.set_shitport_degradation(max_repair)
	queue_free()
