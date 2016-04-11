04/02:
- Comecei a documentar com atraso, já fiz muitas coisas que esqueci. 
- Estou tentando usar o otimizador aleatório. Até o momento este é o que deu melhores resultados.
- Começo com as forças nulas e tento iterar esse otimizador, sendo cada vez mais ousado nos requisitos.
- Atualmente estou olhando os tune-shifts com amplitude e energia, número de partículas estáveis e drive-terms de primeira ordem.

- Fiz uma primeira iteração no algorítmo, partindo do zero e ele conseguiu minimizar.
- Aumentei a amplitude das oscilações para cálculo dos tune-shifts e ele também otimizou. 
- Notei que a solução final da segunda iteração tinha tunes presos por ressonâncias, o que atrapalhou o cálculo do dnudJ.
- mudei o algorítmo que fita para considerar apenas pontos dentro de uma janela em torno do tune em amplitude zero.
- Iterei mais duas vezes, aumentando a amplitude usada no tracking e a ordem do fitting.
