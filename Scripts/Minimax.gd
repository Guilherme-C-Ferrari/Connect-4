extends Resource
class_name Minimax

const TABULEIRO = preload("res://Scripts/TabuleiroLogico.gd")
const JOGADA = preload ("res://Scripts/Jogada.gd")

func melhor_jogada(tabuleiro: Tabuleiro, jogador: String, profundidade_maxima: int) -> Jogada:
	var jogada: Jogada = minimax(tabuleiro, jogador, profundidade_maxima, 0)
	return jogada

func minimax(tabuleiro: Tabuleiro, jogador: String, profundidade_maxima: int, profundidade: int) -> Jogada:
	var avaliacao: float = tabuleiro.avaliar()
	if tabuleiro.empate() or abs(avaliacao) == 100 or profundidade == profundidade_maxima:
		var jog: Jogada = JOGADA.new(-1, avaliacao)
		return jog
		
	var melhores_jogadas: Array = []
	var melhor_pontuacao: float
	if tabuleiro.jogador_atual() == jogador:
		melhor_pontuacao = -INF
	else:
		melhor_pontuacao = INF
		
	for movimento in tabuleiro.jogadas_possiveis():
		var novo_tabuleiro: Tabuleiro = tabuleiro.movimentar(movimento, jogador)
		var novo_jogador: String = tabuleiro.JOGADOR_AMARELO if jogador == tabuleiro.JOGADOR_VERMELHO else tabuleiro.JOGADOR_VERMELHO
		var jogada: Jogada = minimax(novo_tabuleiro, novo_jogador, profundidade_maxima, profundidade + 1)
		
		jogada.movimento = movimento
		if profundidade == 0:
			print("JOGADA: ", jogada.movimento, " Avaliacao: ", jogada.avaliacao)
		
		# Atualiza a melhor jogada
		if tabuleiro.jogador_atual() == jogador:
			if jogada.avaliacao > melhor_pontuacao:
				melhor_pontuacao = jogada.avaliacao
				melhores_jogadas = []
				melhores_jogadas.append(jogada)
			elif jogada.avaliacao == melhor_pontuacao:
				melhores_jogadas.append(jogada)
		else:
			if jogada.avaliacao < melhor_pontuacao:
				melhor_pontuacao = jogada.avaliacao
				melhores_jogadas = []
				melhores_jogadas.append(jogada)
			elif jogada.avaliacao == melhor_pontuacao:
				melhores_jogadas.append(jogada)
			
	# Retorna uma dentre as melhores jogadas
	melhores_jogadas.shuffle()
	return melhores_jogadas[0]
