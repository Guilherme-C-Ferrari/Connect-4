extends Node2D

@onready var container_fichas = $GameContainer/FichasContainer
@onready var botoes = $GameContainer/TabuleiroFisico/HBoxContainer.get_children()
@onready var label_resultado = $CanvasLayer/Menu/%LabelPrincipal

var ficha = preload("res://Cenas/ficha.tscn")
var tabuleiro_logico = preload("res://Scripts/TabuleiroLogico.gd")
var minimax = preload("res://Scripts/Minimax.gd")

var jogo := Tabuleiro.new()
var ia := Minimax.new()

func _ready() -> void:
	for i in range(botoes.size()):
		botoes[i].pressed.connect(_on_coluna_pressionada.bind(i))
	desabilitar_botoes()

func _on_coluna_pressionada(coluna: int) -> void:
	desabilitar_botoes()
	var jogador = jogo.jogador_atual()
	if jogar(coluna, jogador):
		criar_ficha_fisica(coluna, jogador)
	else:
		habilitar_botoes()
	for linha in jogo.tabuleiro:
		print(linha)
	print("----------------------------------------")

func criar_ficha_fisica(coluna_index: int, jogador: String) -> void:
	var nova_ficha = ficha.instantiate()
	var botao = $GameContainer/TabuleiroFisico/HBoxContainer.get_child(coluna_index)
	
	var pos_global = botao.global_position + Vector2(botao.size.x / 2, -150)
	nova_ficha.position = container_fichas.to_local(pos_global)
	
	nova_ficha.get_node("FichaAmarela").visible = (jogador == jogo.JOGADOR_AMARELO)
	nova_ficha.get_node("FichaVermelha").visible = (jogador == jogo.JOGADOR_VERMELHO)
	
	container_fichas.add_child(nova_ficha)

func jogar(movimento: int, jogador: String) -> bool:
	if jogo.jogada(movimento):
		var avaliacao: float = jogo.avaliar()
		if avaliacao != 0.5:
			fim_jogo(jogador + " venceu!")
		elif jogo.empate():
			fim_jogo("EMPATOU")
		return true
	else:
		return false

func jogada_maquina():
	# Implementar
	pass

func fim_jogo(resultado: String) -> void:
	label_resultado.text = resultado
	desabilitar_botoes()

func habilitar_botoes() -> void:
	for i in range(botoes.size()):
		var botao = botoes[i]
		if jogo.valida_jogada(i):
			botao.disabled = false

func desabilitar_botoes() -> void:
	for botao in botoes:
		botao.disabled = true

func reset_game() -> void:
	label_resultado.text = ""
	jogo = Tabuleiro.new()
	get_tree().call_group("Fichas", "queue_free")
	get_tree().call_group("Colunas", "reset")
	habilitar_botoes()

func _on_button_pressed(botao: Button) -> void:
	if botao.name == "BotaoNovoJogo":
		reset_game()
	elif botao.name == "BotaoJogadaIA":
		print("Jogada IA")
	elif botao.name == "BotaoPartidaIA":
		print("Partida De IAs")
