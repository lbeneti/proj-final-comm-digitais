# Anotações

## Transmitter

### QPSKTransmitter.m

**bitGenerator**

Gera os bits para a mensagem que será transmitida.

**QPSKModulator (função normal da Communication Toolbox)**

É a modulação escolhida pra essa transmissão. Provavelmente sem muito problema a gente vai poder mudar pra qualquer outra modulação alterando os parâmetros necessários.

**Método transmittedSignal**

Como resultado tem o sinal a ser transmitido de verdade.

1. transmittedBin provavelmente são todos os bits gerados a serem transmitidos
2. modulatedData é o dado modulado pelo método pQPSKModulator dos trnasmittedBin (basicamente a modulação do que é pra ser enviado)
3. transmittedSignal recebe o resultado da passagem do filtro raised cossine no dado modulado

## Dúvidas

- a geração de bit varia de acordo com a modulação escolhida?
- como a modulação vai afetar como na transmissão

### TODOs

[ ] testar o que está sendo obtido no momento (antes de fazer qualquer alteração - pegar os valores de setup e obetidos como resultados para uma comparação futura)

[ ] mudar a modulação e ver o que muda em termos de erro (provavelmente seria só mudar para uma QAMModulation e adequar os parâmetros)

## Receiver

### TODOs

[ ] implementar corretor de erros (temos que ver no que isso vai impactar)
