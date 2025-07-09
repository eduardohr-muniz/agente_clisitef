# AgenteCliSiTef

## Especificação Técnica

##### Versão 1.0 9


```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 2 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
## Esclarecimentos

- O usuário deste documento é o responsável por garantir que está de posse da versão mais atualizada.
- Qualquer usuário pode utilizar essa cópia para sugerir alterações no documento.
- Todos os pedidos de alteração devem ser direcionados ao responsável pelo documento (ver coluna “Autor”
    do item “Histórico de Alterações” neste documento).
- Somente o responsável consolida os pedidos de alteração.
- Somente o responsável pode alterar o número da versão deste documento.
- A versão deste documento é composta por dois números, separados por um ponto. O número à esquerda
    do ponto é incrementado sempre que a alteração feita determine alguma mudança no Software (ou no
    conjunto de Software). O número à direita, por sua vez, é incrementado quando a alteração feita não
    determina mudanças no Software (ex.: detalhar alguma funcionalidade que já exista; efetuar correções,
    etc). O número da direita é zerado toda vez que o número da esquerda for incrementado. Os números à
    esquerda e direita do ponto podem crescer conforme a necessidade, porém sem utilizar zeros à esquerda.


## AgenteCliSiTef (versão 1.09)

_Este documento contém informações CONFIDENCIAIS e_ PROPRIETÁRIAS _da Software Express e não pode ser publicado ou distribuído sem a sua_

      - Copyright Software Express 3 de
- 1 Introdução Sumário
- 2 Objetivo
- 3 Público-Alvo
- 4 Visão Geral
- 5 Fluxo de Mensagens
- 6 Serviços disponíveis (API)
   - 6.1 Serviços para execução de uma transação simples
         - 6.1.1 clisitef/startTransaction
         - 6.1.2 clisitef/continueTransaction
         - 6.1.3 clisitef/finishTransaction
   - 6.2 Serviço para Gerenciamento de Sessão
         - 6.2.1 clisitef/session
   - 6.3 Serviços para operações com PinPad
         - 6.3.1 clisitef/pinpad/open
         - 6.3.2 clisitef/pinpad/close
         - 6.3.3 clisitef/pinpad/isPresent
         - 6.3.4 clisitef/pinpad/readYesNo
         - 6.3.5 clisitef/pinpad/setDisplayMessage
   - 6.4 Serviços gerais do AgenteCliSiTef
         - 6.4.1 clisitef/state
         - 6.4.2 clisitef/getVersion
- 7 Conteúdo do pacote AgenteCliSiTef
   - 7.1 Arquivos básicos
   - 7.2 Scripts para geração de certificados com openssl
   - 7.3 Exemplos
- 8 Instalação
   - 8.1 Rodando como um programa stand-alone
   - 8.2 Rodando como um Serviço (Windows)
- 9 Configuração
   - 9.1 Configuração da clisitef/pinpad
   - 9.2 Configuração do AgenteCliSiTef
- 10 Histórico de Alterações


```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 4 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
## 1 Introdução Sumário

Sistemas de automação utilizam a _CliSiTef_ para realização de transações TEF com seus autorizadores. A _CliSiTef_
provê interfaces tanto com o SiTef (concentrador TEF), quanto com _PinPads_.

Para um sistema de automação comercial típico, que possui um módulo executado no Terminal, temos a
seguinte topologia:

```
Figura 1 - Arquitetura de Solução TEF tradicional, utilizando CliSiTef ou Cliente SiTef
```
Como exemplos de Terminal, podemos ter PDVs (Microcomputadores em pontos de venda), Totens, _Tablets_ , e
demais hardwares que são utilizados na realização de vendas.

O conceito de Aplicação instalada no terminal evoluiu e, atualmente, inúmeras soluções de automação
comercial utilizam um paradigma “Web”, onde o módulo da automação no Terminal é um navegador de _internet_ ,
conectado a um servidor de aplicação (normalmente um servidor _web_ ).

Este documento irá propor formas de integração para que um navegador de internet, com uma aplicação web,
possa efetuar transações com cartão presencial ( _Chip&PIN_ ), através de um PinPad.

Arquitetura

## Terminal da

## Automação

## Comercial

## Servidor da Automação Comercial

## - CliSiTef

## - Cliente SiTef

