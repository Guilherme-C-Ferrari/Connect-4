extends Control

const JOGO_CONNECT_4 = "res://Cenas/connect-4.tscn"

func _ready() -> void:
	ResourceLoader.load_threaded_request(JOGO_CONNECT_4)

func _on_jogar_pressed() -> void:
	var cena_carregada = ResourceLoader.load_threaded_get(JOGO_CONNECT_4)
	get_tree().change_scene_to_packed(cena_carregada)

func _on_creditos_pressed() -> void:
	$PanelDeCreditosContainer.visible = true

func _on_fechar_pressed() -> void:
	$PanelDeCreditosContainer.visible = false
