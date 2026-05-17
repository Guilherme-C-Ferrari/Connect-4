extends Control
signal menu_botao_pressionado(botao: TextureButton)
signal menu_botao_modo_pressionado(botao: TextureButton)
signal menu_botao_dificuldade_pressionado(botao: TextureButton)
signal menu_botao_comeco_pressionado(botao: TextureButton)
signal iniciar_novo_jogo()

func _ready() -> void:
	for botao in $MarginContainerBotoes/VBoxContainer.get_children():
		if botao is TextureButton:
			botao.pressed.connect(_on_button_pressed.bind(botao))
	for botao in $PanelDeModoContainer/PanelContainer/NinePatchRect/MarginContainer3/VBoxContainer.get_children():
		if botao is TextureButton:
			botao.pressed.connect(_on_button_modo_pressed.bind(botao))
	for botao in $PanelDeDificuldadeContainer/PanelContainer/NinePatchRect/MarginContainer3/VBoxContainer.get_children():
		if botao is TextureButton:
			botao.pressed.connect(_on_button_dificuldade_pressed.bind(botao))
	for centro in $PanelDeComecoContainer/PanelContainer/NinePatchRect/MarginContainer3/VBoxContainer.get_children():
		for botao in centro.get_children():
			if botao is TextureButton:
				botao.pressed.connect(_on_button_comeco_pressed.bind(botao))
				botao.mouse_entered.connect(_on_button_comeco_entered.bind(botao))
				botao.mouse_exited.connect(_on_button_comeco_exited.bind(botao))

func _on_button_pressed(botao: TextureButton) -> void:
	emit_signal("menu_botao_pressionado", botao)

func _on_button_modo_pressed(botao: TextureButton) -> void:
	emit_signal("menu_botao_modo_pressionado", botao)

func _on_button_dificuldade_pressed(botao: TextureButton) -> void:
	emit_signal("menu_botao_dificuldade_pressionado", botao)

func _on_button_comeco_pressed(botao: TextureButton) -> void:
	emit_signal("menu_botao_comeco_pressionado", botao)
	emit_signal("iniciar_novo_jogo")

func _on_button_comeco_entered(botao: TextureButton) -> void:
	var tamanho_hover = Vector2(175,125)
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(botao, "custom_minimum_size", tamanho_hover, 0.1)

func _on_button_comeco_exited(botao: TextureButton) -> void:
	var tamanho_hover = Vector2(150,100)
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(botao, "custom_minimum_size", tamanho_hover, 0.1)