```
PinPad
```
```
Software Express
```
```
Adquirente
```
```
Automação Comercial
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 5 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
## 2 Objetivo

Este documento tem a finalidade de apresentar a especificação de uma solução para a interface entre uma
automação, o concentrador de transações _SiTef_ e o _PinPad_ , chamada aqui de AgenteCliSiTef.

##### Este documento é um complemento da especificação da CliSiTef, chamada “SiTef -

##### Interface Simplificada com a aplicação”. Desta forma, não deve ser utilizado

##### separadamente.

## 3 Público-Alvo

As equipes de Desenvolvimento de automações comerciais Web que desejem realizar uma interface com os
_PinPads_ e com o SiTef.

## 4 Visão Geral

Quando a solução de pagamento requer o uso de um _PinPad_ para leitura de chip e senha, é importante ressaltar
que este dispositivo requer uma conexão serial/usb ao computador, bem como um software que seja dependente
da plataforma utilizada ( _Linux_ , _Windows_ , etc) para acessá-lo.

Anteriormente, a Software Express disponibilizava uma solução utilizando um _applet_ Java, que permitia interagir
com a aplicação através de _JavaScript_. Este _applet_ , por sua vez, utilizava a _CliSiTef_ para fazer o tratamento das
transações, através de uma tecnologia conhecida como _Java Native Interface (JNI)._

Com o tempo, a Sun/Oracle passou a exigir uma série de condições para viabilizar esta solução, até que os
navegadores optaram por abandonar o suporte para _applets_ Java.

Na proposta deste documento, uma alternativa é a instalação no Terminal de um serviço web (Serviço do
Windows ou _daemon_ no Linux).

```
Utilizaremos a denominação AgenteCliSiTef para este serviço web.
```
O **AgenteCliSiTef** nada mais **é** do que **um servidor Web** leve, **que atenderá requisições locais** , **originadas do
navegador de internet**.

Esta comunicação será feita através do protocolo HTTPS, utilizando serviços REST ( _Representational State
Transfer_ ).

O AgenteCliSiTef, então, recebe requisições em HTTPS, consome as funções CliSiTef, coleta a resposta e
responde à requisição HTTPS.

```
A arquitetura genérica é representada no diagrama a seguir.
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 6 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
```
Figura 2 - Arquitetura de Solução TEF "Web" utilizando o AgenteCliSiTef
```
O AgenteCliSiTef é capaz de iniciar um único fluxo de TEF por vez. Essa limitação se explica pela necessidade de
utilização do _PinPad_ conectado ao equipamento. Uma vez iniciado um fluxo, o AgenteCliSiTef responde “ocupado”
para todas as outras tentativas de requisição.

```
Considerações importantes:
```
**1 – O AgenteCliSiTef recebe apenas requisições locais (127.0.0.1 / localhost) provindas de uma página web
(aplicação cliente) carregada em um browser local.**

**2 – As chamadas às APIs do Agente CliSiTef devem ser realizadas pela página Web local (aplicação cliente) e
não pelo servidor da aplicação web (aplicação servidor).**

```
Terminal da
Automação
Comercial
```
Arquitetura

Servidor da Automação Comercial

```
PinPad
```
```
JavaScript(HTTPS/REST)
```
```
Software Express
Adquirente
```
```
Automação
```
```
Navegador
de internet
```

**_AgenteCliSiTef (versão 1.09)_**
_Copyright Software Express 7 de 27
Este documento contém informações CONFIDENCIAIS e_ PROPRIETÁRIAS _da Software Express e não pode ser publicado ou distribuído sem a sua_


```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 8 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
## 5 Fluxo de Mensagens

```
Uma transação é iniciada no consumo do serviço “ clisitef/startTransaction ”, conforme o protocolo estabelecido.
```
Caso o **_clisitefStatus_** retornado seja “ **10000** ” deve-se iniciar um fluxo de “ _clisitef/continueTransaction_ ” e
tratamento do comando até que o STATUS retornado seja diferente de “ **10000** ”.

Neste ponto, caso o **_clisitefStatus_** retornado seja “ **0** ”, a transação foi efetuada com sucesso e o processo pode
ser finalizado, consumindo-se o serviço “ _clisitef/finishTransaction_ ”. Essa finalização não é obrigatória, podendo ser
realizada posteriormente, consumindo-se o serviço “ _clisitef/finishTransaction_ ” passando os parâmetros de
endereço do servidor SiTef, Empresa e Terminal da transação original.

```
Figura 3 - Fluxo de Transação
```
```
Início
```
```
Consome
“clisitef/startTransaction”
```
```
clisitefStatus== 10000?
```
```
Consome
“clisitef/continueTransaction”
```
```
clisitefStatus== 10000? Executa comando solicitado
```
```
clisitefStatus== 0?
```
###### S

```
Consome
“clisitef/finishTransaction”
```
```
FIM
```
```
FIM
```
###### S

###### N

###### S

###### N

###### N


**_AgenteCliSiTef (versão 1.09)_**
_Copyright Software Express 9 de 27
Este documento contém informações CONFIDENCIAIS e_ PROPRIETÁRIAS _da Software Express e não pode ser publicado ou distribuído sem a sua_

```
Após o início do processo de uma transação, caso seja consumida o serviço
“ clisitef/finishTransaction ”, será retornado um erro indicando estado inválido.
O serviço de “ clisitef/startTransaction ” inicializa um novo ciclo de transação, independente
do estado do ciclo corrente.
```
```
Figura 4 - Diagrama de Sequência da troca de mensagens em um ciclo de transação TEF.
```
##### WebApp AgenteCliSiTef CliSiTef

```
1.1 -ConfiguraIntSiTefInterativo() : int
```
```
1: startTransaction
```
```
1.2 -IniciaFuncaoIntSiTefInterativo() : int
```
```
2: continueTransaction
2.1 -ContinuaFuncaoSiTefInterativo() : int
```
```
3 : continueTransaction
3.1 -ContinuaFuncaoSiTefInterativo() : int
```
```
4: finishTransaction
4.1 -FinalizaFuncaoSiTefInterativo() : int
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 10 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
## 6 Serviços disponíveis (API)

