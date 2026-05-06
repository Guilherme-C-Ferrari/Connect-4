extends Resource
class_name Tabuleiro

const JOGADOR_AMARELO = "A"
const JOGADOR_VERMELHO = "V"
const SEM_JOGADA = "-"

const LINHAS = 6
const COLUNAS = 7

@export_storage var tabuleiro: Array
@export_storage var jogador: String

func _init():
	for i in range(LINHAS):
		var linha = []
		linha.resize(COLUNAS)
		linha.fill(SEM_JOGADA)
		tabuleiro.append(linha)
	self.jogador = JOGADOR_AMARELO
	
func alternar_jogador() -> void:
	self.jogador = JOGADOR_AMARELO if self.jogador == JOGADOR_VERMELHO else JOGADOR_VERMELHO

func empate() -> bool:
	for coluna in range(COLUNAS):
		if self.tabuleiro[0][coluna] == SEM_JOGADA:
			return false
	return true

func avaliar() -> float:
	var eval: float = 0.5
	pass
	#for i in range(LINHAS):
		#for j in range(COLUNAS):
			#if i < 3 and j < 4:
				#if self.tabuleiro[i][j] == self.tabuleiro[i][(j+1)] and self.tabuleiro[i][(j+1)] == self.tabuleiro[i][(j+2)]  self.tabuleiro[i][(j+3)] and self.tabuleiro[i][(j)] != SEM_JOGADA:
					#eval = 100 if self.tabuleiro[i][j] == self.jogador else -100
				#if self.tabuleiro[i][j] == self.tabuleiro[(i+1)][j] == self.tabuleiro[(i+2)][j] == self.tabuleiro[(i+3)][j] and self.tabuleiro[i][(j)] != SEM_JOGADA:
					#eval = 100 if self.tabuleiro[i][j] == self.jogador else -100
				#if self.tabuleiro[i][j] == self.tabuleiro[(i+1)][j+1] == self.tabuleiro[(i+2)][j+2] == self.tabuleiro[(i+3)][j+3] and self.tabuleiro[i][(j)] != SEM_JOGADA:
					#eval = 100 if tabuleiro[i][j] == self.jogador else -100
			#elif i < 3 and j > 2:
				#if self.tabuleiro[i][j] == self.tabuleiro[(i+1)][j-1] == self.tabuleiro[(i+2)][j-2] == self.tabuleiro[(i+3)][j-3] and self.tabuleiro[i][(j)] != SEM_JOGADA: 
					#eval = 100 if tabuleiro[i][j] == self.jogador else -100
	return eval 

func jogador_atual() -> String:
	return jogador

func jogadas_possiveis() -> Array:
	var jogadas: Array = []
	for coluna in range(COLUNAS):
		if tabuleiro[0][coluna] == SEM_JOGADA:
			jogadas.append(coluna)
	return jogadas

func movimentar(movimento: int, p_jogador: String) -> Tabuleiro:
	var novo_tabuleiro = self.duplicate(true)
	for linha in range((LINHAS - 1), -1, -1):
		if novo_tabuleiro.tabuleiro[linha][movimento] == SEM_JOGADA:
			novo_tabuleiro.tabuleiro[linha][movimento] = p_jogador
			break
	return novo_tabuleiro

func valida_jogada(coluna: int) -> bool:
	if tabuleiro[0][coluna] == SEM_JOGADA:
		return true
	else:
		return false

func jogada(coluna: int) -> bool:
	if valida_jogada(coluna):
		for linha in range((LINHAS - 1), -1, -1):
			if tabuleiro[linha][coluna] == SEM_JOGADA:
				tabuleiro[linha][coluna] = jogador
				alternar_jogador()
				return true
	return false
