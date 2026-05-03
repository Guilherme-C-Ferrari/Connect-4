extends Node2D
signal ficha_alocada

@onready var linha_atual = 1

func _ready() -> void:
	for area in get_children():
		if area is Area2D:
			area.body_entered.connect(_on_ficha_entrou.bind(area))
			area.get_node("CollisionShape2D").disabled = (area.name != "Area2D_Linha1")

func _on_ficha_entrou(body, area) -> void:
	if body is RigidBody2D:
		body.freeze = true
		body.global_position = area.global_position
		
		var shape = area.get_node("CollisionShape2D")
		shape.set_deferred("disabled", true)
		
		linha_atual += 1
		var proxima_area = get_node_or_null("Area2D_Linha" + str(linha_atual))
		if proxima_area:
			shape = proxima_area.get_node("CollisionShape2D")
			shape.set_deferred("disabled", false)
		
		emit_signal("ficha_alocada")

func reset() -> void:
	linha_atual = 1
	for area in get_children():
		if area is Area2D:
			var shape = area.get_node("CollisionShape2D")
			var desativar = (area.name != "Area2D_Linha1")
			shape.set_deferred("disabled", desativar)