O AgenteCliSiTef propõe uma interface _HTTPS/REST_ para o consumo das funções interativas da _CliSiTef_. Para
tanto provê os serviços abaixo. Os serviços são consumidos, passando-se elementos como parâmetros do
formulário.

```
A resposta é enviada como um objeto serializado ( JSON ), contendo os atributos e valores pertinentes ao serviço.
```
### 6.1 Serviços para execução de uma transação simples

```
Para executar uma transação simples, serão utilizados três serviços:
```
```
1) startTransaction – Iniciar uma transação.
2) continueTransaction – Continuar uma transação.
3) finishTransaction – Confirmar (ou não) uma transação.
```
##### 6.1.1 clisitef/startTransaction

```
Inicia uma transação com a clisitef.
```
```
URL: https://127.0.0.1/agente/clisitef/startTransaction
Método HTTP: POST
```
```
Parâmetros de entrada Descrição
sitefIp Configura o nome ou endereço IP (em notação “.”) do servidor SiTef.
storeId Identifica o número da loja perante a rede de estabelecimentos comerciais.
terminalId Identifica o pdv perante a loja. Possui o formato XXnnnnnn onde XX corresponde a 2
caracteres alfabéticos e nnnnnn 6 dígitos quaisquer desde que o número resultante
não sobreponha a faixa 000900 a 000999 que é reservada para uso pelo SiTef.
functionId Seleciona a forma de pagamento, conforme a tabela “Códigos de Funções” presente
na especificação da CliSiTef.
trnAmount Contém o valor a ser pago contendo o separador decimal (“,”). Deve sempre ser
passado com duas casas decimais após a vírgula (“,”). Caso a operação não tenha um
valor definido a priori (p/ex. recarga de pré-pago), esse campo deve vir vazio.
taxInvoiceNumber Número do Cupom Fiscal correspondente à venda
taxInvoiceDate Data fiscal no formato AAAAMMDD
taxInvoiceTime Hora fiscal no formato HHMMSS
cashierOperator Identificação do operador de caixa
trnAdditionalParameters Parâmetros adicionais. Permite que o aplicativo limite o tipo de meio de pagamento.
Ele é opcional e pode ser passado vazio (“”). Quando esse campo for utilizado a
CliSiTef irá limitar os menus de navegação apenas aos códigos não presentes na lista.
trnInitParameters Parâmetros adicionais para a configuração da CliSiTef (função
ConfiguraIntSiTefInterativo )
Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, só é enviado o atributo “ serviceMessage ” após este.
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 11 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
```
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
clisitefStatus Contém o resultado de resposta à chamada da rotina IniciaFuncaoSiTefInterativo.
Caso seja retornado o valor 10000 , deve-se proceder à chamada do serviço
clisitef/continueTransaction (veja a seguir).
sessionId Chave de Sessão utilizada para identificar essa sessão com o AgenteCliSiTef. Este
código deve ser enviado em todas as chamadas de serviços subsequentes.
```
```
Exemplo de requisição JavaScript (usando JQuery):
```
$.ajax({
url: "https://127.0.0.1/agente/clisitef/startTransaction",
type: "post",
data:
**"sitefIp** =1 27. 0. 0. 1 & **storeId** =00000000& **terminalId** =REST0001& **functionId** =3& **trnAmount** =100& **ta
xInvoiceNumber** =1234& **taxInvoiceDate** =20170304& **taxInvoiceTime** =170000& **cashierOperator** =CAI
XA& **trnAdditionalParameters** = **"**

});

```
Exemplo de retorno:
```
```
{"serviceStatus": 0, "clisitefStatus": 10000, "sessionId": "45dd5cd"}
```
```
Para pagamentos múltiplos, repita nas demais solicitações de transação os valores de controle
fiscal (taxInvoiceNumber, taxInvoiceDate, taxInvoiceTime), ao final de todos os pagamentos ou
em caso de erro confirme ou cancele todos os pagamentos pela chamada da função
finishTransaction utilizando esse trio de informações como chave (taxInvoiceNumber,
taxInvoiceDate, taxInvoiceTime)
```
```
Exemplo Pagamento Múltiplo com 3 Cartões diferentes totalizando 750,
```
```
função observação trnAmount taxInvoiceNumber taxInvoiceDate taxInvoiceTime
```
```
startTransaction
```
```
Pagamento
1
```
```
500 , 00
```
```
123456
20190722
113500
```
```
Pagamento
2
```
```
100 , 00
```
```
Pagamento
3
```
```
150 , 00
```
```
finishTransaction Referente
aos 3
pagamentos
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 12 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
##### 6.1.2 clisitef/continueTransaction

