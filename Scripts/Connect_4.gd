extends Node2D

@onready var buttons = $Tabuleiro/HBoxContainer.get_children()
@onready var label_resultado = $Menu/Label
@onready var botao_jogo = $Menu/Button

var ficha = preload("res://Cenas/ficha.tscn")
var tabuleiro = preload("res://Scripts/Tabuleiro.gd")
var minimax = preload("res://Scripts/Minimax.gd")

var tabuleiro_jogo := Tabuleiro.new()
var ia := Minimax.new()

func _ready() -> void:
	# Implementar
	pass

func _on_coluna_pressionada():
	# Implementar
	pass

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
	for button in buttons:
		button.disabled = false

func desabilitar_botoes():
	for button in buttons:
		button.disabled = true

func reset_game():
	tabuleiro_jogo = Tabuleiro.new()
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
