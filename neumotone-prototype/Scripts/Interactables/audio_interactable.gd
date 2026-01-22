class_name AudioInteractable
extends Interactable

@export var audio_file : AudioStream
var audio_player : AudioStreamPlayer3D

func _ready() -> void:
	if audio_player:
		audio_player.queue_free()
	
	print(audio_file)

func interact():
	if not audio_player:
		audio_player = AudioStreamPlayer3D.new()
		add_child(audio_player)
		audio_player.finished.connect(queue_free)
		audio_player.stream = audio_file
		audio_player.play(0.0)