```
Continua o processo iterativo da clisitef.
```
```
URL: https://127.0.0.1/agente/clisitef/continueTransaction
Método HTTP: POST
```
```
Parâmetros de entrada Descrição
sessionId Código de sessão recebido no serviço “ clisitef/startTransaction ”
data Dados coletados pela aplicação, a serem passados para a CliSiTef. Se automação não
estiver enviando dados para a CliSiTef (ou for a primeira chamada do serviço), deve
passar esse campo vazio (“”).
continue Código para a continuidade da transação, de acordo com a automação comercial.
0 → Prossegue com a transação normalmente.
1 → Retorna, se possível, à coleta ao campo anterior
2 → Cancela o pagamento de conta atual, mantendo os anteriores em memória,
caso existam, permitindo que tais pagamentos sejam enviados para o SiTef e até
mesmo permite incluir novos pagamentos. Retorno válido apenas nas coletas de
valores e data de vencimento de um pagamento de contas.
```
- 1 → Encerra a transação
Na resposta temos um objeto composto dos atributos:

```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, não serão enviados os demais atributos.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
sessionId Código de Sessão utilizado para identificar essa sessão com o AgenteCliSiTef. Este
código deve ser enviado em todos os “continua” subsequentes.
clisitefStatus Contém o resultado de resposta à chamada da rotina ContinuaFuncaoSiTefInterativo.
data Dados de retorno da CliSiTef.
commandId Código do comando de coleta.
0 → caso a CliSiTef esteja devolvendo algum dado referente a transação no campo
Buffer
<> 0 → indica o Próximo Comando a ser executado pelo aplicativo. Os comando
válidos estão descritos em Tabela de códigos de Comando da Especificação técnica da
CliSiTef.
fieldId Contém o código do tipo de campo que a automação deve tratar. Os tipos existentes
estão descritos em Tabela de valores para TipoCampo (ver especificação técnica da
CliSiTef).
fieldMinLength
fieldMaxLength
```
```
Quando o Comando for uma coleta de dados, contém o tamanho Mínimo e Máximo
do campo a ser lido
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 13 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
##### 6.1.3 clisitef/finishTransaction

Confirma ou não-confirma a transação na clisitef. Este serviço comporta-se de duas maneiras diferentes, de
acordo com o estado do agente e se ele está sendo utilizado no modo com ou sem sessão.

```
Finaliza durante um fluxo de transação no modo sem sessão OU fora do fluxo no modo com sessão
```
```
URL: https://127.0.0.1/agente/clisitef/finishTransaction
Método HTTP: POST
Neste caso, o serviço “agente/finaliza” deve receber os parâmetros:
```
```
Parâmetros de entrada Descrição
sessionId Código de sessão coletado no serviço “ clisitef/startTransaction ”
taxInvoiceNumber Número do Cupom Fiscal correspondente à venda
taxInvoiceDate Data Fiscal no formato AAAAMMDD
taxInvoiceTime Horário Fiscal no formato HHMMSS
confirm Indica se a transação deve ser confirmada (1) ou estornada (0)
Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, não serão enviados os demais atributos.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
clisitefStatus Contém o resultado de resposta à chamada da rotina.
```
```
Finaliza fora de um fluxo de transação no modo sem sessão
```
```
URL: https://127.0.0.1/agente/clisitef/finishTransaction
Método HTTP: POST
Neste caso, o serviço “agente/finaliza” deve receber os parâmetros:
```
```
Parâmetros de entrada Descrição
sitefIp Configura o nome ou endereço IP (em notação “.”) do servidor SiTef.
storeId Identifica o número da loja perante a rede de estabelecimentos comerciais.
terminalId Identifica o PDV perante a loja. Possui o formato XXnnnnnn onde XX corresponde a 2
caracteres alfabéticos e nnnnnn 6 dígitos quaisquer desde que o número resultante
não sobreponha a faixa 000900 a 000999 que é reservada para uso pelo SiTef.
taxInvoiceNumber Número do Cupom Fiscal correspondente à venda
taxInvoiceDate Data Fiscal no formato AAAAMMDD
taxInvoiceTime Horário Fiscal no formato HHMMSS
confirm Indica se a transação deve ser confirmada (1) ou estornada (0)
Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, não serão enviados os demais atributos.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
clisitefStatus Contém o resultado de resposta à chamada da rotina.
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 14 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
```
Para pagamentos múltiplos, na chamada da finishTransaction, deve ser fornecido os mesmos
valores de controle fiscal (taxInvoiceNumber, taxInvoiceDate, taxInvoiceTime) utilizados nas
transações de pagamento múltiplo e todas as relacionadas serão processadas conforme
orientação de confirmar ou cancelar.
```
```
Exemplo Pagamento Múltiplo com 3 Cartões diferentes totalizando 750,
```
```
função observação trnAmount taxInvoiceNumber taxInvoiceDate taxInvoiceTime
```
```
startTransaction
```
```
Pagamento
1
```
```
500 , 00
```
```
123456
20190722
113500
```
```
Pagamento
2
```
```
100 , 00
```
```
Pagamento
3
```
```
150 , 00
```
```
finishTransaction Referente
ao
Pagamento
1, 2 e 3.
```
### 6.2 Serviço para Gerenciamento de Sessão

