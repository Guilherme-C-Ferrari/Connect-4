extends Node2D

@onready var container_fichas = $GameContainer/FichasContainer
@onready var botoes = $GameContainer/TabuleiroFisico/HBoxContainer.get_children()
@onready var label_resultado = $UI/MenuTabuleiro/%LabelPrincipal

var ficha = preload("res://Cenas/ficha.tscn")
var tabuleiro_logico = preload("res://Scripts/TabuleiroLogico.gd")
var minimax = preload("res://Scripts/Minimax.gd")

var jogo := Tabuleiro.new()
var ia := Minimax.new()
var thread: Thread

func _ready() -> void:
	for i in range(botoes.size()):
		botoes[i].pressed.connect(_on_coluna_pressionada.bind(i))
	desabilitar_botoes()

func _on_coluna_pressionada(coluna: int) -> void:
	desabilitar_botoes()
	var jogador = jogo.jogador_atual()
	if jogar(coluna):
		criar_ficha_fisica(coluna, jogador)
		avaliar_final(jogador)
	else:
		habilitar_botoes()

func _on_coluna_pressionada_ia(coluna: int) -> void:
	var jogador = jogo.jogador_atual()
	if jogar(coluna):
		criar_ficha_fisica(coluna, jogador)
		avaliar_final(jogador)

func criar_ficha_fisica(coluna_index: int, jogador: String) -> void:
	var nova_ficha = ficha.instantiate()
	var botao = $GameContainer/TabuleiroFisico/HBoxContainer.get_child(coluna_index)
	
	var pos_global = botao.global_position + Vector2(botao.size.x / 2, -150)
	nova_ficha.position = container_fichas.to_local(pos_global)
	
	nova_ficha.get_node("FichaRoxa").visible = (jogador == jogo.JOGADOR_ROXO)
	nova_ficha.get_node("FichaAzul").visible = (jogador == jogo.JOGADOR_AZUL)
	
	container_fichas.add_child(nova_ficha)

func jogar(movimento: int) -> bool:
	if jogo.jogada(movimento):
		return true
	else:
		return false

func jogada_maquina() -> void:
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
			fim_jogo("Roxo Venceu!")
		elif jogador == "A":
			fim_jogo("Azul Venceu!")
	elif jogo.empate():
		fim_jogo("EMPATOU")

func fim_jogo(resultado: String) -> void:
	label_resultado.text = resultado
	desabilitar_botoes()

func habilitar_botoes() -> void:
	if label_resultado.text != "":
		return
	
	var botao_IA_j = $UI/MenuTabuleiro/%BotaoJogadaIA
	var botao_IA_p = $UI/MenuTabuleiro/%BotaoPartidaIA
	botao_IA_j.disabled = false
	botao_IA_p.disabled = false
	
	for i in range(botoes.size()):
		var botao = botoes[i]
		if jogo.valida_jogada(i):
			botao.disabled = false

func desabilitar_botoes() -> void:
	var botao_IA_j = $UI/MenuTabuleiro/%BotaoJogadaIA
	var botao_IA_p = $UI/MenuTabuleiro/%BotaoPartidaIA
	botao_IA_j.disabled = true
	botao_IA_p.disabled = true
	
	for botao in botoes:
		botao.disabled = true

func reset_game() -> void:
	if thread and thread.is_alive():
		ia.finalizar_ia = true
		thread.wait_to_finish()
	
	label_resultado.text = ""
	jogo = Tabuleiro.new()
	get_tree().call_group("Fichas", "queue_free")
	get_tree().call_group("Colunas", "reset")
	habilitar_botoes()

func _on_button_pressed(botao: TextureButton) -> void:
	if botao.name == "BotaoNovoJogo":
		reset_game()
	elif botao.name == "BotaoJogadaIA":
		desabilitar_botoes()
		thread = Thread.new()
		thread.start(jogada_maquina.bind())
	elif botao.name == "BotaoPartidaIA":
		print("Partida De IAs")
