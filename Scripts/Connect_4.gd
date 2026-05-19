extends Node2D

@onready var botoes = $GameContainer/TabuleiroFisico/HBoxContainer.get_children()
@onready var container_fichas = $GameContainer/FichasContainer
@onready var label_principal = $UI/MenuTabuleiro/%LabelPrincipal
@onready var indicador_azul = $UI/MenuTabuleiro/%TurnoAzul
@onready var indicador_roxo = $UI/MenuTabuleiro/%TurnoRoxo
@onready var painel_modo = $UI/MenuTabuleiro/PanelDeModoContainer
@onready var painel_dificuldade = $UI/MenuTabuleiro/PanelDeDificuldadeContainer
@onready var painel_comeco = $UI/MenuTabuleiro/PanelDeComecoContainer

const MENU_INICIAL = "res://Cenas/menu_inicial.tscn"

var ficha = preload("res://Cenas/ficha.tscn")
var tabuleiro_logico = preload("res://Scripts/TabuleiroLogico.gd")
var minimax = preload("res://Scripts/Minimax.gd")

var thread: Thread
var jogo := Tabuleiro.new()
var ia := Minimax.new()

var estado_jogo : int = 1 # 1 = Ativo, 2 = Finalizado
var modo_de_jogo : int = 1 # 1 = P x P, 2 = P X IA, 3 = IA X IA
var novo_modo_de_jogo : int = 1
var dificuldade_ia : int = 3 # 1 = fácil, 2 = médio, 3 = difícil
var nova_dificuldade_ia : int = 3
var comecoIA : int = 1 # 1 = player começa, 2 = IA começa
var vezIA : bool = false

func _ready() -> void:
	ResourceLoader.load_threaded_request(MENU_INICIAL)
	label_principal.text = "Modo\nconfigurado:\nPlayer x ia\n\nClique em\nConfigurar Jogo\nPara Alterar"
	for i in range(botoes.size()):
		botoes[i].pressed.connect(_on_coluna_pressionada.bind(i))
	desabilitar_botoes()

func _on_coluna_pressionada(coluna: int) -> void:
	desabilitar_botoes()
	var jogador = jogo.jogador_atual()
	if jogar(coluna):
		criar_ficha_fisica(coluna, jogador)
		alternar_indicador_turno()
		avaliar_final(jogador)
	if modo_de_jogo == 1:
		alternar_vez_IA()

func _on_coluna_pressionada_ia(coluna: int) -> void:
	var jogador = jogo.jogador_atual()
	if jogar(coluna):
		criar_ficha_fisica(coluna, jogador)
		alternar_indicador_turno()
		avaliar_final(jogador)
	if modo_de_jogo == 1:
		alternar_vez_IA()

func criar_ficha_fisica(coluna_index: int, jogador: String) -> void:
	var nova_ficha = ficha.instantiate()
	var botao = $GameContainer/TabuleiroFisico/HBoxContainer.get_child(coluna_index)
	
	var pos_global = botao.global_position + Vector2(botao.size.x / 2, -150)
	nova_ficha.position = container_fichas.to_local(pos_global)
	
	nova_ficha.get_node("FichaRoxa").visible = (jogador == jogo.JOGADOR_ROXO)
	nova_ficha.get_node("FichaAzul").visible = (jogador == jogo.JOGADOR_AZUL)
	var som_sorteado = [AudioManager.SOM_FICHA_1, AudioManager.SOM_FICHA_2].pick_random()
	
	container_fichas.add_child(nova_ficha)
	AudioManager.play_sound_effect(som_sorteado, "SFX")

func jogar(movimento: int) -> bool:
	if jogo.fazer_jogada(movimento):
		return true
	else:
		return false

func alternar_vez_IA() -> void:
	self.vezIA = not vezIA

func alternar_indicador_turno() -> void:
	var jogador = jogo.jogador_atual()
	if jogador == jogo.JOGADOR_ROXO:
		indicador_azul.visible = false
		indicador_roxo.visible = true
	elif jogador == jogo.JOGADOR_AZUL:
		indicador_roxo.visible = false
		indicador_azul.visible = true

func calcular_jogada_maquina() -> void:
	ia.finalizar_ia = false
	var jogador = jogo.jogador_atual()
	var jogada_ia: Jogada
	match dificuldade_ia:
		1:
			if randf() < 0.7:
				jogada_ia = Jogada.new(calcular_jogada_aleatoria(), 0)
			else:
				jogada_ia = ia.definir_melhor_jogada(jogo.duplicate(true), jogador, 2)
		2:
			if randf() < 0.2:
				jogada_ia = Jogada.new(calcular_jogada_aleatoria(), 0)
			else:
				jogada_ia = ia.definir_melhor_jogada(jogo.duplicate(true), jogador, 5)
		3:
			jogada_ia = ia.definir_melhor_jogada(jogo.duplicate(true), jogador, 7)
	call_deferred("finalizar_jogada_ia", jogada_ia.movimento)

