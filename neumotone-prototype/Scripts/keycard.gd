class_name Keycard
extends Interactable

@export var keycard_level : GlobalManager.ACCESS_LEVEL

func interact():
	if GlobalManager.player_access_level < keycard_level:
		GlobalManager.player_access_level = keycard_level
	queue_free()
