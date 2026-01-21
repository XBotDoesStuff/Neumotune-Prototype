extends Node

enum ACCESS_LEVEL {
	maintenance,
	adminsistrator
}

var player : Player
var player_data : PlayerData
var player_access_level : ACCESS_LEVEL = ACCESS_LEVEL.maintenance

var display : PlayerDisplay

func save_player_data():
	if not player_data:
		player_data = PlayerData.new()
	
	player_data.viewport_deg = player.shitport_degradation
	player_data.break_value = player.break_value

func load_player_data():
	if player_data:
		player.shitport_degradation = player_data.viewport_deg
		player.break_value = player_data.break_value



func change_scene(path_to_scene):
	save_player_data()
	
	call_deferred("_change_scene_deferred", path_to_scene)

func _change_scene_deferred(path_to_scene):
	get_tree().change_scene_to_file(path_to_scene)
