# Anotações

## Transmitter

## QPSKTransmitter.m

### bitGenerator

Gera os bits para a mensagem que será transmitida.

### QPSKModulator (função normal da Communication Toolbox)

É a modulação escolhida pra essa transmissão. Provavelmente sem muito problema a gente vai poder mudar pra qualquer outra modulação alterando os parâmetros necessários.

### Método transmittedSignal

Como resultado tem o sinal a ser transmitido de verdade.

1. transmittedBin provavelmente são todos os bits gerados a serem transmitidos
2. modulatedData é o dado modulado pelo método pQPSKModulator dos trnasmittedBin (basicamente a modulação do que é pra ser enviado)
3. transmittedSignal recebe o resultado da passagem do filtro raised cossine no dado modulado
