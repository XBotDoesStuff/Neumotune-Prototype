extends Node

enum ACCESS_LEVEL {
	maintenance,
	adminsistrator
}

var player : Player
var player_access_level : ACCESS_LEVEL = ACCESS_LEVEL.maintenance

var display : PlayerDisplay
