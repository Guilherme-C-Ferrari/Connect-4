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

func avaliar(param_jogador: String) -> float:
	var eval: float = 0
	var conexao: Array = []
	var valor_conexao
	for i in range(LINHAS):
		for j in range(COLUNAS):
			if j < 4:
				# Horizontal
				conexao = [self.tabuleiro[i][j], self.tabuleiro[i][(j+1)], self.tabuleiro[i][(j+2)], self.tabuleiro[i][(j+3)]]
				valor_conexao = avaliar_conexao(conexao, param_jogador)
				if abs(valor_conexao) >= 100:
					return valor_conexao
				eval += valor_conexao
				
			if i < 3:
				# Vertical
				conexao = [self.tabuleiro[i][j], self.tabuleiro[(i+1)][j], self.tabuleiro[(i+2)][j], self.tabuleiro[(i+3)][j]]
				valor_conexao = avaliar_conexao(conexao, param_jogador)
				if abs(valor_conexao) >= 100:
					return valor_conexao
				eval += valor_conexao
				
				if j < 4:
					# Diagonal principal
					conexao = [self.tabuleiro[i][j], self.tabuleiro[(i+1)][(j+1)], self.tabuleiro[(i+2)][(j+2)], self.tabuleiro[(i+3)][(j+3)]]
					valor_conexao = avaliar_conexao(conexao, param_jogador)
					if abs(valor_conexao) >= 100:
						return valor_conexao
					eval += valor_conexao
					
				if j > 2:
					# Diagonal secundária
					conexao = [self.tabuleiro[i][j], self.tabuleiro[(i+1)][(j-1)], self.tabuleiro[(i+2)][(j-2)], self.tabuleiro[(i+3)][(j-3)]]
					valor_conexao = avaliar_conexao(conexao, param_jogador)
					if abs(valor_conexao) >= 100:
						return valor_conexao
					eval += valor_conexao 
	return eval 

func avaliar_conexao(conexao: Array, param_jogador: String) -> float:
	var eval: float = 0
	var oponente = JOGADOR_AMARELO if param_jogador == JOGADOR_VERMELHO else JOGADOR_VERMELHO
	
	var contabilizacao_jogador = conexao.count(param_jogador)
	var contabilizacao_oponente = conexao.count(oponente)
	var contabilizacao_vazio = conexao.count(SEM_JOGADA)
	
	if contabilizacao_jogador == 4: eval += 100
	elif contabilizacao_jogador == 3 and contabilizacao_vazio == 1: eval += 5
	elif contabilizacao_jogador == 2 and contabilizacao_vazio == 2: eval += 2
	elif contabilizacao_oponente == 4: eval -= 100
	elif contabilizacao_oponente == 3 and contabilizacao_vazio == 1: eval -= 5
	elif contabilizacao_oponente == 2 and contabilizacao_vazio == 2: eval -= 2
	
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
