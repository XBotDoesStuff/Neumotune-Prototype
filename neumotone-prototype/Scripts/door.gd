class_name Door
extends Interactable

@export var security_level : GlobalManager.ACCESS_LEVEL
var is_open : bool = false
@export var locked : bool = true
@onready var hinge = self.get_parent()

func interact():
	if locked:
		if GlobalManager.player_access_level >= security_level:
			locked = false
	else:
		if is_open:
			close()
		else:
			open()

func open():
	is_open = true
	hinge.rotate_y(deg_to_rad(90))

func close():
	is_open = false
	hinge.rotate_y(deg_to_rad(-90))