func calcular_jogada_aleatoria() -> int:
	var colunas_validas : Array = []
	for i in range(jogo.COLUNAS):
		if jogo.valida_jogada(i):
			colunas_validas.append(i)
	if colunas_validas.size() > 0:
		return colunas_validas.pick_random()
	return 0

func finalizar_jogada_ia(movimento: int) -> void:
	if thread.is_alive():
		thread.wait_to_finish()
	
	if not ia.finalizar_ia:
		_on_coluna_pressionada_ia(movimento)

func avaliar_final(jogador: String) -> void:
	var avaliacao: float = jogo.avaliar(jogador)
	if abs(avaliacao) == 1000:
		estado_jogo = 2
		indicador_azul.visible = false
		indicador_roxo.visible = false
		label_principal.add_theme_color_override("font_color", Color.from_string("FFD700", Color.YELLOW))
		if jogador == "R":
			fim_jogo("Roxo\nVenceu!")
		elif jogador == "A":
			fim_jogo("Azul\nVenceu!")
	elif jogo.empate():
		fim_jogo("EMPATOU")

func fim_jogo(resultado: String) -> void:
	label_principal.text = resultado
	desabilitar_botoes()

func habilitar_botoes() -> void:
	if label_principal.text == "Roxo\nVenceu!" or label_principal.text == "Azul\nVenceu!":
		return
	for i in range(botoes.size()):
		var botao = botoes[i]
		if jogo.valida_jogada(i):
			botao.disabled = false

func desabilitar_botoes() -> void:
	for botao in botoes:
		botao.disabled = true

func reset_game() -> void:
	if thread and thread.is_alive():
		ia.finalizar_ia = true
		thread.wait_to_finish()
	
	indicador_azul.visible = false
	indicador_roxo.visible = false
	label_principal.text = ""
	label_principal.add_theme_font_size_override("font_size", 20)
	label_principal.add_theme_color_override("font_color", Color.WHITE)
	
	estado_jogo = 1
	jogo = Tabuleiro.new()
	get_tree().call_group("Fichas", "queue_free")
	get_tree().call_group("Colunas", "reset")
	
	iniciar_novo_jogo()

func iniciar_novo_jogo() -> void:
	alternar_indicador_turno()
	if (modo_de_jogo == 1 and comecoIA == 2) or modo_de_jogo == 3:
		if modo_de_jogo == 3 : vezIA = true
		iniciar_jogada_IA()
	else:
		vezIA = false
		habilitar_botoes()

func iniciar_jogada_IA() -> void:
	if vezIA and estado_jogo == 1:
		desabilitar_botoes()
		call_deferred("iniciar_thread")

func iniciar_thread() -> void:
	if thread and thread.is_started():
		thread.wait_to_finish()
	thread = Thread.new()
	thread.start(calcular_jogada_maquina.bind())

func _on_button_pressed(botao: TextureButton) -> void:
	match botao.name:
		"BotaoNovoJogo":
			modo_de_jogo = novo_modo_de_jogo
			dificuldade_ia = nova_dificuldade_ia
			if modo_de_jogo == 1:
				painel_comeco.visible = true;
			else:
				reset_game()
		"ConfigurarJogo":
			label_principal.text = ""
			painel_modo.visible = true; 
		"VoltarAoMenu":
			if thread and thread.is_started():
				ia.finalizar_ia = true
				thread.wait_to_finish()
			var cena_carregada = ResourceLoader.load_threaded_get(MENU_INICIAL)
			get_tree().change_scene_to_packed(cena_carregada)

func _on_button_modo_pressed(botao: TextureButton) -> void:
	match botao.name:
		"PlayerXIA":
			novo_modo_de_jogo = 1
		"PlayerXPlayer":
			novo_modo_de_jogo = 2
		"IAXIA":
			novo_modo_de_jogo = 3
	
	painel_modo.visible = false; 
	if novo_modo_de_jogo != 2:
		painel_dificuldade.visible = true; 

func _on_button_dificuldade_pressed(botao: TextureButton) -> void:
	match botao.name:
		"Facil":
			nova_dificuldade_ia = 1
		"Medio":
			nova_dificuldade_ia = 2
		"Dificil":
			nova_dificuldade_ia = 3
	painel_dificuldade.visible = false; 

func _on_button_comeco_pressed(botao: TextureButton) -> void:
	match botao.name:
		"Primeiro":
			comecoIA = 1
			vezIA = false
		"Segundo":
			comecoIA = 2
			vezIA = true
	painel_comeco.visible = false;