Uma chave de sessão atua como controle de sessão entre as diversas chamadas da aplicação web com o
AgenteCliSiTef. Ela também representa uma conexão com a CliSiTef, nos moldes da _ConfiguraIntSiTefInterativoEx_.

A chave de sessão deve ser utilizada em cada chamada a um serviço do AgenteCliSiTef, para indicar a
consistência da conexão com a aplicação web. Por exemplo, se o navegador perder a conexão, ou ocorrer um
_refresh_ de páginas, onde o estado da transação é perdido, é possível gerenciar esta situação através do serviço a
seguir.

##### 6.2.1 clisitef/session

Este serviço permite criar uma sessão com o AgenteCliSiTef, consultar uma sessão ativa, ou descartar uma sessão
ativa, de acordo com o método HTTP usado.

```
Criação de uma sessão
```
```
URL: https://127.0.0.1/agente/clisitef/session
Método HTTP: POST
```
```
Parâmetros de entrada Descrição
sitefIp Configura o nome ou endereço IP (em notação “.”) do servidor SiTef.
storeId Identifica o número da loja perante a rede de estabelecimentos comerciais.
terminalId Identifica o PDV perante a loja. Possui o formato XXnnnnnn onde XX corresponde a 2
caracteres alfabéticos e nnnnnn 6 dígitos quaisquer desde que o número resultante
não sobreponha a faixa 000900 a 000999 que é reservada para uso pelo SiTef.
sessionParameters Parâmetros adicionais para a configuração da CliSiTef.
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 15 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
```
Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, só é enviado o atributo “ serviceMessage ” após este.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
clisitefStatus Contém o resultado de resposta à chamada da rotina ConfiguraIntSiTefInterativoEx.
sessionId Chave de Sessão utilizada para identificar essa sessão com o AgenteCliSiTef. Este
código deve ser enviado em todas as chamadas de serviços subsequentes.
```
**Observação** : caso a aplicação web deseje integrar a chave de sessão na transação de venda, basta passar o
atributo **_sessionId_** no serviço “ _clisitef/startTransaction_ ”, no lugar dos atributos **_sitefIp_** , **_storeId_** e **_terminalId_**. Note
que serão usados os parâmetros de empresa/terminal da sessão criada.

```
Na transação assim iniciada, a chave de sessão será preservada ao final da transação.
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 16 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
```
Consulta de uma sessão ativa
```
Este serviço permite obter o **_sessionId_** da sessão atual, caso exista. Pode ser usado nos casos em que o
navegador, por alguma razão, perder o sincronismo com o AgenteCliSiTef.

```
URL: https://127.0.0.1/agente/clisitef/session
Método HTTP: GET
Este método não requer quaisquer parâmetros. Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, só é enviado o atributo “ serviceMessage ” após este.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
serviceState Contém o estado do AgenteCliSiTef.
sessionId Chave de Sessão utilizada para identificar essa sessão com o AgenteCliSiTef. Este
código deve ser enviado em todas as chamadas de serviços subsequentes.
Exemplo de retorno:
```
```
{"serviceStatus": 0, "serviceState": 1, "sessionId": "d662632"}
```
```
Descartando uma sessão
```
```
URL: https://127.0.0.1/agente/clisitef/session
Método HTTP: DELETE
Após a chamada deste método, a CliSiTef é descarregada dinamicamente, e a chave de sessão atual é invalidada.
```
```
Este método não requer quaisquer parâmetros. Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, só é enviado o atributo “ serviceMessage ” após este.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
clisitefStatus Sempre zero.
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 17 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
### 6.3 Serviços para operações com PinPad

```
Atenção: a configuração do PinPad deve seguir a documentação da CliSiTef, e deve ser feita previamente.
```
##### 6.3.1 clisitef/pinpad/open

```
Este serviço abre a comunicação com o PinPad, e é equivalente à função AbrePinPad da CliSiTef.
```
```
URL: https://127.0.0.1/agente/clisitef/pinpad/open
Método HTTP: POST
```
```
Parâmetros de entrada Descrição
sessionId Código de sessão criado previamente no serviço “ clisitef/session ”
Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, só é enviado o atributo “ serviceMessage ” após este.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
clisitefStatus Contém o resultado de resposta à chamada da rotina AbrePinPad.
```
##### 6.3.2 clisitef/pinpad/close

```
Este serviço fecha a comunicação com o PinPad, e é equivalente à função FechaPinPad da CliSiTef.
```
```
URL: https://127.0.0.1/agente/clisitef/pinpad/close
Método HTTP: POST
```
```
Parâmetros de entrada Descrição
sessionId Código de sessão criado previamente no serviço “ clisitef/session ”
Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, só é enviado o atributo “ serviceMessage ” após este.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
clisitefStatus Contém o resultado de resposta à chamada da rotina FechaPinPad.
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 18 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
##### 6.3.3 clisitef/pinpad/isPresent

