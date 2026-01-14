class_name EvilSphere
extends VisibleOnScreenNotifier3D

var currently_visible : bool

func _ready() -> void:
	connect("screen_entered", _on_screen_entered)
	connect("screen_exited", _on_screen_exited)
	add_to_group("evil_spheres")

func _on_screen_entered() -> void:
	currently_visible = true

func _on_screen_exited() -> void:
	currently_visible = false
