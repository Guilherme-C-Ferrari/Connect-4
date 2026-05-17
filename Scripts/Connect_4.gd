extends Node2D

@onready var botoes = $GameContainer/TabuleiroFisico/HBoxContainer.get_children()
@onready var container_fichas = $GameContainer/FichasContainer
@onready var label_principal = $UI/MenuTabuleiro/%LabelPrincipal
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

var modo_de_jogo : int = 1 # 1 = P x P, 2 = P X IA, 3 = IA X IA
var dificuldade_ia : int = 1 # 1 = fácil, 2 = médio, 3 = difícil
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
		avaliar_final(jogador)
	if modo_de_jogo == 1:
		alternar_vez_IA()

func _on_coluna_pressionada_ia(coluna: int) -> void:
	var jogador = jogo.jogador_atual()
	if jogar(coluna):
		criar_ficha_fisica(coluna, jogador)
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
	
	container_fichas.add_child(nova_ficha)

func jogar(movimento: int) -> bool:
	if jogo.fazer_jogada(movimento):
		return true
	else:
		return false

func alternar_vez_IA() -> void:
	self.vezIA = not vezIA

func calcular_jogada_maquina() -> void:
	ia.finalizar_ia = false
	var jogador = jogo.jogador_atual()
	var jogada_ia : Jogada = ia.definir_melhor_jogada(jogo.duplicate(true), jogador, 7)
	call_deferred("finalizar_jogada_ia", jogada_ia.movimento)

func finalizar_jogada_ia(movimento: int) -> void:
	if thread.is_alive():
		thread.wait_to_finish()
	
	if not ia.finalizar_ia:
		_on_coluna_pressionada_ia(movimento)

func avaliar_final(jogador: String) -> void:
	var avaliacao: float = jogo.avaliar(jogador)
	if abs(avaliacao) == 1000:
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
	
	label_principal.text = ""
	label_principal.add_theme_font_size_override("font_size", 20)
	jogo = Tabuleiro.new()
	get_tree().call_group("Fichas", "queue_free")
	get_tree().call_group("Colunas", "reset")
	iniciar_novo_jogo()

func iniciar_novo_jogo() -> void:
	if modo_de_jogo == 3 or (modo_de_jogo == 1 and comecoIA == 2):
		vezIA = true
		iniciar_jogada_IA()
	else:
		habilitar_botoes()

func iniciar_jogada_IA() -> void:
	if vezIA:
		desabilitar_botoes()
		if thread and thread.is_alive():
			thread.wait_to_finish()
		thread = Thread.new()
		thread.start(calcular_jogada_maquina.bind())

func _on_button_pressed(botao: TextureButton) -> void:
	match botao.name:
		"BotaoNovoJogo":
			if modo_de_jogo == 1:
				painel_comeco.visible = true;
			else:
				reset_game()
		"ConfigurarJogo":
			label_principal.text = ""
			painel_modo.visible = true; 
		"VoltarAoMenu":
			if thread and thread.is_alive():
				ia.finalizar_ia = true
				thread.wait_to_finish()
			var cena_carregada = ResourceLoader.load_threaded_get(MENU_INICIAL)
			get_tree().change_scene_to_packed(cena_carregada)

func _on_button_modo_pressed(botao: TextureButton) -> void:
	match botao.name:
		"PlayerXIA":
			modo_de_jogo = 1
		"PlayerXPlayer":
			modo_de_jogo = 2
		"IAXIA":
			modo_de_jogo = 3
	
	painel_modo.visible = false; 
	if modo_de_jogo != 2:
		painel_dificuldade.visible = true; 

func _on_button_dificuldade_pressed(botao: TextureButton) -> void:
	match botao.name:
		"Facil":
			dificuldade_ia = 1
		"Medio":
			dificuldade_ia = 2
		"Dificil":
			dificuldade_ia = 3
	painel_dificuldade.visible = false; 

func _on_button_comeco_pressed(botao: TextureButton) -> void:
	match botao.name:
		"Primeiro":
			comecoIA = 1
		"Segundo":
			comecoIA = 2
	painel_comeco.visible = false;