```
Este serviço verifica a presença do PinPad, e é equivalente à função VerificaPresencaPinPad da CliSiTef.
```
```
URL: https://127.0.0.1/agente/clisitef/pinpad/isPresent
Método HTTP: POST
```
```
Atributos de entrada Descrição
sessionId Código de sessão criado previamente no serviço “ clisitef/session ”
Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, só é enviado o atributo “ serviceMessage ” após este.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
clisitefStatus Contém o resultado de resposta à chamada da rotina VerificaPresencaPinPad.
```
##### 6.3.4 clisitef/pinpad/readYesNo

```
Este serviço obtém o pressionar da tecla Sim/Entra/Verde ou Não/Anula/Vermelha no PinPad.
```
```
Este serviço é equivalente à função LeSimNaoPinPad da CliSiTef.
```
```
URL: https://127.0.0.1/agente/clisitef/pinpad/readYesNo
Método HTTP: POST
```
```
Parâmetros de entrada Descrição
sessionId Código de sessão criado previamente no serviço “ clisitef/session ”
displayMessage Mensagem a ser exibida no PinPad.
Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, só é enviado o atributo “ serviceMessage ” após este.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
clisitefStatus Contém o resultado de resposta à chamada da rotina LeSimNaoPinPad.
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 19 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
##### 6.3.5 clisitef/pinpad/setDisplayMessage

Este serviço exibe uma mensagem no visor do PinPad, e é equivalente à função
_EscreveMensagemPinPad/EscreveMensagemPermanetePinPad_ da CliSiTef.

```
URL: https://127.0.0.1/agente/clisitef/pinpad/setDisplayMessage
Método HTTP: POST
```
```
Parâmetros de entrada Descrição
sessionId Código de sessão criado previamente no serviço “ clisitef/session ”
displayMessage Mensagem a ser exibida no PinPad.
persistent Opcional. Se for indicado o valor diferente de “ N ”^1 , será usada a função
EscreveMensagemPermanentePinPad. Do contrário, será chamada a função
EscreveMensagemPinPad
Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, só é enviado o atributo “ serviceMessage ” após este.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
clisitefStatus Contém o resultado de resposta à chamada da rotina EscreveMensagemPinPad/
EscreveMensagemPermanentePinPad.
```
(^1) Para facilitar internacionalização, permitindo tratar valores “Y” ou “S”


```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 20 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
### 6.4 Serviços gerais do AgenteCliSiTef

##### 6.4.1 clisitef/state

```
Obtém o estado do AgenteCliSiTef.
```
```
URL: https://127.0.0.1/agente/clisitef/state
Método HTTP: GET
Este serviço não requer quaisquer parâmetros.
```
```
Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, não serão enviados os demais atributos.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
serviceState Estado do AgenteCliSiTef:
0 – Agente não inicializado.
1 – Agente pronto para receber uma solicitação de transação.
2 – IniciaFuncaoSiTefInterativo iniciado com sucesso; aguardando chamada
clisitef/continueTransaction.
3 – processo iterativo da CliSiTef em andamento; aguardando chamada
clisitef/continueTransaction.
4 – aguardando clisitef/finishTransaction.
serviceVersion Versão do AgenteCliSiTef.
sessionId Chave de sessão atualmente ativa, caso exista.
```
```
Exemplo de retorno:
```
```
{"serviceStatus": 0, "serviceState": 1, "serviceVersion": "1.0.0.2.b1"}
```
##### 6.4.2 clisitef/getVersion

```
Obtém as versões das bibliotecas clisitef/clisitefi, e é equivalente à função ObtemVersao da CliSiTef.
```
**URL:** https://127.0.0.1/agente/clisitef/getVersion
**Método HTTP:** POST
Este serviço não requer quaisquer parâmetros, porém é necessário que exista uma sessão ativa no
AgenteCliSiTef.

```
Na resposta temos um objeto composto dos atributos:
```
```
Atributos retornados Descrição
serviceStatus Estados de consumo do serviço. 0 – OK e 1 – Não OK. No caso de retorno com valor
1, não serão enviados os demais atributos.
serviceMessage Mensagem de erro, caso “ serviceStatus ” igual a 1.
clisitefStatus Contém o resultado de resposta à chamada da rotina ObtemVersao.
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 21 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
clisitefVersion Versão da biblioteca CliSiTef.
clisitefiVersion Versão da biblioteca CliSiTefI.
sessionId Chave de sessão atualmente ativa.
serviceVersion Versão do AgenteCliSiTef.


```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 22 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
## 7 Conteúdo do pacote AgenteCliSiTef

```
Neste capítulo descreveremos o conteúdo do pacote AgenteCliSiTef.
```
### 7.1 Arquivos básicos

