extends Resource
class_name Jogada

var movimento: int
var avaliacao: float

func _init(p_movimento: int, p_avaliacao: float):
	self.movimento = p_movimento
	self.avaliacao = p_avaliacao
