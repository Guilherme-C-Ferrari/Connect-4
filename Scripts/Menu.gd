extends Control
signal menu_botao_pressionado

func _on_button_pressed() -> void:
	emit_signal("menu_botao_pressionado")