A pasta _bin_ contém, além dos binários essenciais para a execução do AgenteCliSiTef, arquivos de configuração e
certificados de testes para estabelecimento de uma conexão HTTPS.

Certifique-se de usar a última versão da biblioteca CliSiTef, bem como validar a configuração do arquivo
clisitef.ini.

### 7.2 Scripts para geração de certificados com openssl

A pasta _helper_ contém um script que faz chamadas ao _openssl_ , de modo a gerar os arquivos necessários para a
configuração do _https_.

```
Os arquivos necessários para a configuração tem a mesma equivalência do Apache.
```
```
A pasta helper é meramente ilustrativa, e não deve ser instalada em ambiente de produção.
```
### 7.3 Exemplos

```
O pacote AgenteCliSiTef é acompanhado com exemplos de utilização, localizados na pasta html.
```
```
A tabela abaixo descreve os arquivos de exemplo.
```
```
Arquivo Descrição
index.html Exemplo básico de transação
sessao.html Arquivo contendo exemplos de chamadas usando o conceito de “sessão”
venda_com_sessao.html Exemplo de venda, aplicando o conceito de “sessão”
agenteCliSiTef.js Rotinas em JavaScript, que fazem chamadas HTTPS/REST ao web service local através
de AJAX/JQuery.
Rotinas modificáveis pela automação comercial.
jquery-3.2.1.min.js Biblioteca JQuery usada pelo agenteCliSiTef.js
style.css Arquivo de estilos usado nas páginas html.
```
```
Note que estes arquivos são meramente ilustrativos, e sua instalação local não é obrigatória.
```
```
Isto é, arquivos equivalentes podem ficar hospedados no servidor web de preferência da automação comercial.
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 23 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
## 8 Instalação

```
O AgenteCliSiTef.exe pode operar como um programa stand-alone , ou como um serviço (no caso do Windows).
```
### 8.1 Rodando como um programa stand-alone

Para iniciar o AgenteCliSiTef, basta executá-lo pela linha de comando, certificando-se que o arquivo de
configuração agenteclisitef.ini esteja na mesma pasta do AgenteCliSiTef.

```
Certifique-se também que o arquivo clisitef.ini esteja devidamente configurado.
```
```
C:\www\bin>agenteCliSiTef.exe
[06/10/2017:15:48:40] - HTTP-SRV - pid: 5132; AgenteCliSiTef - Versao = [v.1.0.0.0]
[06/10/2017:15:48:40] - HTTP-SRV - pid: 5132; AgenteCliSiTef - Compilacao = [r1]
[06/10/2017:15:48:40] - HTTP-SRV - pid: 5132; AgenteCliSiTef - Plataforma = [Win32]
[06/10/2017:15:48:40] - HTTP-SRV - pid: 5132; Biblioteca Http inicializada - Versao: 1.22
[06/10/2017:15:48:40] - HTTP-SRV - pid: 5132; Servidor Http em operacao - IP: 0.0.0.0 - Porta: 443
```
```
As versões Linux são análogas.
```
### 8.2 Rodando como um Serviço (Windows)

```
Para instalar o AgenteCliSiTef.exe:
```
```
a) Abra uma console de comando, e rode, no diretório do AgenteCliSitef.exe, o comando:
```
```
AgenteCliSiTef.exe /i
```
```
b) Uma mensagem deverá aparecer.
```
```
Servico AgenteCliSiTef instalado.
```
```
c) Cheque o arquivo de configuração agenteclisitef.ini (veja adiante) e o arquivo clisitef.ini
d) Inicie o serviço.
```
```
Para remover o serviço:
```
```
a) Certifique-se que o serviço AgenteCliSiTef esteja parado.
b) Na linha de comando, vá ao diretório onde se encontra o AgenteCliSiTef.exe (em caso de dúvidas, verifique
o caminho nas propriedades do serviço, na pasta de Serviços do Windows), e rode o comando:
```
## AgenteCliSiTef.exe /u

```
c) Uma mensagem deverá aparecer.
```
```
Servico AgenteCliSiTef removido.
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 24 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
## 9 Configuração

### 9.1 Configuração da clisitef/pinpad

A biblioteca **CliSiTef** (e a conexão com o PinPad) é configurada à parte, de acordo com sua documentação
própria. Nesta versão do documento, é feita através do arquivo **clisitef.ini**.

Certifique-se que a biblioteca **CliSiTef** utilizada pelo **AgenteCliSiTef** é compatível com o **servidor SiTef**. Existem
versões específicas para trabalhar com o SiTef Simulado e com o SiTef de produção.

### 9.2 Configuração do AgenteCliSiTef

Configura-se o AgenteCliSiTef utilizando o arquivo agenteclisitef.ini^2. A sessão de configuração é a “[HTTP-
SERVER]”.

