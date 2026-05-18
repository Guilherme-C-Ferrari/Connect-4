extends Node

@onready var bgm_streamer := $BackgroundMusic
const SOM_BOTAO = preload("res://Assets/Sons/menu_button - freesound_community.mp3")

func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)

func play_background_music(stream: AudioStream) -> void:
	if bgm_streamer.stream == stream:
		return
	bgm_streamer.stream = stream
	bgm_streamer.play()

func play_sound_effect(stream: AudioStream, bus: String = "Master") -> void:
	var new_sfx := AudioStreamPlayer.new()
	new_sfx.stream = stream
	new_sfx.bus = bus
	new_sfx.finished.connect(destroy_stream_player.bind(new_sfx))
	add_child(new_sfx)
	new_sfx.play()

func destroy_stream_player(stream_player: AudioStreamPlayer) -> void:
	stream_player.queue_free()

func _on_node_added(node: Node) -> void:
	if node is TextureButton:
		node.pressed.connect(play_sound_effect.bind(SOM_BOTAO, "SFX"))
