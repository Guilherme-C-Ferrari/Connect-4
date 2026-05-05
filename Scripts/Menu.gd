extends Control
signal menu_botao_pressionado(botao: Button)

func _ready() -> void:
	for botao in $MarginContainer/VBoxContainer.get_children():
		if botao is Button:
			botao.pressed.connect(_on_button_pressed.bind(botao))

func _on_button_pressed(botao: Button) -> void:
	emit_signal("menu_botao_pressionado", botao)
