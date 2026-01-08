class_name AudioInteractable
extends Interactable

@export var audio_file : AudioStream
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	audio_player.stream = audio_file

func interact():
	audio_player.play()