```
Nesta sessão, as possibilidades de configuração são:
```
```
Nome: AcessLog
Tipo: alfanumérico
Opcional: Sim
Valor padrão: ../logs/access-<YYYY/><MM/><DD/>.log
Descrição: caminho para o arquivo de saída padrão.
```
```
Nome: clisitefi
Tipo: alfanumérico
Opcional: Sim
Valor padrão: clisitefi na mesma pasta do agenteCliSiTef.
Descrição: caminho da biblioteca clisitefi; o arquivo clisitef.ini deve estar na mesma pasta desta biblioteca.
```
```
Nome: Debug
Tipo: numérico
Opcional: Sim
Valor padrão: 0
Descrição: 1, se desejar que as mensagens de log sejam enviadas também para a console.
As mensagens continuam sendo enviadas para arquivos de acesso/erro.
```
```
Nome: DocumentRoot
Tipo: alfanumérico
Opcional: Sim
Valor padrão: ../www
Descrição: diretório onde páginas HTML podem ser servidas pelo agenteCliSiTef.
Esta configuração é opcional, e as páginas podem ficar hospedadas no servidor web de
preferência da automação comercial, dando maior flexibilidade para mudanças.
```
(^2) Todas as letras do nome de arquivo minúsculas.


```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 25 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
**Nome: ErrorLog
Tipo:** alfanumérico
**Opcional:** Sim
**Valor padrão:** ../logs/error-<YYYY/><MM/><DD/>.log
**Descrição:** caminho para o arquivo de erros padrão.

**Nome: Port
Tipo:** numérico
**Opcional:** Sim
**Valor padrão:** 443
**Descrição:** porta do servidor HTTPS AgenteCliSiTef

**Nome: SSLCertificateFile
Tipo:** alfanumérico
**Opcional:** Não
**Valor padrão:
Descrição:** caminho para o arquivo com o certificado SSL.

**Nome: SSLCertificateKeyfile
Tipo:** alfanumérico
**Opcional:** Não
**Valor padrão:
Descrição:** caminho para o arquivo com a chave SSL.

**Nome: SSLDHParameters
Tipo:** alfanumérico
**Opcional:** Não
**Valor padrão:
Descrição:** caminho para o arquivo com os parâmetros para tratamento dos certificados.

**Nome: Timeout
Tipo:** numérico
**Opcional:** Sim
**Valor padrão:** 2
**Descrição:** Tempo, em segundos, de aguardo da resposta (após o estabelecimento da conexão)

```
Exemplo de arquivo de configuração:
```
```
[HTTP-SERVER]
Port=443
DocumentRoot=C:\www\html
clisitefi=C:\www\bin\CliSiTef32I.dll
```

**_AgenteCliSiTef (versão 1.09)_**
_Copyright Software Express 26 de 27
Este documento contém informações CONFIDENCIAIS e_ PROPRIETÁRIAS _da Software Express e não pode ser publicado ou distribuído sem a sua_

```
SSLCertificateFile=server_cert.pem
SSLCertificateKeyfile=server_key.pem
SSLDHParameters=dhparam.pem
```
```
AcessLog=C:\www\logs\access-<YYYY/><MM/><DD/>.log
ErrorLog=C:\www\logs\error-<YYYY/><MM/><DD/>.log
Debug=1
```

```
AgenteCliSiTef (versão 1.09)
Copyright Software Express 27 de 27
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua
```
## 10 Histórico de Alterações

```
Data Autor Versão Agente Descrição
```
```
28/09/ 2017
```
```
Artur
Carneiro
```
```
1.0 0 Versão Inicial.
```
###### 06/10/2017

```
Alexandre
Hamada
```
1.01 (^) Instalação e configuração de serviço (Windows).

###### 27/10/2017

```
Alexandre
Hamada
```
```
1.02 Atualização dos nomes dos serviços.
```
###### 06/11/2017

```
Alexandre
Hamada
```
```
1.03 Atualização do exemplo de requisição, usando JavaScript.
```
###### 22/11/2017

```
Alexandre
Hamada
```
###### 1.04

```
Acrescentada observação sobre configuração da clisitef e
pinpad.
Descrição dos arquivos de exemplos.
```
```
12/06/2018 Danilo F.
Camargo
```
```
1.05 Incluído campo (trnInitParameters)^ para ser passado como
parâmetro adicional do Configura
```
```
06/07/2018
```
```
Ricardo
Marin
```
```
1.06 Removida Marca D ́água.
```
```
09/04/2019 Leo Ueda 1.07 1.0.0.6.r1
```
```
Correção na descrição do finishTransaction (incluindo a
chamada no modo com sessão fora do fluxo).
```
```
22/07/2019
```
```
Ana
Londino
```
```
1.08 Adicionando informações na startTransaction e
finishTransaction para pagamento múltiplo.
```
```
13/11/2023 Daniel Jun 1.09
```
```
Inclusão de considerações finais no item 4 para deixar
claro que as requisições às APIs do Agente CliSiTef devem
ser realizadas pela página web (aplicação cliente) e não
pelo servidor da aplicação web (aplicação servidor).
```

