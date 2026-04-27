extends Node2D

var minimax = preload("res://Scripts/Minimax.gd")
var tabuleiro = preload("res://Scripts/Tabuleiro.gd")
var tabuleiro_jogo := Tabuleiro.new()
var ia := Minimax.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
