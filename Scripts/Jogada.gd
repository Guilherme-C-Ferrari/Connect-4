extends Resource
class_name Jogada

var movimento: int
var avaliacao: float

func _init(movimento: int, avaliacao: float):
	self.movimento = movimento
	self.avaliacao = avaliacao
