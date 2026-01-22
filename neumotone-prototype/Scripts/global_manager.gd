extends Node

enum ACCESS_LEVEL {
	maintenance,
	adminsistrator
}

var player : Player
var player_data : PlayerData
var player_access_level : ACCESS_LEVEL = ACCESS_LEVEL.maintenance

var display : PlayerDisplay

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func save_player_data():
	if not player_data:
		player_data = PlayerData.new()
	
	player_data.viewport_deg = player.shitport_degradation
	player_data.break_value = player.break_value

func load_player_data():
	if player_data:
		player.shitport_degradation = player_data.viewport_deg
		player.break_value = player_data.break_value



#func change_scene(path_to_scene):
#	save_player_data()
#	
#	call_deferred("_change_scene_deferred", path_to_scene)
#
#func _change_scene_deferred(path_to_scene):
#	get_tree().change_scene_to_file(path_to_scene)

func change_scene(path):
	save_player_data()
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	#current_scene.free()

	# Load the new scene.
	#var s = ResourceLoader.load(path)

	# Instance the new scene.
	#current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	#get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	#get_tree().set_current_scene(current_scene)
	
	get_tree().change_scene_to_file(path)
