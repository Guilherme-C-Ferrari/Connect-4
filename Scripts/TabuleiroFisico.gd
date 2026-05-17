extends Node2D
signal tabuleiro_liberado
signal jogada_finalizada

func _ready() -> void:
	for coluna in $Slots.get_children():
		coluna.ficha_alocada.connect(_on_ficha_parou)

func _on_ficha_parou() -> void:
	emit_signal("tabuleiro_liberado")
	emit_signal("jogada_finalizada")
