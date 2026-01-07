class_name Keycard
extends Interactable

enum ACCESS_LEVEL {
	maintenance,
	adminsistrator
}
@export var keycard_level : ACCESS_LEVEL
signal give_keycard(keycard_level)

func interact():
	give_keycard.emit(keycard_level)
	queue_free()
