extends Control
signal menu_botao_pressionado(botao: TextureButton)
signal menu_botao_modo_pressionado(botao: TextureButton)
signal menu_botao_dificuldade_pressionado(botao: TextureButton)
signal menu_botao_comeco_pressionado(botao: TextureButton)

func _ready() -> void:
	for botao in $MarginContainerBotoes/VBoxContainer.get_children():
		if botao is TextureButton:
			botao.pressed.connect(_on_button_pressed.bind(botao))
	for botao in $PanelDeModoContainer/PanelContainer/NinePatchRect/MarginContainer3/VBoxContainer.get_children():
		if botao is TextureButton:
			botao.pressed.connect(_on_button_pressed.bind(botao))

func _on_button_pressed(botao: TextureButton) -> void:
	emit_signal("menu_botao_pressionado", botao)

func _on_button_modo_pressed(botao: TextureButton) -> void:
	emit_signal("menu_botao_modo_pressionado", botao)

func _on_button_dificuldade_pressed(botao: TextureButton) -> void:
	emit_signal("menu_botao_dificuldade_pressionado", botao)

func _on_button_comeco_pressed(botao: TextureButton) -> void:
	emit_signal("menu_botao_comeco_pressionado", botao)
