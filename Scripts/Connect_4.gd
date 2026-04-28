extends Node2D

@onready var botoes = $TabuleiroFisico/HBoxContainer.get_children()
@onready var label_resultado = $Menu/Label
@onready var botao_jogo = $Menu/Button

var ficha = preload("res://Cenas/ficha.tscn")
var tabuleiro = preload("res://Scripts/Tabuleiro.gd")
var minimax = preload("res://Scripts/Minimax.gd")

var tabuleiro_logico := Tabuleiro.new()
var ia := Minimax.new()

func _ready() -> void:
	for i in range(botoes.size()):
		botoes[i].pressed.connect(_on_coluna_pressionada.bind(i))

func _on_coluna_pressionada(coluna):
	criar_ficha_fisica(coluna)

func criar_ficha_fisica(coluna_index):
	var nova_ficha = ficha.instantiate()
	add_child(nova_ficha)
	
	var botao = $TabuleiroFisico/HBoxContainer.get_child(coluna_index)
	var posX = $TabuleiroFisico.position.x + botao.position.x + (botao.size.x / 2)
	var posY = $TabuleiroFisico/HBoxContainer.position.y - 50 
	nova_ficha.position = Vector2(posX, posY)

func jogar() -> bool:
	# Implementar
	pass
	return false

func jogada_maquina():
	# Implementar
	pass

func fim_jogo(resultado):
	label_resultado.text = resultado
	desabilitar_botoes()
	botao_jogo.text = "Novo Jogo"

func habilitar_botoes():
	for botao in botoes:
		botao.disabled = false

func desabilitar_botoes():
	for botao in botoes:
		botao.disabled = true

func reset_game():
	tabuleiro_logico = Tabuleiro.new()
	# Implementar
	pass

func _on_button_pressed():
	if botao_jogo.text == "Novo Jogo":
		botao_jogo.text = "Jogada IA"
		label_resultado.text = ""
		habilitar_botoes()
		reset_game()
	else:
		jogada_maquina()
