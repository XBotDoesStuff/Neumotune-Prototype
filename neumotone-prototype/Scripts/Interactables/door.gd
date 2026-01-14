class_name Door
extends Interactable

@export var destroy_door : bool = false
@export var security_level : GlobalManager.ACCESS_LEVEL
var is_open : bool = false
@export var locked : bool = false
@onready var hinge = self.get_parent()

func interact():
	if locked:
		if GlobalManager.player_access_level >= security_level:
			locked = false
	else:
		if destroy_door:
			queue_free()
		elif is_open:
			close()
		else:
			open()

func open():
	is_open = true
	if hinge:
		hinge.rotate_y(deg_to_rad(90))

func close():
	is_open = false
	if hinge:
		hinge.rotate_y(deg_to_rad(-90))
