class_name Keycard
extends Interactable

enum ACCESS_LEVEL {
	maintenance,
	adminsistrator
}
@export var keycard_level : ACCESS_LEVEL

func interact():
	queue_free()
