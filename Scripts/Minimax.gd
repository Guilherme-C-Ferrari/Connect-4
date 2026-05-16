extends Resource
class_name Minimax

const TABULEIRO = preload("res://Scripts/TabuleiroLogico.gd")
const JOGADA = preload ("res://Scripts/Jogada.gd")
const INFINITO: int = 9999
var finalizar_ia: bool = false

func melhor_jogada(tabuleiro: Tabuleiro, jogador: String, profundidade_maxima: int) -> Jogada:
	var jogada: Jogada = minimax(tabuleiro, jogador, jogador, profundidade_maxima, 0, -INFINITO, INFINITO)
	print("-------------------------------------------")
	return jogada

func minimax(tabuleiro: Tabuleiro, jogador_inicial: String, jogador_atual: String, profundidade_maxima: int, profundidade: int, alfa: int, beta: int) -> Jogada:
	var avaliacao: float = tabuleiro.avaliar(jogador_inicial)
	
	if finalizar_ia:
		var jog: Jogada = JOGADA.new(-1, 0)
		return jog
	if tabuleiro.empate() or abs(avaliacao) == 1000 or profundidade == profundidade_maxima:
		if abs(avaliacao) == 1000:
			avaliacao -= profundidade
		var jog: Jogada = JOGADA.new(-1, avaliacao)
		return jog
		
	var melhores_jogadas: Array = []
	var melhor_pontuacao: float
	
	if tabuleiro.jogador_atual() == jogador_atual:
		melhor_pontuacao = -INF
	else:
		melhor_pontuacao = INF
		
	for movimento in tabuleiro.jogadas_possiveis():
		if finalizar_ia: break
		
		var novo_tabuleiro: Tabuleiro = tabuleiro.movimentar(movimento, jogador_atual)
		var novo_jogador: String = tabuleiro.JOGADOR_ROXO if jogador_atual == tabuleiro.JOGADOR_AZUL else tabuleiro.JOGADOR_AZUL
		var jogada: Jogada = minimax(novo_tabuleiro, jogador_inicial, novo_jogador, profundidade_maxima, profundidade + 1, alfa, beta)
		jogada.movimento = movimento
		
		if profundidade == 0:
			print("JOGADA: ", jogada.movimento+1, " Avaliacao: ", jogada.avaliacao)
		
		if tabuleiro.jogador_atual() == jogador_atual:
			if jogada.avaliacao > melhor_pontuacao:
				melhor_pontuacao = jogada.avaliacao
				melhores_jogadas = []
				melhores_jogadas.append(jogada)
			elif jogada.avaliacao == melhor_pontuacao:
				melhores_jogadas.append(jogada)
			
			alfa = max(alfa, melhor_pontuacao)
			if alfa >= beta:
				break
		else:
			if jogada.avaliacao < melhor_pontuacao:
				melhor_pontuacao = jogada.avaliacao
				melhores_jogadas = []
				melhores_jogadas.append(jogada)
			elif jogada.avaliacao == melhor_pontuacao:
				melhores_jogadas.append(jogada)
			
			beta = min(beta, melhor_pontuacao)
			if alfa >= beta:
				break
	# melhores_jogadas.shuffle()
	return melhores_jogadas[0]
