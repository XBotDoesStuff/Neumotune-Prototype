class_name LevelLoadDoor
extends Door

@export var wait_time : float = 1.5
@export var target_scene_path : String

func interact():
	super.interact()
	
	await get_tree().create_timer(wait_time).timeout
	GlobalManager.change_scene(target_scene_path)
