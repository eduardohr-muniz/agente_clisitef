# Especificação Técnica

## Bibliotecas CliSiTefI e CliSiTef

## Versão 253


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_2_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

## Esclarecimentos

- O usuário deste documento é o responsável por garantir que está de posse da versão mais
    atualizada.
- Qualquer usuário pode utilizar essa cópia para sugerir alterações no documento.
- Todos os pedidos de alteração devem ser direcionados ao responsável pelo documento (ver
    coluna “Autor” do item “Histórico de Alterações” neste documento).
- Somente o responsável consolida os pedidos de alteração.
- Somente o responsável pode alterar o número da versão deste documento.
- As imagens dos ícones nas caixas de texto estão sob a licença presente em:
    _[http://wiki.docbook.org/DocBookLicense](http://wiki.docbook.org/DocBookLicense)_


## SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )

Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,



   - Copyright Software Express 3 de
- 1 Introdução Sumário
- 2 Público-Alvo
- 3 Objetivos
- 4 Apresentação
      - 4.1 Funcionamento básico
- 5 API - Rotinas disponíveis na CliSiTef
      - 5.1 Configuração da biblioteca
         - 5.1.1 Configurações especiais gerais
         - 5.1.2 Informações adicionais da Automação/Estabelecimento
         - 5.1.3 Ponto flutuante
      - 5.2 Início da transação de Pagamento ou Gerencial.........................................................................................
         - 5.2.1 Tabela de códigos de retorno
         - 5.2.2 Tabela de códigos de funções
         - 5.2.3 Parâmetros Adicionais
      - 5.3 Continuação do processo de coleta iterativo
         - 5.3.1 Tabela de códigos de Comando
         - 5.3.2 Tabela de valores para TipoCampo...................................................................................................
         - 5.3.3 Tabela de Eventos, retornados também em TipoCampo
      - 5.4 Confirmação ou não do Pagamento
         - 5.4.1 Finalização de pagamentos individuais em um mesmo cupom fiscal
         - 5.4.2 Finalização de pagamentos de uma determinada rede em um mesmo cupom fiscal
         - 5.4.3 Anexar dados referentes às formas de pagamento de uma transação (NFPAG)
      - 5.5 Consulta de transações pendentes de confirmação no terminal
         - 5.5.1 Quantidade de transações pendentes de confirmação no terminal
         - 5.5.2 Consulta a transações pendentes no terminal
         - 5.5.3 Consulta a transações pendentes em um documento fiscal específico
      - 5.6 Funções de PinPad
         - 5.6.1 Teste da presença de PinPad
         - 5.6.2 Define mensagem permanente para o PinPad
         - 5.6.3 Leitura da trilha 3 do cartão
         - 5.6.4 Leitura do cartão - rotinas de captura segura
         - 5.6.5 Leitura de senha
         - 5.6.6 Leitura de Confirmação pelo Cliente no PinPad
         - 5.6.7 Define uma mensagem momentânea para o PinPad
   - Copyright Software Express 4 de SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
         - 5.6.8 Leitura de teclas especiais do PinPad Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
         - 5.6.9 Remover cartão inserido no PinPad
      - 5.7 Correspondente Bancário (Pagamento de Contas)
      - 5.8 Verificação da integridade de um código em barras
      - 5.9 Obtendo Versão
      - 5.10 Enviando mensagens pendentes
      - 5.11 Informações do PinPad
      - 5.12 Carga de Tabelas no PinPad
         - 5.12.1 Com alteração na Automação...........................................................................................................
         - 5.12.2 Sem alteração na Automação
      - 5.13 Tratamento para Múltiplos Pagamentos
      - 5.14 TEF (Crédito ou Débito) para Pagamento de Carnê
- 6 Arquivo de configurações CliSiTef.ini ou CLSIT
      - 6.14 Configuração do PinPad
         - 6.14.1 Configuração da porta
         - 6.14.2 Configuração quando a Automação não utilizar pinpad
         - 6.14.3 Configuração de um segundo pinpad
         - 6.14.4 Definição da mensagem padrão
         - 6.14.5 Habilitando confirmação do valor no pinpad
      - 6.15 Configuração de conexão com o servidor SiTef
         - 6.15.1 Configuração de endereços IP adicionais
         - 6.15.2 Configuração da porta do servidor SiTef
         - 6.15.3 Obrigatoriedade de conexão
         - 6.15.4 Mantendo conexão ativa
         - 6.15.5 Configuração do mostrador de comunicação
         - 6.15.6 Alterando parâmetros de temporizações (timeout)
      - 6.16 Como passar um novo valor da compra da transação na CliSiTef
      - 6.17 Habilitando/desabilitando formas de pagamento
         - 6.17.1 Restringindo formas de pagamento em tempo de execução...........................................................
         - 6.17.2 Definindo valores padrão para formas de pagamento
         - 6.17.3 Habilitação de transações adicionais
         - 6.17.4 Desabilitando transações
      - 6.18 Habilitação de transações de redes específicas
      - 6.19 Tabela de códigos de meios de pagamento, configurações e menus
      - 6.20 Habilitação de configurações especiais por transação
   - Copyright Software Express 5 de SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
      - 6.21 Transações crédito/débito com cartão sem BIN Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
      - 6.22 Habilitação de crédito parcelado quando em um pagamento vinculado
- 7 Arquivos de controle
- 8 Trace
      - 8.14 Configurando histórico
      - 8.15 Configuração de diretório
      - 8.16 Arquivos de trace por terminal
      - 8.17 Trace Rotativo
         - 8.17.1 Habilitando o trace rotativo
         - 8.17.2 Limitando o tamanho dos arquivos
         - 8.17.3 Enviando arquivos de trace para o servidor SiTef
- 9 Processo de desenvolvimento/homologação
      - 9.14 Arquivo de trace adicional durante a fase de desenvolvimento
      - 9.15 Processo de homologação
- 10 Tradução de mensagens
- 11 Tabelas
      - 11.14 Código das Redes Autorizadoras
      - 11.15 Código da Bandeira
- 12 Plataformas suportadas
- 13 Rotinas descontinuadas
- 14 Histórico de Alterações


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 6 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
## 1 Introdução Sumário

As bibliotecas **CliSiTefI** e **CliSiTef** oferecem aos desenvolvedores de automações comerciais um conjunto de
rotinas (API ́s) para integração com o servidor SiTef.

O servidor SiTef, por sua vez, oferece um amplo leque de serviços de pagamentos com os mais diversos
autorizadores.

As bibliotecas **CliSiTefI** e **CliSiTef** estão disponíveis para uma série de plataformas, normalmente sob a forma de
bibliotecas dinâmicas.

Ela possui pontos de entrada pelos quais a automação comercial a configura, solicita um pagamento, solicita
uma função gerencial ou o pagamento de uma conta.

```
Os pontos de entrada estão na CliSiTefI e é essa que deve ser carregada pela aplicação do usuário.
```
A **CliSiTef** é de uso exclusivo da **CliSiTefI** e não pode ser carregada ou chamada diretamente sob risco de,
eventualmente, desestabilizar o ambiente. Neste documento, qualquer referência a **CliSiTef** deve ser entendida
como o conjunto destas duas bibliotecas.

## 2 Público-Alvo

```
Desenvolvedores de automação comercial com CliSiTef.
```
## 3 Objetivos

Apresentar a descrição da biblioteca que efetua a interface com os serviços de meio de pagamento disponíveis
no SiTef.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 7 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
## 4 Apresentação

A CliSiTef propicia um meio rápido e simples de disponibilizar as funcionalidades do SiTef para aplicativos em
geral. Suas principais características são:

- Não intrusiva pois é a própria automação que gerencia suas telas. Não ocorre sobreposição de telas da
    própria interface que, se existisse, na maioria das vezes não seria compatível com a diagramação visual da
    aplicação principal do cliente;
- Permite que a aplicação de automação restrinja as transações disponíveis para determinado pagamento
    uma vez que, na vida prática, ocorre a negociação com o cliente e uma vez fechado o meio de pagamento,
    quantidade de parcelas, etc, não devem ser modificados por engano na hora da execução do TEF;
- Permite total liberdade na inclusão de novos produtos e meios de pagamento, acompanhando a evolução
    do SiTef, sem que seja necessário fazer nenhuma alteração na automação ou, se ela for imprescindível (por
    exemplo pela inclusão de novos periféricos de acesso tais como leitor de códigos em barra), que ela seja
    mínima.

Nota: a CliSiTef possui, para cada funcionalidade, dois pontos de entrada (rotinas). A escolha de qual das
interfaces será utilizada pela aplicação depende do gosto pessoal do programador e de se o ambiente utilizado por
ele para o desenvolvimento impõe algum tipo de restrição na chamada a CliSiTef. Em particular, estamos nos
referindo ao tipo de dado manipulado pelo ambiente de programação. Se ele aceitar somente dados em ASCII,

## necessariamente deve ser utilizada a interface batizada a seguir nesse documento como “A”.

#### 4.1 Funcionamento básico

```
Passo inicial
```
Inicialmente a Automação Comercial deve executar o comando _ConfiguraIntSiTefInterativo_ , passando as
informações necessárias para que o Terminal de Vendas possa se comunicar com o SiTef, como Endereço IP do
SiTef, Código da Empresa (no **SiTef Demonstração** este código é 00000000) e a identificação do terminal.

A rotina retorna um valor indicando se a configuração ocorreu com sucesso ou não. Caso retorne **0** (zero) o
processo ocorreu de forma correta.

```
Transação propriamente dita
```
O próximo passo é, então, chamar a função _IniciaFuncaoSiTefInterativo_ , passando os parâmetros descritos para
ela.

```
No retorno, a ela devolve o valor 10000 para continuar a transação ou outro valor para encerrar.
```
Se o retorno for **10000** , deve-se chamar a função _ContinuaFuncaoSiTefInterativo_ , com os parâmetros também
descritos para ela nós próximos tópicos.

```
Esta função deve ser chamada somente quando a CliSiTef é carregada ou seja, não é necessário
chamá-la a cada nova transação (a menos que haja uma necessidade específica para mudar
parâmetros de empresa, terminal ou IP do servidor SiTef).
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 8 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
Enquanto a **CliSiTef** retornar na chamada dessa função o valor **10000** , a automação deve ficar repetindo a
chamada a essa função tantas vezes quanto for necessário até que o valor de retorno da função seja **0** (zero),
indicando que ocorreu tudo bem, ou diferente de **0** e de **10000** indicando que ocorreu alguma interrupção anormal.

```
Confirmação (ou não-confirmação) da transação
```
Se o retorno foi **0** (zero), a automação encerra o laço e se houve impressão de cupom TEF a automação deve
imprimi-los e chamar uma outra função, a _FinalizaFuncaoSiTefInterativo_ , confirmando ou não a transação
dependendo, respectivamente, se o cupom foi impresso corretamente ou não.

Se o retorno foi diferente de **10000** e de **0** então a automação simplesmente sai do laço e, por opção do
programador, pode ou não exibir uma mensagem de acordo com o retorno da função chamada. Por exemplo, se
retornou **- 2** , significa que a transação foi cancelada pelo operador. Estes retornos negativos estão descritos neste
documento.

```
Exemplificando graficamente o fluxo descrito neste tópico, teríamos o seguinte:
```
```
ConfiguraIntSiTefInterativo
```
```
IniciaFuncaoSiTefInterativo
```
```
ContinuaFuncaoSiTefInterativo
```
```
O retorno foi igual a 0?
```
```
Houve devolução de Cupom TEF pela CliSiTef?
```
```
Imprime o cupom;
O cupom foi impresso corretamente?
```
```
Chamar a função FinalizaFuncaoSiTefInterativo
Com parâmetro Confirma = 1
```
```
Retorno igual a 0 (zero)?
Encerra a transação
S
```
```
S
```
```
S
```
```
S
```
```
S
```
```
Retorno igual a 10000?
Encerra a transação
```
```
Encerra a transação
```
```
Encerra a transação
```
```
Chamar a função FinalizaFuncaoSiTefInterativo
Com parâmetro Confirma = 0
```
```
N
```
```
N
```
```
N
```
```
N
```
```
N
```
```
Retorno igual a 10000? Se Sim então execute o
próximo Comando e chame novamente a função
S
```
```
(laço)
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 9 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
## 5 API - Rotinas disponíveis na CliSiTef

Neste capítulo, apresentaremos as funções disponíveis na clisitef. Para tanto, serão adotadas as seguintes
convenções:

**Campo vazio ou não fornecido** – na versão padrão é um campo contendo apenas o delimitador (zero binário).
Na versão ASCII, se for um campo fixo ele contém espaços. Se for um campo variável ele contém apenas o
delimitador de início e final de campo.

**Tamanho do campo** – no caso de campo de tamanho fixo, quando esse valor for fornecido, indica qual o
tamanho mínimo a ser reservado pela aplicação para receber uma resposta do SiTef.

```
Tipo de parâmetros da função – dividiremos em dois grupos:
```
1. **Quanto ao fluxo de informações** : o parâmetro pode ser de **entrada** ou **saída**.
2. **Quando à passagem** : o parâmetro pode ser passado por **valor** ou por **referência**.

```
Cada rotina descrita neste capítulo, normalmente, possui duas versões/interfaces:
```
```
Interface padrão – tradicional, permite parâmetros com dados binários
```
**Interface ASCII** – para interface com linguagens de programação, cujos parâmetros trabalham somente em
ASCII.

O que diferencia a versão ASCII da versão padrão é o acréscimo do sufixo A no nome das funções, e a forma /
tipo de passagem dos parâmetros.

```
Interface padrão
```
Esta interface pode ser utilizada por aplicações escritas nas mais variáveis linguagens de programação que
aceitam campos binários. Dentre elas citamos: Delphi, Visual Basic, Visual C.

```
No caso de comprovantes, o caractere 0x0a (\n em linguagem C) indica o final de uma linha.
```
Todas as rotinas chamadas pelo aplicativo de automação devem ser do tipo **_stdcall_** , ou seja, os parâmetros são
empilhados da direita para a esquerda e a rotina chamada é responsável por removê-los da pilha. A convenção dos
parâmetros é a seguinte:

```
Tabela 1 : Tipos e convenção de parâmetros
```
```
Tipo Descrição
char * Buffer em texto ASCII terminado por zero binário.
short int (short)
unsigned short int (ushort)
```
```
Variáveis que ocupam 2 bytes em memória, com e sem sinal, respectivamente.
```
```
int, unsigned int (uint) Variáveis que ocupam 4 bytes em memória, com e sem sinal, respectivamente.
void Indica a ausência de parâmetros ou retorno.
<tipo variável> *
(exemplo: short int * ou int
*)
```
```
Indica que a variável do “tipo variável” está sendo passada como endereço, ou
seja, a CliSiTef irá utilizar a área da aplicação de automação para trabalhar,
podendo devolver algum resultado nela.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 10 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Interface ASCII
```
Esta interface pode ser utilizada por aplicações escritas em qualquer linguagem de programação, inclusive as
que não que aceitam campos binários, tais como o ambiente Forms da Oracle.

```
Nela todos os parâmetros são passados em ASCII e podem ser de tamanho fixo e variável.
```
Os campos numéricos são passados sempre com tamanho fixo e alinhados a direita, com zeros a esquerda. Em
particular, o campo cujo conteúdo seja um valor negativo, possui um sinal “-“ na posição mais a esquerda do
número (p/ex: -0001 para um campo de 5 posições cujo conteúdo é o valor –1).

Os de tamanho variável são construídos de forma que o primeiro caractere indique qual o valor escolhido para
ser o delimitador daquele campo ou seja, o campo é delimitado pelo caractere escolhido ou o seu complementar
no caso dos pares “( )”, “[ ]”, “{ }” e “< >”.

```
Exemplos de construções válidas são: (1234), [1234], {1234}, <1234>, $1234$, %1234%, |1234|, etc.
```
```
Exemplos NÃO VÁLIDOS são os seguintes: $12$34$, .1.234,56., etc.
```
O critério para escolha do delimitador deve ser o de que ele não exista como caractere válido no campo em
questão. Nas passagens de dados da aplicação para a **_CliSiTef_** , como estes sempre são conhecidos, a aplicação pode
definir um caractere padrão e sempre utilizá-lo em todas as passagens de dados. Já no retorno, como qualquer
caractere é valido (por exemplo em um comprovante), a regra acima deve ser utilizada na interpretação do
resultado devolvido pela **_CliSiTef_** uma vez que esta irá escolher o caractere que melhor se adapta a resposta que
está sendo gerada.

Finalizando, existe um caractere especial que é utilizado nos textos direcionados para uma impressora. O “\”
(barra reversa) indica o final de uma linha e deve ser utilizado pelo aplicativo instruir a impressora para fechar a
linha corrente e se posicionar na seguinte.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 11 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 5.1 Configuração da biblioteca

Esta deve ser a primeira chamada para a biblioteca **CliSiTef**. Ela tem por objetivo configurar os parâmetros de
conexão com o **servidor SiTef** , e com a própria **Automação Comercial**.

```
int ConfiguraIntSiTefInterativo (IPSiTef, IdLoja, IdTerminal, Reservado)
```
int ConfiguraIntSiTefInterativoEx (IPSiTef, IdLoja, IdTerminal, Reservado,
ParametrosAdicionais)

```
Interface ASCII
```
```
ConfiguraIntSiTefInterativoA (Resultado, IPSiTef, IdLoja, IdTerminal, Reservado)
```
ConfiguraIntSiTefInterativoExA (Resultado, IPSiTef, IdLoja, IdTerminal, Reservado,
ParâmetrosAdicionais)

```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por
valor
```
```
Não
usado Fixo 6^ Contém o resultado de resposta à chamada da rotina.^
```
```
IPSiTef
```
```
Entrada,
por
valor
```
```
char * Variável Configura o nome ou endereço IP (em notação “.”) do servidor SiTef.
```
```
IdLoja
```
```
Entrada,
por
valor
```
```
char * Fixo 8 Identifica o número da loja perante a rede de estabelecimentos comerciais.
```
```
IdTerminal
```
```
Entrada,
por
valor
```
```
char * Fixo 8
```
```
Identifica o pdv perante a loja.
Possui o formato XXnnnnnn onde XX corresponde a 2 caracteres alfabéticos e nnnnnn 6
dígitos quaisquer desde que o número resultante não sobreponha a faixa 000900 a 000999
que é reservada para uso pelo SiTef.
```
```
Reservado
```
```
Entrada,
por
valor
```
```
char * Fixo 6 Deve ser passado com 0
```
```
ParametrosAdicionais
```
```
Entrada,
por
valor
```
```
char * Variável
```
```
Parâmetros adicionais de configuração da CliSiTef no seguinte Formato:
[<Nome_Parametro_1>=<Valor_Parametro_1>;<Nome_Parametro_2>=<Valor_Parametro_2>]
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 12 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Importante!
```
**Cada terminal deve ter um código único e fixo por loja do SiTef**. Desta forma o estabelecimento comercial deve
administrar os códigos utilizados de forma que nunca exista repetição de terminais para uma mesma loja.

**O servidor SiTef não permite duas ou mais conexões simultâneas utilizando o mesmo par (loja, terminal),
derrubando as conexões anteriores, mantendo apenas a última conexão efetuada** ; se porventura a transação que
estava em andamento quando da queda da conexão por PDV duplicado estivesse já em estado pendente (uma
venda por exemplo), o SiTef coloca-a imediatamente em estado Canc.PDV (Cancelada pelo PDV), ou seja, esta
estará cancelada; o terminal que for desconectado receberá a mensagem “Sem conexao SiTef” com o código de
erro **- 5**.

Quando o estabelecimento comercial utilizar Pinpad para leitura de cartões e digitação de senha e caso o par
(loja, terminal) seja alterado, isto implicará em nova carga de tabelas no pinpad a cada alteração. Este é mais um
motivo para que o código de terminal seja fixo.

```
As rotinas de configuração retornam um dos seguintes valores:
```
```
Tabela 2 - Códigos de retorno das funções de configuração
```
```
Valor Descrição
0 Não ocorreu erro
1 Endereço IP inválido ou não resolvido
2 Código da loja inválido
3 Código de terminal inválido
6 Erro na inicialização do Tcp/Ip
7 Falta de memória
8 Não encontrou a CliSiTef ou ela está com problemas
9 Configuração de servidores SiTef foi excedida.
10 Erro de acesso na pasta CliSiTef (possível falta de permissão para escrita)
11 Dados inválidos passados pela automação.
12 Modo seguro não ativo (possível falta de configuração no servidor SiTef do arquivo .cha ).
13 Caminho DLL inválido (o caminho completo das bibliotecas está muito grande).
```
**Observação:** durante o ciclo de vida da automação, caso não haja mudança nos parâmetros de entrada da
função, então não há necessidade de chamá-la novamente.

##### 5.1.1 Configurações especiais gerais

Determinadas configurações gerais (válidas para todas as transações) da CliSiTef podem ser passadas através do
parâmetro “ _ParametrosAdicionais_ ” da rotina _ConfiguraIntSiTefInterativoEx_. O formato deste campo é o seguinte:

```
[<Funcionalidade >;<Funcionalidade >;...]
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 13 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
A seguir, descrevemos as funcionalidades previstas neste campo.
```
**Observação** : neste item serão destacadas somente as configurações principais. Para a descrição detalhada de
todos as opções disponíveis, consulte o documento “CliSiTef – Lista de Parâmetros Adicionais”.

```
Funcionalidade Descrição
```
```
MultiplosCupons=
```
```
Indica que o PDV está apto para receber mais de um comprovante por
transação. No caso de transações com mais de um comprovante, como
transações de recarga de celular ou pagamentos de contas com cartões de
crédito ou débito, o comprovante da recarga de celular ou do pagamento de
conta será entregue separadamente do comprovante do TEF de crédito ou
débito.
```
```
PortaPinPad=<Porta PinPad>
```
```
Define a porta em que está conectado o pinpad compartilhado.
Exemplo:
Windows: [PortaPinPad=1]
Linux: [PortaPinPad=/dev/ttyS0]
LojaECF=<Num Loja> Número da loja fiscal (Tamanho máximo: 20)
CaixaECF=<Num Caixa> Número do caixa fiscal (Tamanho máximo: 20)
NumeroSerieECF=<Serie ECF> Número de série do ECF (Tamanho máximo: 20)
```
##### 5.1.2 Informações adicionais da Automação/Estabelecimento

A configuração ParmsClient permite que a automação comercial possa configurar informações comuns a todas
as transações trocadas com o servidor SiTef.

```
Formato:
```
```
[ParmsClient=Id 1 =Valor 1 ;Id 2 =Valor 2 ;Id 3 =Valor 3 ;...;IdN=ValorN]
```
```
onde:
```
```
<ParmsClient=> = Prefixo identificador dos dados.
```
```
<Id N > = Identificador do campo, conforme definida a tabela abaixo.
```
```
<Valor N > = Valor do campo.
```
```
Id Formato Significado
1 Numérico CNPJ do estabelecimento/loja.
2 Numérico CNPJ da empresa que desenvolveu a automação comercial.
3 Numérico CPF do estabelecimento/loja
4 Numérico CNPJ Facilitador (Van)
Tabela 3 Códigos de campos disponíveis para ParmsClient.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 14 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Exemplo de como enviar dos dados para a CliSiTef:
```
```
[ParmsClient=1=31406434895111;2=12523654185985]
```
```
Onde:
```
- 1 (CNPJ do Estabelecimento) com o valor 31406434895111.
- 2 (CNPJ da empresa de automação comercial) com o valor 12523654185985.

**Observação** : este parâmetro **não** deve ser usado para fins de sub-adquirência (soft descriptor). Para este fim,
consulte o documento “CliSiTef - Informações de Sub-Adquirência (Soft Descriptor)”


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 15 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
##### 5.1.3 Ponto flutuante

```
Como a automação informa à CliSiTef que sabe tratar campos com ponto flutuante
```
O tratamento de campos com Ponto Flutuante requer um procedimento executado em conjunto com a
automação.

Para que a Clisitef efetue este procedimento que será descrito adiante, é necessário que a automação informe
à Clisitef que está apta a tratá-lo. Para isso, a automação deve passar a string abaixo no parâmetro
“ParametrosAdicionais” na execução da função ConfiguraIntSiTefInterativoEx.

```
[TrataPontoFlutuante=1]
```
Se este parâmetro for omitido e o SiTef solicitar a coleta de campo com Ponto Flutuante, a CliSiTef solicitará à
automação, a exibição da mensagem: "Ponto Flutuante nao Suportado pelo PDV".

```
Procedimento em “operação casada” com a automação
```
Se foi informado na Configuração, suportar o recurso de Ponto Flutuante, conforme descrito acima, a CliSiTef
através do Comando 0 em conjunto com o TipoCampo **2470** , informa à Automação a quantidade de casas decimais
no parâmetro Buffer, para que esta possa formatar suas telas antes de exibi-las ao operador (Vide Exemplos de
Telas na próxima página). Somente após este “pacto” com a Automação, a CliSiTef enviará o comando de coleta do
campo com ponto flutuante (através dos comandos 34 ou 30) conforme exemplos abaixo.

```
Parâmetros
ContinuaFuncaoSiTefInterativo:
CliSiTef ========= ➔ PDV
Comando TipoCampo
0 2470
Exemplos de quantidade de casas decimais Buffer
Peso do Almoço em gramas com 2 casas 2
Total da Bomba de Combustível em reais com 3 casas 3
```
- No exemplo onde a quantidade de casas decimais informada foi 2, logo após, a CliSitef solicitará o comando
30:


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 16 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
- No exemplo onde a quantidade de casas decimais informada foi 3, logo após, a CliSitef solicitará o comando 34:


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 17 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 5.2 Início da transação de Pagamento ou Gerencial.........................................................................................

```
As rotinas a seguir são as recomendadas para iniciar uma transação na CliSiTef.
```
```
O que diferencia a transação a ser executada é o código de Função passado por parâmetro. (Vide Tabela 5.2.2)
```
As diversas transações iniciadas pela automação comercial ficam agrupadas pelos dados fiscais, que é o par
(CupomFiscal, DataFiscal) e com esses dados são realizados os controles de transações pendentes de confirmações
da CliSiTef.

A HoraFiscal é importante para validações de segurança de alguns fabricantes de pinpad (com o objetivo de
evitar ataques e fraudes).

int IniciaFuncaoSiTefInterativo (Funcao, Valor, CupomFiscal, DataFiscal,
HoraFiscal, Operador, ParamAdic)

```
Interface ASCII
```
IniciaFuncaoSiTefInterativoA (Resultado, Funcao, Valor, CupomFiscal, DataFiscal,
HoraFiscal, Operador, ParamAdic)

```
As funções abaixo eram utilizadas para terminais de Auto-Atendimento , e são consideradas obsoletas.
```
int IniciaFuncaoAASiTefInterativo (Funcao, Valor, CupomFiscal, DataFiscal,
HoraFiscal, Operador, ParamAdic, Produtos)

```
Interface ASCII
```
IniciaFuncaoAASiTefInterativoA (Resultado, Funcao, Valor, CupomFiscal, DataFiscal,
HoraDiscal, Operador, ParamAdic, Produtos)

```
Parâmetro Tipo Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado Saída,
por valor
```
```
Não
usado
```
```
Fixo 6 Contém o resultado de resposta à chamada da rotina.
```
```
Funcao Entrada,
por valor
```
```
int Fixo 6 Seleciona a forma de pagamento, conforme a tabela
“Códigos de Funções” a seguir.
Valor Entrada,
por valor
```
```
char * Variável Contém o valor a ser pago contendo o separador decimal
(“,”). Deve sempre ser passado com duas casas decimais
após a vírgula (“,”). Caso a operação não tenha um valor
definido a priori (p/ex. recarga de pré-pago), esse campo
deve vir vazio.
CupomFiscal Entrada,
por valor
```
```
char * Máx. 20 Número do Cupom Fiscal correspondente à venda
```
```
É importante que o número do cupom fiscal seja sempre
crescente (incrementado a cada transação), pois todo
processo de controle de transações pendentes e
confirmações da CliSiTef se baseiam no conjunto
CupomFiscal + DataFiscal.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 18 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Parâmetro Tipo Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
DataFiscal Entrada,
por valor
```
```
char * Fixo 8 Data Fiscal no formato AAAAMMDD
```
```
HoraFiscal Entrada,
por valor
```
```
char * Fixo 6 Horário Fiscal no formato HHMMSS
```
```
Operador Entrada,
por valor
```
```
char * Máx. 20 Identificação do operador de caixa
```
```
ParamAdic Entrada,
por valor
```
```
char * Variável Parâmetros adicionais. Permite que o aplicativo limite o tipo
de meio de pagamento. Ele é opcional e pode ser passado
vazio. Quando esse campo for utilizado a CliSiTef irá limitar
os menus de navegação apenas aos códigos não presentes
na lista. Vide item 5 para a descrição do formato interno
deste campo
Produtos Entrada,
por valor
```
```
char * Variável Contém a lista de produtos que o cliente está adquirindo
no terminal de Auto-Atendimento. É obrigatório pois tais
produtos farão parte integrante do comprovante da
operação de Tef a ser impresso.
O formato básico deste campo é:
```
```
[<Descrição1>;<Código1>;<Quantidade1>;<ValorTotal1>];
[<Descrição2>;<Código2>;<Quantidade2>;<ValorTotal2>];...
```
```
Campo Formato
Descrição 1 a 14 caracteres
Código 1 a 08 caracteres
Quantidade 1 a 04 dígitos
Valor 999.999,
```
```
Ele deve ser repetido tantas vezes quanto o número de
produtos distintos adquirido pelo cliente.
```
**_IMPORTANTE_** : Essa rotina apenas inicia o processo de pagamento. Se o retorno for **10000** o processo de
pagamento deve ser continuado através da rotina **ContinuaFuncaoSiTefInterativo** ou
**ContinuaFuncaoSiTefInterativoA** até que esta última devolva um resultado final (vide item que descreve esta
função).

**_IMPORTANTE_** : até a versão 6.1.114.39 (inclusive) da clisitef, sempre que for iniciado um pagamento em um
novo documento fiscal (um par <CupomFiscal, DataFiscal> diferente do anterior), os dados da transação anterior
serão substituídos pelos da recém-iniciada, impossibilitando que alguns tratamentos, como os de pendências,
sejam feitos com sucesso.

```
Portanto, devem ser resolvidos todos os tratamentos necessários antes de iniciar-se uma nova transação.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 19 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
A partir da versão 6.1.114.40 (inclusive), a CliSiTef permite iniciar um novo pagamento, sem apagar eventuais
```
#### pendências do documento fiscal anterior.


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_20_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

##### 5.2.1 Tabela de códigos de retorno

```
Valor Descrição
0 Sucesso na execução da função.
10000 Deve ser chamada a rotina de continuidade do processo.
outro valor positivo Negada pelo autorizador.
```
- 1

```
Módulo não inicializado. O PDV tentou chamar alguma rotina sem antes executar a
função configura.
```
- 2 Operação cancelada pelo operador.
- 3 O parâmetro função / modalidade é inexistente/inválido.
- 4 Falta de memória no PDV.
- 5 Sem comunicação com o SiTef.
- 6 Operação cancelada pelo usuário (no pinpad).
- 7 Reservado
- 8

```
A CliSiTef não possui a implementação da função necessária, provavelmente está
desatualizada (a CliSiTefI é mais recente).
```
- 9

```
A automação chamou a rotina ContinuaFuncaoSiTefInterativo sem antes iniciar uma
função iterativa.
```
- 10 Algum parâmetro obrigatório não foi passado pela automação comercial.
- 12

```
Erro na execução da rotina iterativa. Provavelmente o processo iterativo anterior não
foi executado até o final (enquanto o retorno for igual a 10000 ).
```
- 13

```
Documento fiscal não encontrado nos registros da CliSiTef. Retornado em funções de
consulta tais como ObtemQuantidadeTransaçõesPendentes.
```
- 15 Operação cancelada pela automação comercial.
- 20 Parâmetro inválido passado para a função.
- 21 Utilizada uma palavra proibida, por exemplo SENHA, para coletar dados em aberto no
    pinpad. Por exemplo na função _ObtemDadoPinpadDiretoEx_.
- 25 Erro no Correspondente Bancário: Deve realizar sangria.
- 30

```
Erro de acesso ao arquivo. Certifique-se que o usuário que roda a aplicação tem
direitos de leitura/escrita.
```
- 40 Transação negada pelo **servidor SiTef**.
- 41 Dados inválidos.
- 42 Reservado
- 43 Problema na execução de alguma das rotinas no pinpad.
- 50 Transação não segura.
- 100 Erro interno do módulo.
outro valor negativo Erros detectados internamente pela rotina.


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_21_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

##### 5.2.2 Tabela de códigos de funções

```
Os seguintes códigos estão disponíveis para serem usados no parâmetro Funcao descrita acima^1.
```
```
Função Descrição
```
###### 0

```
Pagamento genérico. A CliSiTef permite que o operador escolha a forma de pagamento através de
menus.
```
```
1 Cheque
```
```
2 Débito
```
```
3 Crédito
```
```
4 Fininvest
```
```
5 Cartão Benefício
```
```
6 Crédito Centralizado
```
```
7 Cartão Combustível
```
```
8 Parcele Mais Redecard
```
```
10 Benefício Refeição Wappa
```
```
11 Benefício Alimentação Wappa
```
```
12 Cartão Infocard
```
```
13 Pay Pass
```
```
15 Venda com cartão Gift
```
```
16 Débito para pagamento de carnê
```
```
17 Crédito para pagamento de carnê
```
```
28 Venda com Cartão Qualidade (ICI Card)
```
###### 100

```
Telemarketing: Inicia a coleta dos dados da transação no ponto necessário para tratar uma
transação de cartão de crédito digitado
```
(^1) Consulte documentos de produtos específicos para outros códigos de função


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_22_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Função Descrição
```
```
101 Cancelamento de venda com cartão Qualidade (ICI Card)
```
```
110 Abre o menu de transações Gerenciais
```
```
111 Teste de comunicação com o SiTef
```
```
112 Menu Re-impressão
```
```
113 Re-impressão comprovante específico
```
```
114 Re-impressão ultimo comprovante
```
```
115 Pré-autorização
```
```
116 Captura de pré-autorização
```
```
117 Ajuste de pré-autorização
```
```
118 Consulta de pré-autorização
```
```
130 Consulta de transações pendentes no terminal
```
```
131 Consulta de transações pendentes em um documento fiscal específico
```
```
150 Consulta Bônus
```
```
151 Consulta Saldo Cartão Presente
```
```
152 Consulta Saldo Cartão Gift
```
```
160 Consultas Cartão EMS
```
```
161 Vendas Cartão EMS
```
###### 200

```
Cancelamento Normal: Inicia a coleta dos dados no ponto necessário para fazer o cancelamento de
uma transação de débito ou crédito, sem ser necessário passar antes pelo menu de transações
administrativas
```
###### 201

```
Cancelamento Telemarketing: Similar a modalidade 200 só que para a função de cancelamento de
transação de crédito digitado
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_23_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Função Descrição
```
```
202 Cancelamento Pré-autorização
```
```
203 Cancelamento da Captura da Pré-autorização
```
```
210 Cancelamento de venda com cartão de Crédito
```
```
211 Cancelamento de venda com cartão de Débito
```
```
212 Cancelamento de venda com cartão Combustível
```
```
213 Cancelamento de Venda com Cartão Gift
```
```
250 Cancelamento de Consulta Bônus
```
```
251 Cancelamento Recarga Cartão Presente
```
```
253 Cancelamento Acúmulo de Pontos Cartão Bônus
```
```
254 Resgate de Pontos Cartão Bônus
```
```
255 Cancelamento de Resgate de Pontos Cartão Bônus
```
```
256 Acúmulo de Pontos Cartão Bônus
```
```
257 Cancelamento Recarga Cartão Gift
```
```
264 Recarga Cartão Gift
```
```
265 Ativação Pagamento Vinculado Cartão Gift
```
```
266 Consulta Cartão Gift
```
```
267 Ativação Cartão Gift Sem Pagamento
```
```
268 Ativação Cartão Gift Com Pagamento
```
```
269 Ativação Desvinculada Cartão Gift
```
```
310 Corresponde Bancário (Pagamento de Contas)
```
```
311 Pagamento de Contas com Saque
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_24_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Função Descrição
```
```
312 Consulta para Pagamento Desvinculado (Genérico)
```
```
313 Pagamento Desvinculado (Genérico)
```
```
314 Recarga Pré Pago Corban SE com Saque
```
```
315 Saque para Pagamento
```
```
316 Cancelamento do pagamento desvinculado (genérico)
```
```
317 Consulta Limites do Correspondente Bancário
```
```
318 Recarga Pré Pago Bradesco
```
```
319 Recarga Pré Pago Bradesco desvinculada do pagamento
```
```
320 Recarga Pré Pago Corban SE
```
```
321 Recarga Pré Pago Corban SE desvinculada do pagamento
```
```
322 Depósito Identificado
```
```
323 Transferência entre Contas
```
```
324 Pague Fácil
```
```
325 Revalidação de Senha INSS
```
```
350 Venda Produto (Sem Valor)
```
```
351 Cancelamento de Venda Produto (Sem Valor)
```
```
400 Vale-Gás
```
```
401 Validação Vale-Gás
```
```
410 Troco Surpresa
```
```
422 Adesão de Seguro
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_25_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Função Descrição
```
```
430 Le Cartão Seguro (LeCartaoSeguro)
```
```
431 Le Trilha Chip (LeTrilhaChipInterativoEx)
```
```
500 Consulta Detalhada ACSP
```
```
501 Consulta Detalhada Serasa
```
```
600 Consulta Saldo
```
```
601 Consulta Saldo Cartão de Débito
```
```
602 Consulta Saldo Cartão de Crédito
```
```
657 Saque Crédito Transferência
```
```
658 Saque Crédito
```
```
660 Menu Saque IBI
```
```
661 Consulta Saque Banco IBI
```
```
662 Saque Banco IBI
```
```
663 Saque GetNet
```
```
664 Cancelamento Saque GetNet
```
```
665 Resgate de Pontos
```
```
667 Emissão de Pontos
```
```
668 Cancelamento da Emissão de Pontos
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_26_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Função Descrição
```
```
669 Carga de Pré Pago
```
```
670 Cancelamento de Carga de Pré Pago
```
```
671 Consulta Saque com Saque Banco IBI
```
```
672 Cancelamento Saque Banco IBI
```
```
680 Consulta Saldo Pré Pago
```
```
698 Saque Débito
```
```
700 Venda Oi Paggo
```
```
701 Cancelamento Oi Paggo
```
```
702 Pagamento de contas
```
```
703 Cancelamento de Pagamento Cartão Benefício
```
```
705 Pagamento de Fatura
```
```
740 Consulta Parcelas Crédito Adm
```
```
770 Carga de tabelas no pinpad^2
```
```
771 Carga forçada de tabelas no pinpad (Local)
```
```
772 Carga forçada de tabelas no pinpad (SiTef)
```
(^2) Consulte o item 5.12 - Carga de Tabelas no PinPad para maiores informações.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 27 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Função Descrição
```
(^775) Obtenção de informações do pinpad (^3)
899 Recarga de cartão de crédito
900 Cancelamento de recarga de cartão de crédito
913 Alteração de Pré-Autorização
928 Cancelamento Débito para Pagamento Carnê Rede Forçada
943 Pagamento Fatura sem fatura vinculado
944 Pagamento Fatura sem fatura desvinculado
999 Fechamento
1000 Voucher Papel

##### 5.2.3 Parâmetros Adicionais

Parâmetros adicionais, válidos para a transação corrente, podem ser passadas para CliSiTef através do
parâmetro _ParamAdic_ da rotina _IniciaFuncaoSiTefInterativo_ e suas variantes.

Para atender a necessidade de algumas redes “Autorizadoras”, que necessitam de informações sobre o
Documento Fiscal Eletrônico emitido pelas “Automações Comerciais”, foram definidas 2 “funcionalidades” para
passar os dados necessários no parâmetro _ParamAdic_ (ver detalhes no item Habilitação de configurações especiais
por transação).

#### 5.3 Continuação do processo de coleta iterativo

Esta função deve ser chamada de forma contínua até não existam mais informações para serem trocadas entre
a aplicação e a **CliSiTef** (isto é, enquanto seu retorno for igual a **10000** ), conforme descrito nos resultados devolvidos
por ela. O formato de ativação é o seguinte:

int ContinuaFuncaoSiTefInterativo (Comando, TipoCampo, TamMinimo, TamMaximo,
Buffer, TamBuffer, Continua)

```
Interface ASCII
```
ContinuaFuncaoSiTefInterativoA (Resultado, Comando, TipoCampo, TamMinimo,
TamMaximo, Buffer, TamBuffer, Continua)

(^3) Consulte o item 5.11 - Informações do PinPad para maiores informações.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 28 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Parâmetro Tipo Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado Saída,
por valor
```
```
Não
usado
```
```
Fixo 6 Contém o resultado de resposta à chamada da rotina.
```
```
Comando Saída,
por
referência
```
```
int * Fixo 12 Contém no retorno:
0 → caso a CliSiTef esteja devolvendo algum dado
referente a transação no campo Buffer
<> 0 → indica o Próximo Comando a ser executado pelo
aplicativo. Os comando válidos estão descritos em Tabela de
códigos de Comando
TipoCampo Saída,
por
referência
```
```
long * Fixo 12 Contém o código do tipo de campo que a automação deve
tratar. Os tipos existentes estão descritos em Tabela de
valores para TipoCamp
TamMinimo Saída,
por
referência
```
```
short * Fixo 6 Quando o Comando for uma coleta de dados, contém o
tamanho Mínimo e Máximo do campo a ser lido
```
```
TamMaximo Saída,
por
referência
```
```
short * Fixo 6
```
```
Buffer Entrada e
Saída,
por valor
```
```
char * Variável Área de transferência de dados entre a aplicação e a CliSiTef.
Deve possuir, no mínimo, 20.000 bytes. Se automação não
estiver enviando dados para a CliSiTef , deve passar esse
campo vazio
TamBuffer Entrada,
por valor
```
```
int Fixo 6 Tamanho da área reservada pela automação para o campo
Buffer
Continua Entrada,
por valor
```
```
int Fixo 6 Contem instruções para a CliSiTef a respeito do Comando
executado segundo a seguinte codificação:
0 → Continua a transação
1 → Retorna, quando possível, a coleta ao campo anterior
2 → Cancela o pagamento de conta atual, mantendo os
anteriores em memória, caso existam, permitindo que tais
pagamentos sejam enviados para o SiTef e até mesmo
permite incluir novos pagamentos. Retorno válido apenas nas
coletas de valores e data de vencimento de um pagamento
de contas.
10000 → Continua a transação, vide observação a
seguir
```
**- 1** → Encerra a transação

Obs.: Como nem sempre o campo solicitado pela rotina precisa ser lido no momento da solicitação a rotina
aceita o valor **10000** para indicar que o campo não foi coletado naquele momento mas sim previamente, no
momento do fechamento da venda.

Um exemplo típico desta situação ocorre quando a automação já fechou com o cliente uma forma de pagamento
parcelado com cartão de crédito. Neste caso a automação pode, no momento que a coleta campo for solicitada
para ler o número de parcelas, já devolver o número previamente combinado sem capturar esse dado do usuário.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 29 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
Notar que nessa forma de uso é imprescindível que o dado seja apresentado para o operador que deverá
confirmar veracidade dele antes da rotina devolver o mesmo para a **_CliSiTef_**.

Notar também que esta forma de uso não é obrigatória, podendo a automação sempre capturar os dados da
tela. O uso desta característica poderá alterar o fluxo de coleta ou qualquer regra definida pelas bandeiras, por isso
antes de sua utilização realizar consulta a departamento de Suporte da Software Express que verificará a
necessidade de autorização prévia pelas bandeiras.

No retorno a rotina devolve os mesmos valores da rotina de Pagamento. Adicionalmente a estes valores, a
função devolve o valor **0** (Zero) para indicar que a função solicitada foi concluída com sucesso (p/ex: se for um
pagamento, ele foi aprovado pela administradora).

É importante salientar que a chamada que inicia o processo iterativo (aquela que é feita após ter sido recebido
o valor **10000** na chamada de uma função de Pagamento, Gerencial, etc...) deve ser feita com _Comando_ ,
_TipoCampo_ , _TamMinimo_ , _TamMaximo_ e _Continua_ contendo o valor **0** (zero).

Notar também que a automação comercial deve ficar em laço chamando a rotina aqui descrita até que ela
receba um resultado diferente de **10000** ou que a própria automação desista de continuar o processo, conforme
mostrado a seguir:


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 30 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
Caso a automação deseje encerrar o processo de coleta ela deve, necessariamente, chamar a rotina
_ContinuaFuncaoSiTefInterativo_ passando **– 1** (menos um) no campo _Continua_. Caso o processo de coleta deva
continuar, ela não deve modificar nenhum dos campos preenchidos pela **CliSiTef** a não ser o _Buffer_ que, na nova
chamada, deve conter o resultado da coleta (se _Comando_ diferente de **0** ) ou o dado original se Comando veio com
**0**. Notar ainda que mesmo que o _Buffer_ contenha um campo coletado pela automação, o seu tamanho deve ser o
recomendado por esse documento pois irá conter, no retorno, novos dados fornecidos pela rotina.

Notar que o campo _Buffer_ pode ter sido preenchido pela rotina com algum dado para ser memorizado,
apresentado no visor ou outro motivo, segundo o que está especificado na descrição de cada comando que o
aplicativo de automação deve tratar.

**_IMPORTANTE:_** É obrigatório que a automação SEMPRE colete campos não tratáveis por ela ou seja, se ela
receber algum código em _erro pinpad_

que ela desconheça ou não deseje tratar, que a informação seja capturada pela digitação pelo operador da
informação solicitada.

## Inicializa Comando, TipoCampo,

## TamMinimo, TamMaximoe

## Continua com 0

## Inicializa TamBuffercom o

## tamanho do Buffer

## Chama a rotina

## ContinuaFuncaoSiTefInterativo

#### Retornou

#### 10000?

## Executa o Comando

## solicitado

## Fim

#### Sim

#### Não

## Início


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_31_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 32 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
##### 5.3.1 Tabela de códigos de Comando

A seguir apresentamos os valores possíveis para o parâmetro _Comando_ e a ação que a aplicação deve executar
ao recebê-lo. É importante que a automação comercial trate **todos** os comandos desta tabela.

```
Comando Descrição
```
```
0 Está devolvendo um valor para, se desejado, ser armazenado pela automação
```
```
1 Mensagem para o visor do operador
```
```
2 Mensagem para o visor do cliente
```
```
3 Mensagem para os dois visores
```
```
4 Texto que deverá ser utilizado como título na apresentação do menu ( vide comando 21 )
```
```
11 Deve remover a mensagem apresentada no visor do operador (comando 1 )
```
```
12 Deve remover a mensagem apresentada no visor do cliente (comando 2 )
```
```
13 Deve remover mensagem apresentada no visor do operador e do cliente (comando 3 )
```
```
14 Deve limpar o texto utilizado como título na apresentação do menu (comando 4 )
```
###### 15

```
Cabeçalho a ser apresentado pela aplicação. Refere-se a exibição de informações adicionais que
algumas transações necessitam mostrar na tela.
```
```
Um exemplo é a transação de Empréstimo do Correspondente Bancário, que em certo ponto
precisa que sejam mostradas informações para o cliente detalhando o empréstimo que está
sendo contratado (como Valor da parcela, vencimento, etc..).
```
```
16 Deve remover o cabeçalho apresentado pelo comando 15.
```
###### 20

```
Deve apresentar o texto em Buffer , e obter uma resposta do tipo SIM/NÃO.
```
```
No retorno o primeiro caráter presente em Buffer deve conter 0 se confirma e 1 se cancela.
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_33_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Comando Descrição
```
###### 21

```
Deve apresentar um menu de opções e permitir que o usuário selecione uma delas.
```
```
Na chamada o parâmetro Buffer contém as opções no formato 1:texto;2:texto;...i:Texto;...
```
```
A rotina da aplicação deve apresentar as opções da forma que ela desejar (não sendo necessário
incluir os índices 1,2, ...).
```
```
Após a seleção feita pelo usuário, retornar em Buffer o índice i escolhido pelo operador (em
ASCII)
```
###### 22

```
Deve apresentar a mensagem em Buffer , e aguardar uma tecla do operador. É utilizada quando
se deseja que o operador seja avisado de alguma mensagem apresentada na tela.
```
###### 23

```
Este comando indica que a rotina está perguntando para a aplicação se ele deseja interromper o
processo de coleta de dados ou não. Esse código ocorre quando a CliSiTef está acessando algum
periférico e permite que a automação interrompa esse acesso (por exemplo: aguardando a
passagem de um cartão pela leitora ou a digitação de senha pelo cliente)
```
```
Observação: É importante que a “Aplicação da Automação Comercial” não coloque “delays”
ao tratar este comando. Neste ponto, algum dispositivo (pinpad, leitora de código de barras...)
está efetuando algum processamento (lendo cartão/código de barras, coletando senha) e um
“delay” causa atrasos no acesso aos dados do dispositivo, que pode não estar mais disponível
acarretando perda de dados e erro de comunicação.
```
###### 29

```
Análogo ao comando 30 , porém deve ser coletado um campo que não requer intervenção do
operador de caixa, ou seja, não precisa que seja digitado/mostrado na tela, e sim passado
diretamente para a biblioteca pela automação.
```
```
Um exemplo são as formas de pagamento que algumas transações requerem para identificar
qual o tipo de pagamento que está sendo usado.
```
```
O valor a ser coletado refere-se ao campo indicado em TipoCampo , cujo tamanho está entre
TamMinimo e TamMaximo. O campo deve ser devolvido em Buffer.
```
```
30 Deve ser lido um campo cujo tamanho está entre TamMinimo^ e TamMaximo. O campo lido deve
ser devolvido em Buffer.
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_34_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Comando Descrição
```
###### 31

```
Deve ser lido o número de um cheque. A coleta pode ser feita via leitura de CMC-7, digitação do
CMC-7 ou pela digitação da primeira linha do cheque.
```
```
No retorno deve ser devolvido em Buffer :
```
```
“0:”(digitação da primeira linha do cheque),
```
```
“1:”(Leitura do CMC-7) ou
```
```
“2:”(Digitação do CMC-7),
```
```
seguido do número coletado manualmente ou pela leitura/digitação do CMC-7, respectivamente.
```
```
Quando a primeira linha do cheque for coletada manualmente, o formato é o seguinte:
Compensação (3), Banco (3), Agencia (4), C1 (1), ContaCorrente (10), C2 (1), Numero do Cheque
(6) e C3 (1), nesta ordem. Notar que estes campos são os que estão na parte superior de um
cheque e na ordem apresentada.
```
```
Sugerimos que na coleta seja apresentada uma interface que permita ao operador identificar e
digitar adequadamente estas informações de forma que a consulta não seja feita com dados
errados, retornando como bom um cheque com problemas.
```
```
34 Deve ser lido um campo monetário ou seja, aceita o delimitador de centavos e devolvido no
parâmetro Buffer.
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_35_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Comando Descrição
```
###### 35

```
Deve ser lido um código em barras ou o mesmo deve ser coletado manualmente.
```
```
No retorno Buffer deve conter “0:” ou “1:” seguido do código em barras coletado manualmente
ou pela leitora, respectivamente.
```
```
Cabe ao aplicativo decidir se a coleta será manual ou através de uma leitora. Caso seja coleta
manual, recomenda-se seguir o procedimento descrito na rotina ValidaCampoCodigoEmBarras^4
de forma a tratar um código em barras da forma mais genérica possível, deixando o aplicativo de
automação independente de futuras alterações que possam surgir nos formatos em barras.
```
```
No retorno do Buffer também pode ser passado “2:”, indicando que a coleta foi cancelada, porém
o fluxo não será interrompido, logo no caso de pagamentos múltiplos, todos os documentados
coletados anteriormente serão mantidos e o fluxo retomado, permitindo a efetivação de tais
pagamentos.
41 Análogo ao Comando 30 , porém o campo deve ser coletado de forma mascarada.
```
(^4) Vide Verificação da integridade de um código em barras para maiores informações.


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_36_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Comando Descrição
```
###### 42

```
Menu identificado. Deve apresentar um menu de opções e permitir que o usuário selecione uma
delas.
```
```
Na chamada o parâmetro Buffer contém as opções no formato
classe|1:texto:código:tipo;2:texto:código:tipo;...i:Texto:código:tipo;.
```
```
A rotina da aplicação deve apresentar as opções da forma que ela desejar (não sendo necessário
incluir os índices 1,2, ..., nem códigos do campo, tipo e classe) e após a seleção feita pelo usuário,
retornar em Buffer o índice i escolhido pelo operador (em ASCII).
```
```
O código das opções é a identificação (Tabela de códigos de meios de pagamento, configurações
e menus) do campo da opção, ela pode ser utilizada na identificação da opção escolhida.
```
```
Dentro de cada “classe” existe a codificação de “tipos”, e cada par (classe, tipo) indica a natureza
da opção. Inicialmente foi implementada apenas a identificação para as formas de pagamento. A
ideia é adicionar códigos que identificam as opções do menu para possibilitar que o PDV
identifique essas opções sem o auxílio do operador.
```
- Classes:
o 0: Classe não definida
o 1: Forma de pagamento, tipos abaixo:
▪ 1: Dinheiro
▪ 2: Cheque
▪ 3: Débito
▪ 4: Crédito
▪ 5: Saque
▪ 6: Outra forma

```
Os demais menus não estão identificados. Os menus não identificados recebem o valor zerado
nesses campos, indicando que ainda não houve a necessidade de classificá-los.
```
```
As classes de opção têm como objetivo definir um contexto para o qual o código que identifica o
tipo de opção seja determinado. Assim, uma opção no menu é identificada sempre a partir do par
tipo da opção e classe da opção.
```
```
Esse comando passa a ser utilizado quando o parâmetro adicional ItemMenuIdentificado for
utilizado (Habilitação de configurações especiais). Nesse caso, o comando 21 (coleta de menu)
será substituído na maior parte dos casos, sendo obrigação da aplicação estar preparada para
tratar os dois comandos, quando esse parâmetro estiver habilitado.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 37 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
##### 5.3.2 Tabela de valores para TipoCampo...................................................................................................

```
A seguir apresentamos os valores possíveis para o campo TipoCampo e respectivos significados^5 :
```
```
Os campos marcados com * indicam que são utilizados em um ou mais produtos.
```
Note que nem todos os campos são retornados em todas as transações. Além disso, existem campos que
somente são retornados se a transação foi aprovada.

O aplicativo de automação deve ignorar aqueles campos que não desejar/não souber tratar uma vez que, em
versões futuras da CliSiTef, novos campos poderão ser disponibilizados. Note que a forma correta de ignorar estes
campos é executar a função definida em _ProximoComando_ ou simplesmente ignorar o dado retornado para a
aplicação quando _ProximoComando_ for **0**.

Cabe a **automação comercial** armazenar os comprovantes para impressão na hora apropriada, segundo a
legislação Fiscal vigente.

Já no caso do **Correspondente Bancário** ou de **Funções Administrativas** , a impressão de qualquer comprovante
deve ser feita no momento que eles forem disponibilizados para a automação e a informação de se eles foram
impressos corretamente ou não é passada pela função _ContinuaFuncaoSiTefInterativo_ através do valor **0** ou **- 1** ,
respectivamente, colocado em _Continua_.

```
TipoCampo Descrição
```
- 1 Não existem informações que podem/devem ser tratadas pela automação

```
0
```
```
A rotina está sendo chamada para indicar que acabou de coletar os dados da transação e irá iniciar
a interação com o SiTef para obter a autorização
```
###### 1

```
Dados de confirmação da transação. Para ambientes com múltiplos servidores será retornado no
seguinte formato:
<Dados_Confirmacao>;<Indice_SiTef>;<Endereco_SiTef>
2 Informa o código da função SiTef utilizado na mensagem enviada para o servidor.
10 a 99
e
3000 a
3999
```
```
Informa qual a opção selecionada no menu de navegação de transações seguindo a mesma
codificação utilizada para definir as restrições no pagamento descritas no item Restrição ou
habilitação das formas de pagamento.
```
(^5) Consulte documentos de produtos específicos para outros códigos de campo.


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_38_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

###### 100

```
Modalidade de pagamento no formato xxnn.
xx corresponde ao grupo da modalidade e nn ao subgrupo.
Grupo:
```
- 00: Cheque
- 01: Cartão de Débito
- 02: Cartão de Crédito
- 03: Cartão tipo Voucher
- 05: Cartão Fidelidade
- 98: Dinheiro
- 99: Outro tipo de cartão
Subgrupo:
- 00: À vista
- 01: Pré-datado
- 02: Parcelado com financiamento pelo estabelecimento
- 03: Parcelado com financiamento pela administradora
- 04: À vista com juros
- 05: Crediário
- 99: Outro tipo de pagamento

```
101
```
```
Contém o texto real da modalidade de pagamento que pode ser memorizado pela aplicação caso
exista essa necessidade. Descreve por extenso o par xxnn fornecido em 100
```
```
102 Contém o texto descritivo da modalidade de pagamento que deve ser impresso no cupom fiscal
(p/ex: T.E.F., Cheque, etc...)
105 Contém a data e hora da transação no formato AAAAMMDDHHMMSS
```
###### 110

```
Retorna quando uma transação for cancelada. Contém a modalidade de cancelamento no formato
xxnn, seguindo o mesmo formato xxnn do TipoCampo 100. O sub-grupo nn todavia, contém o valor
default 00 por não ser coletado.
```
```
111 Contém o texto real da modalidade de cancelamento que pode ser memorizado pela aplicação caso
exista essa necessidade. Descreve por extenso o par xxnn fornecido em 110.
```
```
112
```
```
Contém o texto descritivo da modalidade de cancelamento que deve ser impresso no cupom fiscal
(p/ex: T.E.F., Cheque, etc...).
115 Modalidade Ajuste
120 Buffer contém a linha de autenticação do cheque para ser impresso no verso do mesmo
```
###### 121

```
Buffer contém a primeira via do comprovante de pagamento (via do cliente) a ser impressa na
impressora fiscal. Essa via, quando possível, é reduzida de forma a ocupar poucas linhas na
impressora. Pode ser um comprovante de venda ou administrativo
```
```
122
```
```
Buffer contém a segunda via do comprovante de pagamento (via do caixa) a ser impresso na
impressora fiscal. Pode ser um comprovante de venda ou administrativo
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_39_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

###### 123

```
Indica que os comprovantes que serão entregues na sequência são de determinado tipo:
```
- COMPROVANTE_COMPRAS = "00"
    - COMPROVANTE_VOUCHER = "01"
       - COMPROVANTE_CHEQUE = "02"
- COMPROVANTE_PAGAMENTO = "03"
- COMPROVANTE_GERENCIAL = "04"
- COMPROVANTE_CB = "05"
- COMPROVANTE_RECARGA_CELULAR = "06"
- COMPROVANTE_RECARGA_BONUS = "07"
- COMPROVANTE_RECARGA_PRESENTE = "08"
- COMPROVANTE_RECARGA_SP_TRANS = "09"
- COMPROVANTE_MEDICAMENTOS = "10"
125 Código do Voucher

###### 130

```
Indica, na coleta, que o campo em questão é o valor do troco em dinheiro a ser devolvido para o
cliente. Na devolução de resultado (Comando = 0) contém o valor efetivamente aprovado para o
troco
```
```
131 Contém um índice que indica qual a instituição que irá processar a transação segundo a tabela
presente no final do documento (até 5 dígitos significativos)
```
```
132
```
```
Contém um índice que indica qual o tipo do cartão quando esse tipo for identificável, segundo uma
tabela a ser fornecida (5 posições)
133 Contém o NSU do SiTef (6 posições)
134 Contém o NSU do Host autorizador (20 posições no máximo)
135 Contém o Código de Autorização para as transações de crédito (15 posições no máximo)
136 Contém as 6 primeiras posições do cartão (bin)
137 Saldo a pagar
138 Valor Total Recebido
139 Valor da Entrada
140 Data da primeira parcela no formato ddmmaaaa
143 Valor gorjeta
144 Valor devolução
145 Valor de pagamento
```
###### 146

```
A rotina está sendo chamada para ler o Valor a ser cancelado. Caso o aplicativo de automação
possua esse valor, pode apresentá-lo para o operador e permitir que ele confirme o valor antes de
passá-lo devolvê-lo para a rotina. Caso ele não possua esse valor, deve lê-lo.
147 Valor a ser cancelado
150 Contém a Trilha 1, quando disponível, obtida na função LeCartaoInterativo
151 Contém a Trilha 2, quando disponível, obtida na função LeCartaoInterativo
```
###### 153

```
Contém a senha do cliente capturada através da rotina LeSenhaInterativo e que deve ser passada a
lib de segurança da Software Express personalizada para o estabelecimento comercial de forma a
obter a senha aberta
154 Contém o novo valor de pagamento
155 Tipo cartão Bônus
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_40_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

```
156 Nome da instituição
157 Código de Estabelecimento
158 Código da Rede Autorizadora
160 Número do cupom original
```
###### 161

```
Número Identificador do Cupom do Pagamento
Trata-se de um contador (começando pelo valor 0) de pagamentos que ocorreram no cupom.
Exemplo: Se no Cupom ocorreram 6 pagamentos os valores retornados serão de [0] a [5].
170 Venda Parcelada Estabelecimento Habilitada
171 Número Mínimo de Parcelas – Parcelada Estabelecimento
172 Número Máximo de Parcelas – Parcelada Estabelecimento
173 Valor Mínimo Por Parcela – Parcelada Estabelecimento
174 Venda Parcelada Administradora Habilitada
175 Número Mínimo de Parcelas – Parcelada Administradora
176 Número Máximo de Parcelas – Parcelada Administradora
177 Indica que o campo é numérico (PBM)
178 Indica que o campo é alfanumérico (PBM)
200 Saldo disponível*, saldo do produto específico (escolar, vale transporte)
201 Saldo Bloqueado
```
###### 500

```
Indica que o campo em questão é o código do supervisor. A automação, pode, se desejado, validar
os dados coletados, deixando o fluxo da transação seguir normalmente caso seja um supervisor
aceitável
501 Tipo do Documento a ser consultado (0 – CPF, 1 – CGC)
502 Número do documento (CPF ou CGC)
504 Taxa de Serviço
505 Número de Parcelas
506 Data do Pré-datado no formato ddmmaaaa
507 Captura se a primeira parcela é a vista ou não (0 – Primeira a vista, 1 – caso contrário)
508 Intervalo em dias entre parcelas
509 Captura se é mês fechado (0) ou não (1)
510 Captura se é com (0) ou sem (1) garantia no pré-datado com cartão de débito
511 Número de Parcelas CDC
512 Número do Cartão de Crédito Digitado
513 Data de vencimento do Cartão
514 Código de segurança do Cartão
515 Data da transação a ser cancelada (DDMMAAAA) ou a ser re-impressa
516 Número do documento a ser cancelado ou a ser re-impresso
```
```
517
```
```
A rotina está sendo chamada para ler o Número do cheque segundo o descrito no tipo de comando
correspondente ao valor 31
518 Código do Item
519 Código do Plano de Pagamento
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_41_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

```
520 NSU do SiTef Original (Cisa)
521 Número do documento de identidade (RG)
522 A rotina está sendo chamada para ler o Número do Telefone
523 A rotina está sendo chamada para ler o DDD de um telefone com até 4 dígitos
524 Valor da primeira parcela
525 Valor das demais parcelas
526 Quantidade de cheques
527 Data de vencimento do cheque
529 A rotina está sendo chamada para ler a Data de Abertura de Conta no formato (MMAAAA)
530 Autorização do supervisor digitada
531 Autorização do supervisor especial
532 A rotina está sendo chamada para ler a quantidade de parcelas ou cheques
533 Dados adicionais da venda
534 Emitente do cheque
535 O documento pago pela transação
536 Registros de retorno da consulta cheque CDL-Poa
537 Código de área da cidade do cheque
550 Endereço
551 Número do endereço
552 Andar do endereço
553 Conjunto do endereço
554 Bloco do endereço
555 CEP do endereço
556 Bairro do endereço
557 CPF para consulta AVS
558 Resultado da consulta AVS
559 Número de dias do pré-datado
560 Número de Ciclos
561 Código da Ocorrência
562 Código de Loja (EMS)
563 Código do PDV (EMS)
564 Dados Retornados (EMS)
565 Ramal do Telefone
566 Órgão Expedidor do RG
567 Estado onde foi emitido o RG
568 Data de expedição do RG
569 Matrícula do Operador
570 Nome do Operador
571 Matrícula do Conferente
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_42_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

```
572 Nome do Conferente
573 Percentual de Juros Aplicado
574 Matrícula do Autorizador
575 Data do Cupom Fiscal da Transação Original
576 Hora do Cupom Fiscal da Transação Original
577 Dados do Carnê ou código resumido EMS
578 Código de milhas diferenciadas 1
579 Valor das milhas diferenciadas 1
580 Código de milhas diferenciadas 2
581 Valor das milhas diferenciadas 2
582 Tipo de código externo EMS
583 Código externo EMS
587 Código nome da instituição autorizadora de celular
588 Código estabelecimento autorizador de celular
593 Digito(s) verificadores
594 Cep da localidade onde está o terminal no qual a operação está sendo feita
595 Obsoleto. Nsu do SiTef correspondente a transação de pagamento da Recarga com cartão
```
```
596 Obsoleto. Nsu do Host Autorizador correspondente a transação de pagamento da Recarga com
cartão
597 Código da Filial que atendeu a solicitação de recarga do celular
599 Código da rede autorizadora da recarga de celular
600 Data de vencimento do título/convênio no formato DDMMAAAA
601 Valor Pago*
602 Valor Original
603 Valor Acréscimo
604 Valor do Abatimento
605 Data Contábil do Pagamento
```
```
606
```
```
Nome do Cedente do Titulo. Deve ser impresso no cheque quando o pagamento for feito via essa
modalidade
607 Índice do documento, no caso do pagamento em lote, dos campos 600 a 604 que virão em seguida
```
```
608 Modalidade de pagamento utilizada na função de correspondente bancário. Segue a mesma regra
de formatação que o campo de número 100
609 Valor total dos títulos efetivamente pagos no caso de pagamento em lote
610 Valor total dos títulos não pagos no caso de pagamento em lote
611 NSU Correspondente Bancário
612 Tipo do documento: 0 - Arrecadação, 1 - Titulo (Ficha de compensação), 2 - Tributo
```
###### 613

```
Contém os dados do cheque utilizado para efetuar o pagamento das contas no seguinte formato:
Compensação (3), Banco (3), Agencia (4), Conta Corrente (10), e Numero do Cheque (6), nesta
ordem. Notar que a ordem é a mesma presente na linha superior do cheque sem os dígitos
verificadores
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_43_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

```
614 NSU SiTef transação de pagamento
620 NSU SiTef da transação original (transação de cancelamento)
621 NSU Correspondente Bancário da transação original (transação de cancelamento)
622 Valor do Benefício
623 Código impresso no rodapé do comprovante do CB e utilizado para re-impressão/cancelamento
```
```
624
```
```
Código em barras pago. Aparece uma vez para cada índice de documento (campo 607). O formato é
o mesmo utilizado para entrada do campo ou seja, 0:numero ou 1:numero
625 Recibo de retirada
626 Número do banco
627 Agência
628 Dígito da agência
629 Conta
630 Dígito da conta
631 Valor em dinheiro
632 Valor em cheque
633 Nome do depositante
634 Documento original de Correspondente Bancário
635 Chave do usuário utilizada para comunicação com o Banco
636 Seqüencial único da chave do usuário no Banco
637 Código da Agência de relacionamento da loja do correspondente
638 Número do Cheque CB
639 Número da Fatura
640 Número do Convênio
641 Data Inicial do Extrato (DDMMAAAA)
642 Data Final do Extrato (DDMMAAAA)
643 Período de Apuração
644 Código da Receita Federal
645 Valor da Receita Bruta
646 Percentual Aplicado
647 Valor Principal
648 Valor Multa
649 Valor Juros
670 Dado do PinPad
700 Operadora de ValeGás
701 Produto ValeGás
702 Número do ValeGás
703 Número de Referência
704 Código GPS
705 Competência GPS
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_44_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

```
706 Identificador Contribuinte
707 Valor INSS
708 Valor Outras Entidades
709 Permite Pagamento de Contas Com Dinheiro (0 – Não Permite; 1 – Permite)
710 Permite Pagamento de Contas Com Cheque (0 – Não Permite; 1 – Permite)
711 Permite Pagamento de Contas Com TEF Débito (0 – Não Permite; 1 – Permite)
712 Permite Pagamento de Contas Com TEF Crédito (0 – Não Permite; 1 – Permite)
713 Formas de Pagamento utilizadas na transação de Pagamento genérico
714 Valor do Saque
715 Numero do Pedido
716 Valor Limite do Depósito CB
717 Valor Limite do Saque CB
718 Valor Limite do Saque para Pagamento CB
719 Valor do produto ValeGás
722 Valor mínimo de pagamento
723 Identificação do Cliente, apenas para recebimento Carrefour
724 Venda Crédito Parcelada com Plano Habilitada
725 Venda Crédito com Autorização a Vista Habilitada
726 Venda Crédito com Autorização Parcela com Plano Habilitada
727 Venda Boleto Habilitada
729 Valor máximo de pagamento
730 Número Máximo de Formas de Pagamento, 0 para sem limite
```
###### 731

```
Tipo de Pagamento Habilitado, repete “n” vezes, onde “n” é o número de formas de pagamento
habilitadas:
```
- 00 Dinheiro
    - 01 Cheque
- 02 TEF Débito
- 03 TEF Crédito
- 04 Cartão Presente (Pré-Pago) Carrefour
- 05 Cartão Bônus Carrefour
- 06 Cartão Carrefour
- 07 Saque para pagamento
- 08 Saque
- 09 DCC Carrefour
- 50 TEF Cartão
- 77 Campo Reservado


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_45_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

###### 732

```
Dados a serem enviados para o Tipo de Pagamento (Campo 730 ) retornado anteriormente, repete
“n” vezes, onde “n” é o número de dados a serem enviados para o respectivo Tipo de Pagamento:
```
- 00 Campo Reservado
- 01 Tipo de Entrada do Cheque
- 02 Dados do Cheque
- 03 Rede Destino
- 04 NSU do SiTef da transação de TEF
- 05 Data do SiTef da transação de TEF (não utilizado, uso futuro)
- 06 Código da Empresa (Loja) da transação de TEF
- 07 NSU do Host da transação de TEF
- 08 Data do Host da transação de TEF (Campo 105 CliSiTef)
- 09 Código de Origem (Estabelecimento) da transação de TEF
- 10 Serviço Z da transação de TEF
- 11 Código de Autorização da transação de TEF
- 12 Valor do Cheque

```
734
```
```
Limite mínimo de venda para promoções flexíveis, com 12 dígitos sendo os 2 últimos dígitos
referentes as casas decimais
738 Valor sugerido para o produto selecionado.
739 Cliente Preferencial
750 Valor Pague Fácil CB
751 Valor Tarifa Pague Fácil CB
de 800 a
849
```
```
Toda a faixa de 800 a 849 está reservada para retorno dos GerPdv
```
```
950 CNPJ Credenciadora NFCE
951 Bandeira NFCE
952 Número de autorização NFCE
953 Código Credenciadora SAT
1002 Data de Validade do Cartão
1003 Nome do Portador do Cartão
1010 Quantidade de medicamentos - PBM
1011 Índice do medicamento – PBM
1012 Código do medicamento – PBM
1013 Quantidade autorizada – PBM
1014 Preço máximo ao consumidor – PBM
1015 Preço recomendado ao consumidor – PBM
1016 Preço de venda na farmácia – PBM
1017 Valor de reembolso na farmácia – PBM
1018 Valor reposição na farmácia – PBM
1019 Valor subsídio do convênio – PBM
1020 CNPJ convênio – PBM
1021 Código do plano do desconto – PBM
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_46_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

```
1022 Possui receita médica – PBM
1023 CRM – PBM
1024 UF – PBM
1025 Descrição do produto* - PBM
1026 Código do produto – PBM
1027 Quantidade do produto – PBM
1028 Valor do produto – PBM
1029 Data da receita médica - PBM
1030 Código de autorização PBM
1031 Quantidade estornada – PBM
1032 Código de estorno PBM
1033 Preço recomendado consumidor a vista – PBM
1034 Preço recomendado consumido para desconto em folha – PBM
1035 Percentual de reposição da farmácia – PBM
1036 Comissão de reposição – PBM
1037 Tipo de Autorização – PBM
1038 Código do conveniado – PBM
1039 Nome do conveniado – PBM
```
```
1040
```
```
Tipo de Medicamento PBM (01–Medicamento, 02-Manipulação, 03-Manipulação Especial, 04-
Perfumaria)
1041 Descrição do Medicamento – PBM
```
```
1042
```
```
Condição p/venda: Se 0 obrigatório utilizar preço Funcional Card (PF)
Se 1 pode vender por preço inferior ao preço PF
1043 Preço funcional card
1044 Preço praticado – PBM
1045 Status do medicamento – PBM
1046 Quantidade receitada – PBM
1047 Referência – PBM
1048 Indicador da venda PBM (0-Produto venda cartão 1-Produto venda a vista)
1051 Data de nascimento
1052 Nome da mãe
1058 Dados adicionais – ACSP
1100 Registro analítico CHECKCHECK
1101 Registro analítico ACSP
1102 Registro analítico SERASA
1103 Imagem tela analítica ACSP
1104 Imagem tela analítica SERASA
1105 Motivo do cancelamento – ACSP
1106 Tipo de consulta – ACSP
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_47_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

```
1107 CNPJ Empresa Conveniada
1108 Código da administradora
1109 Dados tabela Telecheque - ACSP
1110 Matrícula do motorista – Cartão Combustível
1111 Placa do veículo – Cartão Combustível
1112 Quilometragem – Cartão Combustível
1113 Quantidade de litros – Cartão Combustível
1114 Combustível principal – Cartão Combustível
1115 Produtos de combustível – Cartão Combustível
1116 Código Produto Host – Cartão Combustível
1117 Horímetro – Cartão Combustível
1118 Linha de Crédito – Cartão Combustível
1119 Tipo de Mercadoria – Cartão Combustível
1120 Ramo – Cartão Combustível
1121 Casas decimais de preços unitários – Cartão Combustível
1122 Quantidade máxima de produtos à venda
1123 Tamanho do código do Produto – Cartão Combustível
1124 Código do veículo – Cartão Combustível
1125 Nome da Empresa – Cartão Combustível
1126 Casas decimais da quantidade – Cartão Combustível
1128 Lista de Perguntas – Cartão Combustível
1129 Permite Coleta de Produto – Cartão Combustível
1131 Código do Limite
1132 Quantidade de Titulares
1133 Data de Abertura da Empresa (DDMMAAAA)
1134 Nome do Titular
1135 Complemento do Endereço
1136 Cidade
1137 Estado
1152 Menu de Valores - SPTrans
1160 Produto com Valor de Face – Gift
1190 Embosso (4 últimos dígitos) do Cartão
1200 Total de consultas anteriores
```
```
1201
```
```
Valor acumulado das consultas anteriores, contendo 2 dígitos decimais porém sem o caractere
decimal.
1202 Total de consultas efetuadas no dia.
1203 Valor acumulado das consultas no dia, contendo 2 dígitos decimais porém sem o caractere decimal.
1204 Total de consultas de cheques pré-datados realizados no período.
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_48_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

```
1205
```
```
Valor acumulado de cheques pré-datados, contendo 2 dígitos decimais porém sem o caractere
decimal.
1206 Vendedor (Usuário) - PBM
1207 Senha – PBM
1208 Código de Retorno – PBM
1209 Origem – PBM
1321 NSU do Host Autorizador da Transação Cancelada
2006 Tipo de criptografia
2007 Índice MasterKey
2008 Chave de criptografia
2009 Senha do cartão
2010 Código de resposta do autorizador
2011 Bin da rede
2012 Número serial do CHIP
2013 Registro de controle do CHIP
2014 Saldo comum, saldo do passe comum
2015 PAN do cartão presente
2017 Data primeiro vencimento
2018 Valor total
2019 Valor financiado
2020 Percentual multa
2047 Juros de mora
2048 TAC (Taxa de administração)
2053 Menu (produto) selecionado Visanet
2054 Tipo Crédito CDC (1 – CDC Produto; 2 – CDC Serviço)
2055 Data/Hora Sitef (Local)
2056 Dia da semana Sitef (Local)
2057 Data/Hora Sitef (GMT)
2058 Dia da Semana Sitef (GMT)
2059 Dados da Forma de Pagamento - SPTrans
2064 Valor pagamento em dinheiro
2065 Código consulta cheque (Genérica EMS)
2067 Mensagem do autorizador a ser exibida junto com o menu de valores (Se o terminal permitir)
2078 Código do serviço
2079 Valor do serviço
2081 Menu de Produtos
2082 Nosso número
2083 Valor total do produto contendo o separador decimal (“,”) e duas casas decimais após a vírgula.
2086 Código do Produto - ValeGas
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_49_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

```
2087 Demonstrativo de prazos : 0: Não; 1: Sim
2088 Cancelamento Total/Parcial : 0: Parcial; 1: Total
2089 Número de identificação da fatura.
```
###### 2090

```
Tipo do cartão Lido:
```
- 00 – Magnético (Cartões magnéticos tradicionais e Samsung Pay no modo “MST – Magnetic
    Secure Transmission”)
- 01 - Moedeiro VISA Cash sobre TIBC v1
- 02 - Moedeiro VISA Cash sobre TIBC v3
- 03 - EMV com contato
- 04 - Easy-Entry sobre TIBC v1
- 05 - Chip sem contato simulando tarja
- 06 - EMV sem contato (Cartões tradicionais, adesivos e pulseiras sem contato, além das
soluções mobile tais como Apple Pay, Google Pay, Samsung Pay no modo “NFC – Near Field
Communication”, entre outros)
- 99 – Digitado

###### 2091

```
Status da última leitura do cartão
```
- 0 - Sucesso.
- 1 - Erro passível de fallback.
- 2 - Aplicação requerida não suportada.
2093 Código do atendente
2103 Indica se foi transação offline : 1 : Sim
2109 Senha temporária
2124 Valor da tarifa da Recarga de Celular (via Correspondente Bancário. Exemplo: CB Bradesco)
2125 Número da parcela (2 caracteres) (Hotcard)
2126 Seqüencial da transação (6 caracteres) (Hotcard)
2301 Rodapé do comprovante da via estabelecimento
2320 Código do Depositante – CB
2321 Código do Cliente
2322 Sequencia Cartão – CB
2323 Via Cartão - CB
2324 Tipo do Extrato – CB
2325 Valor limite de Transferência - CB
2326 Valor limite para coleta de CPF/CNPJ – CB
2327 CPF/CNPJ do Proprietário – CB
2328 CPF/CNPJ do Portador – CB
2329 Tipo do documento do Proprietário - CB
2330 Tipo do documento do Portador - CB
2331 Indica se permite pagamento com cartão CB
2332 Valor da Transferência
2333 Identificação da transação
2334 Pin Code


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_50_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

###### 2355

```
Quando retornado, atua como uma “dica” para o formato do próximo campo que será coletado.
Normalmente é acompanhado do comando zero (0 – retorno de valor para uso pela automação).
Assume os seguintes valores:
```
- A Alfabético
- AN Alfanumérico (ans)
- LN Letras não acentuadas e números
- N Numérico
- Vx Valor com x casas decimais
- S Sim/Não
- M Menu
- Mc Menu com confirmação

```
Não é um campo que é retornado em todas as coletas de campo, somente em situações que devem
ser tratadas no documento específico de cada rede.
2361 Indica que foi efetuada uma transação de débito para pagamento de carnê
```
###### 2362

```
Retornado logo após a transação de consulta de bins. O valor 1 indica que o autorizador é capaz de
tratar de forma diferenciada transação de débito convencional de débito para pagamento de
contas.
2363 Indica que foi efetuada uma transação de crédito para pagamento de carnê
```
###### 2364

```
Retornado logo após a transação de consulta de bins. O valor 1 indica que o autorizador é capaz de
tratar de forma diferenciada transação de crédito convencional de crédito para pagamento de
contas.
2369 Pontos a resgatar (numérico sem casa decimal).
2421 Informa se está habilitada a função de coleta de dados adicionais do cliente (0 ou 1)
2467 Data no Formato DDMMAA Confirmação Positiva
2468 Data no Formato DDMM Confirmação Positiva
2469 Data no Formato MMAA Confirmação Positiva
2470 Campo com Ponto Flutuante
2601 Mensagem para pinpad
2602 Semente Hash
2603 Modalidade para leitura de cartão através da função 431.
2699 Envia informação adicional de Ativação/Recarga GIFT, retornada pelo host SQCF, para a Automação
2925 Valor de Recarga de Cartão de Crédito
2965 Valor de Recarga de Cartão de Débito
2974 Venda Parcelada via Crediário Habilitada
2975 Número mínimo de parcelas para crediário
2976 Número máximo de parcelas para crediário
3481 Menu (gerencial ) Consulta AVS
3988 Menu Crediário
3989 Menu Simulação Crediário
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_51_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

```
4000 Status da Pré-Autorização – PBM
4001 CRF – PBM
4002 UF do CRF – PBM
4003 Tipo de venda – PBM
4004 Valor total PBM
4005 Valor a vista PBM
4006 Valor cartão PBM
4007 Nosso número PBM
4008 Percentual de desconto concedido pela administradora (2 casas decimais)
4016 Preço bruto – PBM
4017 Preço líquido – PBM
4018 Valor a receber da Loja, em centavos – PBM
4019 Número do lote gerado pela Central – PBM
4020 Valor total a receber da loja – PBM
4021 Valor total a receber da loja – PBM
4022 Soma dos valores da Operação – PBM
4023 Nome da operadora – PBM
4024 Nome da empresa conveniada – PBM
4025 Quantidade de dependentes – PBM
4026 Código do dependente – PBM
4027 Nome do dependente – PBM
4028 Valor a receber do conveniado – PBM
4029 Valor do desconto total, em centavos
4030 Valor líquido total, em centavos - PBM
```
```
4031
```
```
Código da Operadora Selecionada PBM (deverá ser gravado para posterior envio nas demais
transações)
4032 Campo de retorno de dados livres referentes às transações PBM.
4033 Tipo de documento PBM (0 = CRM, 1 = CRO)
4034 Dados do Resgate - Bônus
4039 Código Resposta PBM (0 = Ok, <>0 = erro)
4040 Produto Fracionado PBM (0 = não, 1 = sim)
4041 Paciente ID PBM (-1 = outros, 00 = titular, 01 = dependente)
4043 Receita ID PBM (receita cadastrada pela empresa)
4044 Receita item ID PBM (item da receita cadastrada pela empresa)
4045 Receita uso contínuo (0 = não, 1 = sim)
4046 Produto Manipulado PBM (princípios ativos)
4047 Produto Manipulado PBM Valor Original
4058 Valor do Produto Aprovado com Desconto
4076 Identificação da Loja
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_52_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**TipoCampo Descrição**

```
4077 Contém o NSU do FEPAS (20 posições no máximo)
4095 CPF/CNPJ do Beneficiario
4096 CPF/CNPJ do Sacador
4097 CPF/CNPJ do Pagador
```
###### 4100

```
Erro de comunicação (por exemplo: timeout) No Buffer contém o código do Erro.
Exemplos:
[TCP:R:10054] Foi forçado o cancelamento de uma conexão existente pelo host remoto.
[TCP:C:10060:TO] Uma tentativa de conexão falhou porque o componente conectado não
respondeu corretamente após um período de tempo
ou a conexão estabelecida falhou porque o host conectado não respondeu.
4125 Cupom Cliente disponível, para reimpressão ou consulta, na base de dados do SiTef
4126 Cupom Estabelecimento disponível, para reimpressão ou consulta, na base de dados do SiTef
4127 Quantidade de dias que os cupons estarão disponíveis na base de dados do SiTef
```
###### 4221

```
Flag para informar se o cartão é pré-pago (mandate BACEN).
```
```
Valores possíveis:
```
- 1: cartão foi identificado pelo autorizador como pré-pago
- 0: cartão não foi identificado pelo autorizador como pré-pago
- Campo (4221) ausente: autorizador não devolveu nenhuma informação sobre o cartão ser
    pré-pago ou não.

```
Observação : a princípio o campo será retornado com valor 1 (autorizador identificou o cartão como
pré-pago) ou não será retornado (campo 4221 ausente). O valor 0 está sendo previsto para caso o
autorizador possa retornar a informação afirmando que o cartão não é pré-pago.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 53 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
##### 5.3.3 Tabela de Eventos, retornados também em TipoCampo

```
Durante a transação, a CliSiTef pode informar a ocorrência de determinados eventos.
```
Estes eventos são retornados no parâmetro _TipoCampo_ da rotina _ContinuaFuncaoSiTefInterativo_ ou
_ContinuaFuncaoSiTefInterativoA_ , conforme a tabela abaixo.

```
TipoCampo Descrição
5000 Indica que a biblioteca está aguardando a leitura de um cartão
5001 Indica que a biblioteca está esperando a digitação da senha pelo usuário
```
```
5002
```
```
Indica que a biblioteca está esperando a digitação dos dados de confirmação positiva pelo
usuário
5003 Indica que a biblioteca está aguardando a leitura do bilhete único
5004 Indica que a biblioteca está aguardando a remoção do bilhete único
5005 Indica que a transação foi finalizada
5006 Confirma Dados Favorecido
5007 SiTef Conectado
5008 SiTef Conectando
5009 Consulta OK
5010 Colher Assinatura
5011 Coleta Novo Produto
5012 Confirma Operação
5013 Confirma Cancelamento
5014 Confirma Valor Total
5015 Conclusão de Recarga de Bilhete Único
5016 Reservado
5017 Aguardando leitura de cartão
5018 Aguardando digitação da senha no PinPad
5019 Aguardando processamento do chip
5020 Aguardando remoção do cartão
5021 Aguardando confirmação da operação
```
```
5027 Cancelamento da leitura do cartão
5028 Cancelamento da digitação da senha no PinPad
5029 Cancelamento do processamento do cartão com CHIP
5030 Cancelamento da remoção do cartão
5031 Cancelamento da confirmação da operação
```
```
5036 Antes da leitura do cartão magnético
5037 Antes da leitura do cartão com CHIP
5038 Antes da remoção do cartão com CHIP
5039 Antes da coleta da senha no pinpad
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_54_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
5040 Antes de abrir a comunicação com o PinPad
5041 Antes de fechar a comunicação com o PinPad
5042 Deve bloquear recursos para o PinPad
5043 Deve liberar recursos para o PinPad
5044 Depois de abrir a comunicação com o PinPad
5049 Timeout com o SiTef
```
```
5050
```
```
Atualização de tabelas para transações offlines.
O conteúdo deste campo varia de acordo com a transação sendo realizada.
```
```
5051 Indica que coletou senha no pinpad.
5052 Indica que processou cartão com chip (GoOnChip)
5053 Indica que removeu cartão com chip da leitora do pinpad
5054 Indica que efetuou entrega de dados sensíveis(Específico para POS PAX)
```
```
5055
```
```
Indica que está atualizando tabelas no pinpad(Evento retornado a cada registro enviado ao
pinpad)
5056 Indica que está enviando arquivos para o Sitef
5057 Indica inicio do envio de campos com dados sensíveis.
5058 Indica fim do envio de campos com dados sensíveis
5059 Indica que está aguardando leitura de cartão (Modalidade 29)
5060 Reservado
5061 Reservado
5062 Indica inicio do envio de campos relacionados a produtos(combustíveis, medicamentos, etc)
5063 Indica Fim do envio de campos relacionados a produtos(combustíveis, medicamentos, etc)
5074 Indica que deve ser obtida assinatura em papel num pagamento com cartão com chip
5501 Início de uma transação do tipo Correspondente Bancário.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 55 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 5.4 Confirmação ou não do Pagamento

Rotina chamada pelo aplicativo para fechar o ciclo transacional. Ela deve ser acionada no momento que o
comprovante Fiscal for fechado e recebe como parâmetros um indicador de se a transação foi concretizada ou se
deve ser estornada. Recebe também os campos que permitem identificar a transação que está sendo finalizada.

Esta função também deve ser utilizada para desfazer uma transação interrompida por uma queda de energia ou
qualquer outro problema no aplicativo.

Essa rotina confirma ou cancela **TODOS** os pagamentos vinculados ao mesmo Número do Cupom Fiscal e mesma
Data Fiscal passados como parâmetro.

void FinalizaFuncaoSiTefInterativo (Confirma, CupomFiscal, DataFiscal,
HoraFiscal, ParamAdic);

```
Interface ASCII
```
void FinalizaFuncaoSiTefInterativoA (Confirma, CupomFiscal, DataFiscal,
HoraFiscal, ParamAdic);

```
Parâmetro Tipo
```
```
Interface
```
```
padrão
```
```
Interface
```
```
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
```
```
por valor
```
```
Não
usado
```
```
Fixo 6 Contém o resultado de resposta à chamada da rotina.
```
```
Confirma
```
```
Entrada,
```
```
por valor
```
```
short Fixo 1
```
```
Indica se a transação deve ser confirmada (1) ou estornada
(0)
```
```
CupomFiscal
```
```
Entrada,
```
```
por valor
```
```
char * Máx. 20 Número do Cupom Fiscal correspondente à venda
```
```
DataFiscal
```
```
Entrada,
```
```
por valor
```
```
char * Fixo 8 Data Fiscal no formato AAAAMMDD
```
```
HoraFiscal
```
```
Entrada,
```
```
por valor
```
char * Fixo 6 (^) Horário Fiscal no formato HHMMSS (^6)
ParamAdic
Entrada,
por valor
char * Variável
Parâmetros adicionais, descritos abaixo. Se não usado,
automação deve passar vazio/NULL.
Exemplo: Uma venda realizada pela função _IniciaFuncaoSiTefInterativo_ , passando como parâmetros _Funcao_ **0** ,
_Valor_ **10,00** , _Cupom Fiscal_ **12345** , _Data Fiscal_ **20150101** , _Hora Fiscal_ **121500**. Na confirmação da transação, a função
(^6) O parâmetro HoraFiscal não é usado como “chave” para um documento fiscal.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 56 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
_FinalizaFuncaoSiTefInterativo_ deve ser chamada utilizando os seguintes parâmetros: _Confirma_ **1** , _Cupom Fiscal_
**12345** , _Data Fiscal_ **20150101** , _Hora Fiscal_ **121500** , _ParamAdic_ como vazio/NULL, já que não há dados adicionais.

```
O parâmetro ParamAdic pode ser usado nas situações abaixo:
```
##### 5.4.1 Finalização de pagamentos individuais em um mesmo cupom fiscal

Para cada pagamento, a CliSiTef retorna no _TipoCampo_ **161** (Número do pagamento no cupom) um
índice/contador correspondente ao pagamento.

Para fazer a (não-) confirmação de um pagamento específico dentro de um cupom fiscal, a automação deve
informar este valor à rotina _FinalizaFuncaoSiTefInterativo_ como um parâmetro adicional:

```
{NumeroPagamentoCupom= XXX }
```
```
onde XXX é o número do pagamento, retornado anteriormente no TipoCampo 161.
```
##### 5.4.2 Finalização de pagamentos de uma determinada rede em um mesmo cupom fiscal

Para fazer a (não) confirmação de pagamentos referentes a uma determinada rede autorizadora, deve-se passar
na rotina _FinalizaFuncaoSiTefInterativo_ o seguinte parâmetro adicional:

```
{RedeConfirmacao= XXX }
```
```
onde XXX é o número da rede autorizadora.
```
##### 5.4.3 Anexar dados referentes às formas de pagamento de uma transação (NFPAG)

Para anexar dados referentes às formas de pagamento de uma transação, devem-se capturar os campos: **161**
(Número do pagamento no cupom), **730** (Número máximo de formas de pagamento), **731** (Tipos de pagamento
habilitados) e **732** (Dados a serem coletados para o tipo de pagamento), retornados no fluxo da transação, e
repassá-lo à rotina _FinalizaFuncaoSiTefInterativo_ através dos parâmetros adicionais NumeroPagamentoNFPAG e
NFPAG.

```
{NumeroPagamentoNFPAG= X }{NFPAG= Y }
```
```
Onde:
```
```
X = Número do pagamento no cupom (Campo 161 )
```
```
Y = Dados referentes às formas de pagamento (Ver descrição abaixo)
```
Observação: Neste caso, todos os pagamentos em um mesmo cupom fiscal serão todos confirmados ou não
confirmados.

```
Descrição do parâmetro NFPAG:
```
```
{NFPAG=FPAG1;FPAG2; FPAG3;...;FPAGn;}
```
```
Onde FPAGn tem o seguinte conteúdo:
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 57 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Se houver dados a serem coletados
TipoN:ValorN:IDColetaN1:DadoColetaN1-IDColetaN2:DadoColetaN2-...-IDColetaNn:DadoColetaNn
Se não houver dados a serem coletados
TipoN:ValorN
```
```
=> TipoN : indica a forma de pagamento utilizada (Campo 731 , conforme tabela abaixo)
```
```
=> ValorN : indica o valor utilizado com esta forma de pagamento, com duas casas decimais, sem a vírgula
```
```
=> IDColetaNn : indica o ID do campo que foi coletado pelo PDV (Campo 732 , conforme tabela abaixo)
```
```
=> DadoColetaNn : indica o conteúdo coletado pelo PDV para este campo
```
Observação: A consistência dos valores (soma das várias formas de pagamento utilizadas, totalizando o valor da
transação realizada) deve ser feita pelo PDV.

```
Exemplo:
```
Ao final de uma transação no valor de R$ 50,00, retornando o campo **730** igual a **2** e os campos **731** e **732**
indicando que aceita as seguintes formas de pagamento: Dinheiro (sem dados a serem coletados); TEF Débito
(precisa enviar a Rede Destino, o NSU do Host, a Data do Host e o Código de Origem da transação de TEF) e TEF
Crédito. O campo **730** igual a **2** , indica que no parâmetro NFPAG podem ser enviados no máximo 2 formas de
pagamento.

O PDV, por sua vez, na confirmação da transação, enviará as formas de pagamento que foram efetivamente
utilizadas: R$ 30,00 foram pagos em dinheiro e R$ 20,00 foram pagos com cartão de débito da Redecard (Rede
Destino = 5; NSU do Host = 123456789; Data do Host = 15/12/2008; Código de Origem = 000000000000001).

```
{NFPAG=00:3000;02:2000:03:5-07:123456789-08:15122008-09:000000000000001;}
```
Observação: Todas as formas de pagamento devem ser separadas por ; (ponto-e-vírgula), inclusive o último deve
ser finalizado por ;

```
730 Número máximo de formas de pagamento a ser enviado através do parâmetro NFPAG. 0 para sem
limite.
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_58_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
731 Tipo de Pagamento Habilitado, repete “n” vezes, onde “n” é o número de formas de pagamento
habilitadas:
```
- 00: Dinheiro
- 01: Cheque
- 02: TEF Débito
- 03: TEF Crédito
- 04: Cartão Presente (Pré-Pago) Carrefour
- 05: Cartão Bônus Carrefour
- 06: Cartão Carrefour
- 07: Saque para pagamento
- 08: Saque
- 09: DCC Carrefour
- 10: Ticket Eletrônico
- 11: Ticket Papel
- 12: Carteira Digital
- 13: Pix
- 50: TEF Cartão
- 77: Campo Reservado
- 98: Sem Pagamento
- 99: Outras Formas


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_59_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
732 Dados a serem enviados para o Tipo de Pagamento (Campo 731 ) retornado anteriormente,
repete “n” vezes, onde “n” é o número de dados a serem enviados para o respectivo Tipo de
Pagamento:
```
- **00** : Campo Reservado
- **01** : Tipo de Entrada do Cheque
    o ‘0’: leitura de CMC- 7
    o ‘1’: digitação da primeira linha do cheque
    o ‘2’: digitação do CMC- 7
- **02** : Dados do Cheque
    o CMC-7 lido ou digitado, ou
    o Digitação da primeira linha do cheque, com o seguinte formato:
       Compensação (3), Banco (3), Agência (4), C1 (1), Conta Corrente (10), C2 (1),
       Número do Cheque (6) e C3 (1), nesta ordem.
- **03** : Rede Destino (Campo 131)
    Identificação do autorizador da transação de TEF.
- **04** : NSU do SiTef da transação de TEF (Campo 133)
    Identificação da transação de TEF no SiTef.
- **05** : Data do SiTef da transação de TEF
    Não utilizado (Uso futuro).
- **06** : Código da Empresa da transação de TEF
    Código do SiTef para a Empresa utilizada na transação de TEF.
- **07** : NSU do Host da transação de TEF (Campo 134)
    Identificação da transação de TEF no Host.
- **08** : Data do Host da transação de TEF (Campo 105)
    Data da transação de TEF no Host, no formato DDMMAAAA.
- **09** : Código de Origem da transação de TEF (Campo 157)
    Código de Estabelecimento da transação de TEF.
- **10** : Serviço Z da transação de TEF (Campo 1)
    Valor do serviço Z devolvido pelo módulo Sit responsável pela transação de TEF.
o Passar apenas o dados de confirmação, retirando os dados do índice do SiTef e endereço
do SiTef caso existam, segue o formato desse campo:
DadosConfirmação;IndiceSiTef;EnderecoSiTef

```
Outra opção seria utilizar a seguinte configuração no arquivo CliSiTef.ini:
[Geral]
DevolveConfirmacaoExtendida=0
```
```
Usando esta configuração, mesmo no caso de múltiplos SiTef será retornado apenas o Serviço Z
no campo 1 da CliSiTef, dessa maneira também não é necessário alterar o valor do campo na hora
de colocar no prefixo NFPAG.
```
- **11** : Código de Autorização da transação de TEF (Campo 135)
    Código de Autorização do Host para a transação de TEF.
- **12** : Valor do Cheque
    Valor Total do Cheque. Um mesmo cheque pode ser usado para pagar mais de uma
    conta
- **13** : Rede Destino – Complemento
    Complemento do ID 03 (veja descrição abaixo)


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 60 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
- **14** : Bandeira do Cartão
    Bandeira do Cartão utilizado na transação de TEF
- **15** : Tipo de Pagamento
‘00’ – a vista
‘01’ – Pré-datado
‘02’ – Parcelado pelo estabelecimento
‘03’ - Parcelado pela administradora
- **16** : Id da Carteira Digital
    (retorna no campo 106 da Venda com Carteira Digital)

O campo de ID 13, diferente dos demais, não indica um campo que deve ser coletado, ele funciona apenas como
um complemento para o campo de ID 03, enviando a lista de Redes Destino permitidas, no seguinte formato:

```
IDColetaNn(Rede1,Rede2,...,RedeN)
```
Ou seja, caso apenas o campo de ID 03 esteja presente, deve ser coletada a Rede Destino, sem nenhuma
restrição quanto as Redes que podem pagar a Recarga. No entanto, caso estejam presentes os campos de ID 03 e
13, o primeiro indica que deve ser coletada a Rede Destino, enquanto o segundo indica quais as Redes Destino que
são permitidas para o pagamento da Recarga.

Além disso, como a coleta foi indicada pelo ID 03, o PDV deve enviar a Rede Destino ao Sit também por meio
deste ID (e não pelo ID 13).

#### 5.5 Consulta de transações pendentes de confirmação no terminal

Em caso de queda de energia, pode ocorrer situações em que a automação precise consultar transações que
estejam pendentes de confirmação. Isto é, transações que precisam ser confirmadas (ou não) via
_FinalizaFuncaoSiTefInterativo_.

##### 5.5.1 Quantidade de transações pendentes de confirmação no terminal

Esta função é utilizada pelo terminal para saber quantas transações foram realizadas em caso de queda de
energia e que estão pendentes de uma ação da automação, via chamada da função _FinalizaFuncaoSiTefInterativo_.

```
int ObtemQuantidadeTransacoesPendentes (DataFiscal, CupomFiscal)
```
```
Interface ASCII
```
```
ObtemQuantidadeTransacoesPendentesA (Resultado, DataFiscal, CupomFiscal)
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 61 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Resultado
```
```
Saída,
por valor
```
```
Não
usado
```
```
Fixo 6 Contém o resultado de resposta à chamada da rotina.
```
```
DataFiscal
```
```
Entrada,
por valor
```
```
char * Fixo 8 Data Fiscal no formato AAAAMMDD
```
```
CupomFiscal
```
```
Entrada,
por valor
```
```
char * Máx. 20 Número do Cupom Fiscal correspondente à venda
```
A rotina retorna a quantidade de transações pendentes para o documento fiscal informado, ou **- 13** caso não
tenha sido encontrado o documento fiscal.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 62 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
##### 5.5.2 Consulta a transações pendentes no terminal

```
É possível consultar todas as informações de pendências de confirmação do terminal.
```
Essa funcionalidade é iniciada através da função _IniciaFuncaoSiTefInterativo_ com o parâmetro Funcao (primeiro
parâmetro de entrada da rotina) assumindo o valor **130** e os demais parâmetros com seus valores usuais.

```
Em particular, esta função irá desconsiderar os parâmetros relativos ao documento fiscal.
```
**_IMPORTANTE_** : Essa rotina apenas inicia o processo de solicitação. Se o retorno for **10000** , o processo deve
prosseguir através da rotina _ContinuaFuncaoSiTefInterativo_ até que esta devolva um resultado final diferente de
**10000**.

```
Os campos a seguir serão retornados para a automação.
```
```
TipoCampo Descrição
210 Quantidade total de pendências, listadas nos blocos de dados abaixo
```
```
160 Cupom Fiscal
161 Número Identificador do Cupom do Pagamento
163 Data Fiscal
164 Hora Fiscal
211 Código da “Funcao” original
1319 Valor da transação original
```
##### 5.5.3 Consulta a transações pendentes em um documento fiscal específico

```
De forma análoga ao item anterior, é possível consultar os dados referentes a um único documento fiscal.
```
Para tanto, utilize a função _IniciaFuncaoSiTefInterativo_ passando no parâmetro Funcao o valor **131** e os demais
parâmetros com seus valores usuais. Neste caso, serão considerados os parâmetros relativos ao documento fiscal.

```
Os campos retornados são idênticos ao item anterior.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 63 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 5.6 Funções de PinPad

##### 5.6.1 Teste da presença de PinPad

É possível verificar a presença do dispositivo PinPad e se ele está operacional. Para tanto, são enviados
comandos lógicos de abertura e fechamento do canal de comunicação.

```
São duas as funções para esta finalidade.
```
```
A função original tem o seguinte formato:
```
```
int VerificaPresencaPinPad (void)
```
A partir da versão 4.0.114.4, foi criada uma segunda função, onde são enviados menos comandos para o pinpad,
e sem que o visor do pinpad ligue/desligue.

```
int KeepAlivePinPad (void)
```
```
Ambas rotinas não possuem parâmetros de entrada, e podem retornar os seguintes valores:
```
```
1 - Existe um PinPad operacional conectado ao micro;
```
```
0 - Não existe um PinPad conectado ao micro;
```
- 1 - biblioteca de acesso ao PinPad não encontrada;

```
outro número - erros detectados internamente pela rotina ou pela biblioteca de acesso ao PinPad
```
##### 5.6.2 Define mensagem permanente para o PinPad

Permite que seja definida uma mensagem permanente para ser apresentada no PinPad durante o tempo que
ele não está em uso. O formato de ativação da rotina é o seguinte:

```
int EscreveMensagemPermanentePinPad (Mensagem)
```
```
Interface ASCII
```
```
EscreveMensagemPermanentePinPadA (Resultado, Mensagem)
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por valor
```
```
Não
usado
```
```
Fixo 6 Contém o resultado de resposta à chamada da rotina.
```
```
Mensagem
```
```
Entrada,
por valor
```
```
char * Variável
```
```
Mensagem a ser apresentada no visor do PinPad.
Recomenda-se que ela possua no máximo 32 caracteres de
forma a ser compatível com os PinPad’s existente
atualmente em campo.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 64 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
Para apagar a mensagem e deixar o visor em branco, basta chamar essa função passando o campo _Mensagem_
vazio.

```
A aplicação, se desejar, pode incluir o caractere ‘|’ (Barra vertical) para indicar uma mudança de linha.
```
##### 5.6.3 Leitura da trilha 3 do cartão

```
Esta função permite que o aplicativo capture uma trilha 3 magnética genérica.
```
```
Note que o PinPad deve ter suporte para a leitura da trilha 3.
```
Não deve ser utilizada para tratamento das transações de pagamento mas apenas para leitura de cartões
internos do estabelecimento comercial (p/ex. cartão de supervisor). O formato de ativação é o seguinte:

```
int LeTrilha3 (Mensagem)
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por valor
```
```
Não
usado Fixo 6^ Contém o resultado de resposta à chamada da rotina.^
```
```
Mensagem
```
```
Entrada,
por valor
```
```
char * Variável Mensagem a ser apresentada no visor do PinPad.
```
No retorno, a rotina devolve os mesmos valores que a rotina de pagamento. O aplicativo obtém as trilhas através
da chamada a função de continuação do processo iterativo.

**IMPORTANTE** : Esta função **NÃO** pode ser utilizada durante a execução do laço
_ContinuaFuncaoSiTefInterativo_.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 65 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
##### 5.6.4 Leitura do cartão - rotinas de captura segura

```
Os rotinas seguintes têm seu funcionamento condicionado a dois pré-requisitos:
```
```
1) Configuração do arquivo de chaves .cha no servidor SiTef. Caso a configuração não esteja feita, essas
funções retornam o erro 12 (MODO SEGURO NÃO ATIVO).
2) Após a instalação do arquivo de chaves .cha no servidor SiTef , a Automação deve, pelo menos uma vez, se
comunicar com o servidor SiTef. Isto é necessário para que a estação PDV faça a baixa dos dados que
permitem a execução das rotinas de Leitura do cartão seguro). Para isso, execute um Teste de Comunicação
ou uma transação financeira.
```
```
int LeCartaoSeguro (Mensagem)
```
```
Interface ASCII
```
```
LeCartaoSeguroA (Resultado, Mensagem)
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por valor
```
```
Não
usado
```
```
Fixo 6 Contém o resultado de resposta à chamada da rotina.
```
```
Mensagem
```
```
Entrada,
por valor
```
```
char * Variável Mensagem a ser apresentada no visor do PinPad.
```
No retorno a rotina devolve os mesmos valores que a rotina de pagamento. O aplicativo obtém as trilhas através
da chamada a função de continuação do processo iterativo.

```
Os campos retornados no processo iterativo são os referentes aos campos sensíveis ( 2021 a 2046 ).
```
```
Observação:
```
Estas funções não estão disponíveis para ambientes Mobile. Devido a dificuldades de utilização de entrypoints
de funções, e visando facilitar a sua implementação, foi disponibilizada a “Função” 430 que é uma alternativa para
utilizar a função “ _LeCartaoSeguro_ ”.

Esta “Função” segue o fluxo de uma transação “Gerencial” e é acessada através de
IniciaFuncaoSiTefInterativo(Ver item “5.2 - Início da transação de Pagamento ou Gerencial”).

- Para utilização da “Função” 430, o parâmetro “Mensagem” a ser exibida no display do pinpad, será
solicitada à Automação Comercial no fluxo da transação através do comando 29 (Ver item “5.3.1 - Tabela de códigos
de Comando”). Caso não seja fornecida pela Automação, será exibida a mensagem default “PASSE O CARTAO”.
- Para leitura do cartão através da função 430, foi incluído o parâmetro adicional “SementeHash”(não
utilizada quando a função LeCartaoSeguro é chamada diretamente) que é opcional e será solicitado no fluxo da
transação. Se parâmetro “SementeHash” for utilizado, opcionalmente poderá ser fornecida através do parâmetro
“ParamAdic” na chamada da função _IniciaFuncaoSiTefInterativo_ , neste caso, não será solicitado no fluxo da
transação.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 66 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
Se solicitado no fluxo da transação através do comando 29 e o parâmetro não é utilizado, retornar o campo
vazio.

Caso este parâmetro seja utilizado, os dados retornados para a Automação Comercial serão hash geradas a
partir da semente informada (Campo tipo 203x. Ver tabela “Campos que podem ser retornados” abaixo).

```
Formato do parâmetro em “ParamAdic”:
```
```
{SementeHash=XX...XX}
```
```
Onde: XX...XX: Máximo 64 caracteres.
```
**IMPORTANTE** : Essas funções NÃO podem ser utilizadas durante a execução do laço
_ContinuaFuncaoSiTefInterativo_. Para esse tipo de situação existem as versões que fazem o acesso direto a leitora
de cartão descritas a seguir.

int LeCartaoDiretoSeguro (Mensagem, TipoCampoTrilha1, Trilha1, TipoCampoTrilha2,
Trilha2, Timeout, TestaCancelamento)

```
Interface ASCII
```
LeCartaoDiretoSeguroA (Resultado, Mensagem, TipoCampoTrilha1, Trilha1,
TipoCampoTrilha2, Trilha2, Timeout)

```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por valor
```
```
Não
usado Fixo 6^
```
```
Contém o resultado de resposta à chamada da
rotina.
```
```
Mensagem
```
```
Entrada,
por valor
```
```
char * Variável Mensagem a ser apresentada no visor do PinPad.
```
```
TipoCampoTrilha1
```
```
Saída,
por valor
```
```
char * Fixo 12
```
```
Indica o tipo de campo que foi retornado na trilha 1,
se ele é mascarado, criptografado ou em Hash.
```
```
Trilha1
```
```
Saída,
por valor
```
```
char * Máx. 128 No retorno contém, caso exista, a Trilha 1 lida
```
```
TipoCampoTrilha2
```
```
Saída,
por valor
```
```
char * Fixo 12
```
```
Indica o tipo de campo que foi retornado na trilha 2,
se ele é mascarado, criptografado ou em Hash.
```
```
Trilha2
```
```
Saída,
por valor
```
```
char * Máx. 80 No retorno contém, caso exista, a Trilha 2 lida
```
```
Timeout
```
```
Entrada,
por valor
```
```
short Fixo 6
```
```
Define o tempo máximo de espera pela passagem do
cartão em segundos. Se zero, espera até que o
cartão seja passado
```
```
TestaCancelamento
```
```
Entrada,
por valor
```
```
Rotina Não
usado
```
Rotina da aplicação de automação que retorna 0 se é
para continuar aguardando pelo cartão e 1 caso
deva interromper o processo de aguardar a
passagem do cartão
No retorno a rotina devolve o valor 0 (zero) caso tenha sido executada corretamente e um valor diferente de
zero em caso de erro ou interrupção.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 67 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Para esta rotina específica, os códigos de erro retornados são:
```
```
Valor Descrição
0 Não ocorreu erro
1 Campo de saída insuficiente
2 BIN NAO HABILITADO
3 CNPJ inválido
4 Chave de acesso vencida
5 Versão inválida
6 Chave de criptografia inválida
7 Dados não criptografados com a chave fornecida como parâmetro: a decriptação decriptografia
resultou em um número de cartão que não é composto só por dígitos.
8 Dado de entrada inválido
```
Os campos TipoCampoTrilha1 e TipoCampoTrilha2 indicam o tipo de campo retornado, respeitando o valor
estabelecido para os campos sensíveis, com 202x para campos abertos mascarados, 203x para o Hash dos campos,
204x para campos criptografados e 205x.

```
Campos que podem ser retornados:
```
```
TipoCampo Descrição
202x Campos abertos, mascarados.
203x Hash dinâmico dos campos
204x Campos criptografados
205x Hash fixo dos campos *
```
```
x Campo
1 PAN do cartão
2 Vencimento do cartão (AAMM)
3 Nome do cliente/portador
4 Trilha 1
5 Trilha 2
6 Trilha 3
```
* As novas implementações devem utilizar o campo 203x, pois o campo 205x devolve um hash criptografado
utilizando a chave de criptografia inserida pelo cliente no arquivo .cha. Essa forma de uso (205x) existe apenas por
compatibilidade, pois o ideal é utilizar o Hash com Salt (Semente - 203x) uma vez que a informação utilizada para
gerar o hash fica escondida apenas dentro das aplicações que o utilizam, tornando o processo de reversão do hash
até obter o dado original praticamente impossível de ser executado pela força bruta.

**IMPORTANTE** : Essas funções NÃO podem ser utilizadas durante a execução do laço
ContinuaFuncaoSiTefInterativo. Para esse tipo de situação existem as versões que fazem o acesso direto a leitora
de cartão descritas a seguir.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 68 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
int LeCartaoDiretoSeguroEx (Mensagem, DadosOut, TamDadosOut, Timeout,
TestaCancelamento)

```
Interface ASCII
```
```
LeCartaoDiretoSeguroExA (Resultado, Mensagem, DadosOut, TamDadosOut, Timeout)
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por
valor
```
```
Não
usado Fixo 6^ Contém o resultado de resposta à chamada da rotina.^
```
```
Mensagem
```
```
Entrada,
por
valor
```
```
char * Variável Mensagem a ser apresentada no visor do PinPad.
```
```
DadosOut
```
```
Saída,
por
valor
```
```
char * Variável
```
```
Retorna os mesmos dados da rotina
LeCartaoDiretoSeguro, concatenados no formato TLV,
onde T corresponde ao tipo do campo (tamanho 5), L é
o tamanho do campo (tamanho 3) e V é o campo
(tamanho do campo).
```
```
TamDadosOut
```
```
Entrada,
por
valor
```
```
char * Fixo 6 Tamanho do buffer de DadosOut.
```
```
Timeout
```
```
Entrada,
por
valor
```
```
short Fixo 6
```
```
Define o tempo máximo de espera pela passagem do
cartão em segundos. Se zero, espera até que o cartão
seja passado
```
```
TestaCancelamento
```
```
Entrada,
por
valor
```
```
Rotina
```
```
Não
usado
```
```
Rotina da aplicação de automação que retorna 0 se é
para continuar aguardando pelo cartão e 1 caso deva
interromper o processo de aguardar a passagem do
cartão
```
```
int LeTrilhaChipInterativo (Modalidade)
LeTrilhaChipInterativoEx (Modalidade, ParamAdic)
```
```
Interface ASCII
```
```
LeTrilhaChipInterativoA (Resultado, Modalidade)
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 69 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por valor
```
```
Não
usado Fixo 6^ Contém o resultado de resposta à chamada da rotina.^
```
```
Modalidade
```
```
Entrada,
por valor
```
```
Int Fixo
```
```
Seleciona o tipo do pagamento:
2 : Débito
3 : Crédito
```
```
ParamAdic
```
```
Entrada,
por valor
```
```
char * Variável
```
```
Parâmetros adicionais, como o {SementeHash=XXX..}. É
opcional e pode ser vazio
```
Essas funções funcionam da mesma maneira das LeCartaoSeguro/LeCartaoSeguroA, com a diferença que estas
aceitam cartões com chip.

```
Observação:
```
Estas funções, “LeTrilhaChipInterativo”, “LeTrilhaChipInterativoEx” e “LeTrilhaChipInterativoA” não são
exportadas para ambiente Mobile. Devido a dificuldades de utilização de entrypoints de funções, neste ambiente,
e visando facilitar a sua implementação, foi disponibilizada a “Função” 431 para acesso à função
“LeTrilhaChipInterativoEx”. Esta “Função” segue o fluxo de uma transação “Gerencial” e é acessada através de
IniciaFuncaoSiTefInterativo(Ver item “3.2 Início da transação de Pagamento ou Gerencial”).

- Para utilização da “Função” 431, o parâmetro “Modalidade”(Tipo do pagamento) e
“ParamAdic”(SementeHash), serão solicitados à Automação Comercial no fluxo da transação através do comando
29 (Ver item 3.3.1 Tabela de códigos de Comando).
- Se parâmetro “SementeHash” for utilizado, opcionalmente poderá ser fornecida através do parâmetro
“ParamAdic” na chamada da função IniciaFuncaoSiTefInterativo, neste caso, não será solicitado no fluxo da
transação. Se solicitado no fluxo da transação através do comando 29 e o parâmetro não é utilizado, retornar o
campo vazio.

Caso este parâmetro seja utilizado, os dados retornados para a Automação Comercial serão hash geradas a
partir da semente informada (Campo tipo 203x. Ver tabela “Campos que podem ser retornados” acima).

##### 5.6.5 Leitura de senha

Esta função permite que o aplicativo capture no PinPad uma senha de um cliente de cartão do próprio
estabelecimento comercial (cartão proprietário). Não deve, em nenhuma hipótese, ser utilizada para captura de
senhas dos cartões tradicionais. Para maiores detalhes, consulte o documento “Acesso a Senha do Cliente para
Cartão Proprietário CliSiTef.doc”.

```
int LeSenhaInterativo (ChaveSeguranca)
```
```
Interface ASCII
```
```
LeSenhaInterativoA (Resultado, ChaveSeguranca)
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 70 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por valor
```
```
Não
usado Fixo 6^ Contém o resultado de resposta à chamada da rotina.^
```
```
ChaveSeguranca
```
```
Entrada,
por valor
```
```
char * Fixo 64
```
```
Dados gerados por uma biblioteca de segurança
fornecida pela Software Express para habilitar a captura
da senha do cliente. Neste caso, a CliSiTef poderá
interagir com o SiTef para obter ou validar os dados de
segurança necessários para a captura
```
No retorno a rotina devolve os mesmos valores que a rotina de pagamento. O aplicativo obtém a senha através
da chamada a função de continuação do processo iterativo.

**IMPORTANTE:** Essas funções NÃO podem ser utilizadas durante a execução do laço
_ContinuaFuncaoSiTefInterativo_. Para esse tipo de situação existem as versões que fazem o acesso direto a leitora
de senhas descritas a seguir.

```
int LeSenhaDireto (ChaveSeguranca, SenhaCliente)
```
```
Interface ASCII
```
```
LeSenhaDiretoA (Resultado, ChaveSeguranca, SenhaCliente)
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por valor
```
```
Não
usado
```
```
Fixo 6 Contém o resultado de resposta à chamada da rotina.
```
```
ChaveSeguranca
```
```
Entrada,
por valor
```
```
char * Fixo 64
```
```
Dados gerados por uma biblioteca de segurança
fornecida pela Software Express para habilitar a captura
da senha do cliente. Neste caso, a CliSiTef poderá
interagir com o SiTef para obter ou validar os dados de
segurança necessários para a captura
```
```
Senha
```
```
Saída, por
valor char *^ Fixo 20^
```
```
Senha do cliente, em formato criptografado, e que deve
ser passada para uma rotina personalizada por cliente
para sua descriptografia
```
No retorno a rotina devolve o valor **0** (zero) caso tenha sido executada corretamente e um valor diferente de
zero em caso de erro ou cancelamento pelo usuário.

##### 5.6.6 Leitura de Confirmação pelo Cliente no PinPad

Estas funções permitem que o aplicativo solicite uma confirmação no PinPad. O formato de ativação é o
seguinte:


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 71 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
int LeSimNaoPinPad (Mensagem)
```
```
Interface ASCII
```
```
LeSimNaoPinPadA (Resultado, Mensagem)
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por valor
```
```
Não
usado Fixo 6^ Contém o resultado de resposta à chamada da rotina.^
```
```
Mensagem
```
```
Entrada,
por valor
```
```
char * Variável Mensagem a ser apresentada no visor do PinPad.
```
No retorno a rotina devolve **0** se o cliente pressionou a tecla de Cancelamento, **1** se ele pressionou a tecla de
Confirmação e outro valor em caso de erro no acesso ao PinPad.

Notar que essa função não é iterativa ou seja, o controle de execução somente volta para a aplicação após o
pressionamento da tecla.

##### 5.6.7 Define uma mensagem momentânea para o PinPad

Permite que seja definida uma mensagem momentânea para ser apresentada no display do PinPad. O formato
de ativação da rotina é:

```
int EscreveMensagemPinPad (Mensagem)
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Descrição
```
```
Mensagem
```
```
Entrada,
por valor
```
```
char *
```
```
Mensagem a ser apresentada no visor do PinPad.
Recomenda-se que ela possua no máximo 32 caracteres de
forma a ser compatível com os PinPad’s existentes
atualmente em campo.
```
Para apagar a mensagem e deixar o visor em branco, basta chamar essa função passando o campo _Mensagem_
vazio.

```
A aplicação, se desejar, pode incluir o caractere ‘\r’ (carriage return) para indicar uma mudança de linha.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 72 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 5.6.8 Leitura de teclas especiais do PinPad

Essa função é utilizada para aguardar o pressionamento de uma tecla no pinpad, retornando seu código
correspondente. O formato de ativação da rotina é:

```
int LeTeclaPinPad (void)
```
```
No retorno a rotina devolve:
```
```
Valor Tecla Descrição
0 [OK] ou [ENTER] Pressionada a tecla OK ou ENTER
4 [F1] Pressionada a tecla F1
5 [F2] Pressionada a tecla F2
6 [F3] Pressionada a tecla F3
7 [F4] Pressionada a tecla F4
8 [LIMPA] Pressionada a tecla LIMPA
13 [CANCELA] Pressionada a tecla CANCELA
```
- 43

```
Qualquer outra tecla ou ocorreu
algum erro no processo.
```
```
Problema na execução de alguma das
rotinas no pinpad.
```
Por questão de segurança, este comando não retorna teclas numéricas, sendo que o pressionamento destas
teclas é simplesmente ignorado pelo pinpad durante a execução do comando.
Notar que essa função não é iterativa ou seja, o controle de execução somente volta para a aplicação após o
pressionamento de uma tecla.
**Observação sobre o uso desta função para obter as teclas F1, F2, F3 e F4:** há alguns pinpads no mercado que
não possuem as teclas F1, F2, F3 e F4. Portanto ao utilizar esta função, deve-se deixar um plano B para estes casos.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 73 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
##### 5.6.9 Remover cartão inserido no PinPad

Essa função é utilizada para solicitar a retirada do cartão inserido no pinpad. É utilizada em conjunto com o
parâmetro “AdiaRemocaoCartao” (Ver documento CliSiTef - Lista de parâmetros adicionais – 1.17.pdf, item 4.3
Função IniciaFuncaoSiTefInterativo).

int RemoveCartaoPinPad (short (CALLBACK *pTestaCancelamento) (void *lpvParam), void
*lpvParam);

```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Descrição
```
```
pTestaCancelamento
```
```
Entrada,
por valor
```
```
char * Parâmetro não utilizado. Passar NULL
```
```
lpvParam
```
```
Entrada,
por valor
```
```
char * Parâmetro não utilizado. Passar NULL
```
#### A função retorna OK (0) após a retirada do cartão do pinpad ou se não existir cartão inserido.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 74 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 5.7 Correspondente Bancário (Pagamento de Contas)

Esta função permite que o aplicativo de automação aceite o pagamento de contas diversas de acordo com o
contrato firmado entre ele e um Banco Correspondente. O formato de ativação desta funcionalidade é o seguinte:

int CorrespondenteBancarioSiTefInterativo (CupomFiscal, DataFiscal, Horario,
Operador, ParamAdic)

```
Interface ASCII
```
CorrespondenteBancarioSiTefInterativoA (Resultado, CupomFiscal, DataFiscal,
Horario, Operador, ParamAdic)

```
Onde os parâmetros possuem a mesma função já descrita para o Pagamento.
```
A lógica de funcionamento desta função é a mesma no pagamento de uma compra feita pelo cliente ou seja,
deve-se chamar a função _ContinuaFuncaoSiTefInterativo_ até que o resultado seja diferente de **10000**.

Essa função, dada a diversidade de produtos ofertados pelos Bancos Correspondentes pode, inclusive, executar
uma operação de TEF para concretizar o pagamento de uma conta.

Notar que os campos de retorno **600** a **604** retornam diversas vezes, uma para cada título ou convênio pago, no
caso de pagamento em lote. O campo 607 indica qual o índice (seqüência) de pagamento ao qual se referem os
campos **600** a **604** que virão a seguir.

Como já descrito anteriormente, para o Correspondente Bancário os comprovantes devolvidos nos campos tipo
**121** e **122** devem ser impressos no momento que forem disponibilizados para a automação e a continuação do
processo iterativo deve seguir normalmente caso não ocorra erro na impressão ou interrompida com **- 1** caso
contrário.

No _ParamAdic_ pode ser passado: {PortaPinPadCB=<porta>}, em que <porta> indica a porta em que está
conectado o pinpad especifico para transações de Correspondente Bancário: consulta saldo, saque e recarga celular
Bradesco.

Vale lembrar que o pinpad configurado {PortaPinPadCB=<porta>} atende somente ao Correspondente Bancário,
não serve para TEFs.

Para atender a necessidade de algumas redes “Autorizadoras”, que necessitam de informações sobre o
Documento Fiscal Eletrônico emitido pelas “Automações Comerciais”, foram definidos 02 “funcionalidades” para
passar os dados necessários no parâmetro “ParamAdic” (ver detalhes no item 5.7).


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 75 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 5.8 Verificação da integridade de um código em barras

Permite, na coleta manual dos campos presentes em um código em barras, que o aplicativo faça a validação a
medida que os campos estão sendo digitados, de forma a alertar o operador antecipadamente e permitir que ele
corrija o erro. O formato de ativação da rotina é o seguinte:

```
int ValidaCampoCodigoEmBarras (Dados, Tipo)
```
```
Interface ASCII
```
```
ValidaCampoCodigoEmBarrasA (Resultado, Dados, Tipo)
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por valor
```
```
Não
usado
```
```
Fixo 6 Contém o resultado de resposta à chamada da rotina.
```
```
Dados
```
```
Entrada,
por valor
```
```
char * Variável Mensagem a ser apresentada no visor do PinPad.
```
```
Tipo Saída, por
referência
```
```
short * Fixo 6
```
```
Informa o tipo do documento coletado segundo a seguinte
codificação:
```
- 1 → Ainda não foi possível definir o tipo
0 → Arrecadação
1 → Título

```
Recomendação:
```
É recomendável que aplicação do terminal, uma vez identificado que o documento será digitado, abra campos
de coleta simulares aos presentes nos documentos a serem pagos. Para isso ela precisará identificar se é uma Ficha
de Compensação/Titulo/Bloqueto ou Ficha de Arrecadação/Tributos. Essa identificação pode ser feita mediante
uma pergunta ao operador ou através da rotina aqui descrita.

Se o usuário optar pelo reconhecimento automático ele deve abrir um campo como se fosse de Arrecadação e,
a cada digito fornecido pelo operador, passar os dígitos já fornecidos para a rotina. Esse procedimento deve ser
feito até o momento que a rotina devolver se o documento em questão é um Título ou Arrecadação. Nesse
momento a aplicação não precisa mais chamar a rotina a cada dígito fornecido e deve, se necessário, modificar a
formatação dos campos para captura.

Além da identificação do tipo do documento a rotina faz a consistência dos dígitos verificadores, retornando
para aplicação se existe um erro e onde ele está localizado. A aplicação pode chamar a rotina passando os campos
à medida que eles forem sendo coletados ou no final da coleta, onde será feita uma análise global do conteúdo
digitado. Se a chamada for durante a digitação, os pontos corretos são:

- **Arrecadação** : a cada um dos 4 blocos de digitação
- **Títulos** : a cada grupo de dois blocos de digitação

No retorno a rotina devolve 0 se tudo estiver correto até o momento, -1 se for um código em barras não
reconhecido ou um número de 1 a 4 indicando qual o campo está incorreto ou ainda o valor 5 para indicar que o
número como um todo não está correto.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 76 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
Exemplificamos a seguir como a aplicação do terminal deveria proceder, na forma mais genérica possível hoje
em dia, para coletar um documento. No exemplo utilizaremos um título e deixaremos a automação ser informada
que é esse tipo de documento. O documento que será utilizado é o seguinte:

```
23790.09505.91211.369656.04025.039209. 1. 17690000005625
```
```
Campo aberto pela automação
```
**2**
Após a digitação do primeiro número chama a rotina passando “2” como parâmetro. No retorno a rotina
devolveu o resultado 0 e Tipo = 0 (fictício pois nesse momento, para a configuração atual de códigos em barra, ela
já teria feito a identificação)

**23**
Após a digitação do primeiro número chama a rotina passando “23” como parâmetro. No retorno a rotina
devolveu o resultado 0 e Tipo = 1

**23790 09505**
A automação reapresenta os campos já sabendo que é um título. Somente após a digitação do primeiro grupo
de números ela chama a rotina passando “ **2379009505** ” como parâmetro. No retorno a rotina continua a devolver
Tipo = 1. Já o resultado poderá ser 0, indicando que o bloco está correto ou 1 indicando que ele está errado.

**23790 09505 91211 369656**
A automação continua a coletar os dígitos e somente após a digitação do segundo grupo de números ela chama
a rotina passando “ **237900950591211369656** ” como parâmetro. No retorno a rotina continua a devolver Tipo = 1.
Já o resultado poderá ser 0, indicando que os blocos estão corretos ou 1 ou 2 indicando que o primeiro ou o segundo
bloco está errado.

**23790 09505 91211 369656 04025 039209 1 17690000005625**
A automação continua a coletar os dígitos chamando a rotina no final do terceiro bloco com os dados
**237900950591211369656** e no final do quarto bloco com todos os dados digitados. No retorno a rotina continua a
devolver Tipo = 1 e o resultado refletirá a situação de erro ou não dos blocos passados como parâmetro. Em
particular, se retornar o código 5 é porque existe algum dos blocos (não é possível identificar qual deles) com erro.

Finalizando, a automação também pode para efeito de consistência do código em barras optar por conferi-los
apenas no final da digitação de todos os campos. Nesse caso, a rotina devolverá 1, 2, 3 ou 4 nessa ordem de
prioridade caso encontre um ou mais blocos com erro e 5 na situação dos blocos internos estarem certos, mas o
número como um todo possui algum erro.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 77 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 5.9 Obtendo Versão

```
Esta função é utilizada pelo terminal para obter as versões da CliSiTef e CliSiTefI.
```
```
int ObtemVersao (VersaoCliSiTef, VersaoCliSiTefI)
```
```
Interface ASCII
```
```
ObtemVersaoA (Resultado, VersaoCliSiTef, VersaoCliSiTefI)
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Interface
ASCII
```
```
Descrição
```
```
Resultado
```
```
Saída,
por valor
```
```
Não
usado Fixo 6^ Contém o resultado de resposta à chamada da rotina.^
```
```
VersaoCliSiTef
```
```
Saída,
por valor
```
```
char * Máx. 64 No retorno contém a versão da CliSiTef
```
```
VersaoCliSiTefI
```
```
Saída,
por valor
```
```
char * Máx. 64 No retorno contém, caso exista, a versão da CliSiTefI
```
```
No retorno a rotina devolve 0 quando foi executada com sucesso e diferente no caso de erro.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 78 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 5.10 Enviando mensagens pendentes

Em situações de falha de comunicação com o **servidor SiTef** , a **CliSiTef** enviará automaticamente eventuais
dados remanescentes (por exemplo, dados de confirmação, não-confirmação e desfazimento) somente na próxima
transação do PDV.

```
Porém, pode levar algum tempo até que a próxima transação seja iniciada na estação.
```
Nos momentos em que o PDV está no estado repouso ou “ _idle_ ”, a automação pode utilizar a seguinte rotina
para forçar a biblioteca a descarregar mensagens de confirmação, não confirmação e desfazimento para o **servidor
SiTef**.

```
int DescarregaMensagens (void)
```
No retorno a rotina devolve **0** se conseguiu descarregar todas as mensagens e diferente de zero caso ocorra
algum erro impossibilitando o envio das mesmas.

#### 5.11 Informações do PinPad

Existem duas formas para obter informações básicas do PinPad conectado no PDV, tais como número de série,
modelo, etc.

```
ObtemInformacoesPinPad – função direta.
```
```
Através de código de função passada à IniciaFuncaoSiTefInterativo, e consequente processo iterativo.
```
```
A primeira forma é utilizando a função abaixo.
```
```
int ObtemInformacoesPinPad (InfoPinPad)
```
```
Parâmetro Tipo
```
```
Interface
padrão
```
```
Descrição
```
```
InfoPinPad
```
```
Saída,
por valor
```
```
char * No retorno contém as informações do PinPad
```
```
Em caso de sucesso, os dados serão retornados no seguinte formato:
```
```
2 caracteres numéricos que indicam a informação obtida sendo:
```
```
01 para o Nome do fabricante,
```
```
02 para o Modelo / versão do hardware,
```
```
03 para a Versão do software básico/firmware,
```
```
04 Versão da especificação compartilhada
```
```
05 para a Versão da aplicação básica,
```
```
06 para o Número de série.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 79 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
3 caracteres numéricos que indicam o tamanho em caracteres da informação.
```
```
N (conforme tamanho acima) caracteres alfanuméricos com a informação.
```
```
Exemplo:
```
**01** 006GERTEC **02** 010PPC900;3MB **03** 0190077_0071_0080_0106 **04** 0041.06 **05** 013001.23
100820 **06** 0160450805232030714

```
Nome do fabricante : GERTEC
```
```
Modelo / versão do hardware : PPC900;3MB
```
```
Versão do software básico/firmware : 0077_0071_0080_0106
```
```
Versão da especificação : 1.06
```
```
Versão da aplicação básica : 001.23 100820
```
```
Número de série : 0450805232030714
```
Observação: o Buffer que receberá as informações do PinPad deve possuir tamanho mínimo de 256 caracteres,
já prevendo a possibilidade de serem incluídas novas informações de pinpad.

Já na segunda forma, a automação deve passar o código de função **775** para a _IniciaFuncaoSiTefInterativo_ , e
prosseguir no fluxo de coleta como se fosse uma transação.

Durante o fluxo de coleta, os seguintes campos serão retornados para a automação, normalmente pelo
comando 0 (zero).

```
TipoCampo Descrição
2450 Nome do fabricante
2451 Modelo / versão do hardware
2452 Versão do software básico/firmware
2453 Versão da especificação
2454 Versão da aplicação básica
2455 Número de série do PinPad
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 80 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 5.12 Carga de Tabelas no PinPad

Denomina-se carga de tabelas no pinpad o processo onde é feito a carga de informações de aplicações e
parâmetros de chip no pinpad.

```
Este processo viabiliza a leitura de um cartão com chip durante as transações.
```
Normalmente a **CliSiTef** faz esta operação automaticamente, sob demanda, ao perceber que é necessária uma
nova carga de parâmetros. Existem vários motivos para isso, por exemplo a troca de pinpad no PDV, ou então uma
alteração de parâmetros do estabelecimento no lado do autorizador.

A automação pode comandar uma nova carga de tabelas no pinpad. Por exemplo, para reduzir a chance de uma
carga na primeira venda do dia, a automação pode iniciar uma carga quando estiver em estado de repouso ( _idle_ ) e,
desta forma, diminuir o tempo no primeiro atendimento.

Note que, se houver uma alteração de parâmetros por parte do autorizador, esta mudança refletirá uma nova
carga de tabelas durante o dia.

##### 5.12.1 Com alteração na Automação...........................................................................................................

Para que a automação comande a carga de tabelas no pinpad, são oferecidos três códigos de função que devem
ser usadas na _IniciaFuncaoSiTefInterativo_.

```
Código da Função Descrição
770 Carga de tabelas no pinpad
771 Carga forçada de tabelas no pinpad (Local)
772 Carga forçada de tabelas no pinpad (SiTef)
```
A função **770** realiza a carga de tabelas no pinpad caso seja necessário. Isto é, se os dados do servidor SiTef já
estiverem carregados no pinpad, nenhuma carga será feita.

A função **771** força a carga de tabelas no pinpad de acordo com as tabelas baixadas previamente do servidor
SiTef e que estão armazenadas localmente no PDV.

Já a função **772** faz com que a clisitef apague os dados locais do PDV, baixando do SiTef uma nova fotografia
destes parâmetros, e a seguir faz a carga de tabelas no pinpad.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 81 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
##### 5.12.2 Sem alteração na Automação

Para que a automação se beneficie da carga de tabelas sem ter que programar as chamadas da
_IniciaFuncaoSiTefInterativo_ com os três códigos de função **770** , **771** e **772** , foram incluídas no menu Administrativo
da CliSiTef, três transações equivalentes.

```
No exemplo acima,
```
- a opção 11 equivale à Funcao **770** ;
- a opção 12 equivale à Funcao **771** ;
- a opção 13 equivale à Funcao **772**.

Para habilitar a transação de Carga de tabelas no pinpad, é necessário incluir na seção [Geral] a chave
_TransacoesAdicionaisHabilitadas_ o valor **3624**.

Para habilitar a transação de Carga forcada de tabelas no pinpad (Local), é necessário incluir na seção [Geral] a
chave _TransacoesAdicionaisHabilitadas_ o valor **3625**.

```
A transação de Carga forcada de tabelas no pinpad (SiTef) está habilitada de forma padrão, com o valor 3626.
```
```
[Geral]
TransacoesAdicionaisHabilitadas=3624;3625
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 82 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 5.13 Tratamento para Múltiplos Pagamentos

Transações que envolvem o pagamento de uma compra com mais de um pagamento TEF caracteriza-se como
Pagamento com Múltiplos TEFs.

```
Para que tudo ocorra bem neste processo, o PDV deverá seguir as seguintes recomendações:
```
1 – Para todas as transações TEF que forem realizadas, deve-se utilizar no comando IniciaFuncaoSiTefInterativo
sempre o parâmetro CupomFiscal com o mesmo número, vinculando-as ao cupom fiscal vigente, referente à
compra que está sendo paga com mais de um TEF; além do mesmo CupomFiscal, o parâmetro DataFiscal também
deve ser o mesmo usado em todas as compras, pois os parâmetros para a FinalizaFuncaoSiTefInterativo fazer
corretamente a confirmação ou não confirmação de todos os TEFs vinculados, são CupomFiscal e DataFiscal.

2 – Ao realizar o pagamento, se tudo foi OK, a transação devolverá um Cupom TEF a ser impresso pela
automação comercial. Esse cupom deve ser mantido em memória e a venda ficará pendente.

```
3 – Efetuar N pagamentos TEF até que o valor final da venda esteja completamente pago.
```
```
4 – Caso ocorra alguma falha no pagamento TEF como:
```
- O autorizador não respondeu (time-out)
- Deu algum erro de validação na CliSiTef ou no SiTef
- A transação foi negada pelo autorizador
- O operador abortou a transação

A transação se encerra, com o fluxo da ContinuaFuncaoSiTefInterativo finalizando com o retorno diferente de
0 (zero), e nenhuma ação mais deverá ser efetuada pelo PDV naquele momento, referente à transação TEF vigente.
Ou seja, o fluxo daquela venda se encerrou, sem que fosse efetuado o TEF. Para tanto, o PDV deverá efetuar mais
TEF(s) ou completar a diferença faltante com outra forma de pagamento.

5 – Quando o valor da transação de compra estiver completamente pago, basta o envio da
FinalizaFuncaoSiTefInterativo com o parâmetro Confirma com valor 1 e com os parâmetros CupomFiscal e
DataFiscal idênticos aos usados nas vendas TEF e o fluxo de Múltiplos Pagamentos (TEF) terá sido encerrado com
sucesso; ou seja, todas as transações que estavam pendentes e vinculadas àquele CupomFiscal e DataFiscal ficarão
com o Status de **EFETUADA** no relatório do SiTef.

```
6 – Se porventura:
```
- o cliente desistiu da compra; ou
- ocorreu queda de energia; ou
- acabou o papel da impressora no meio da impressão do(s) cupom(ns) TEF;

```
ou por algum outro motivo qualquer em que a compra não foi concluída e o cliente não levou a mercadoria,
o PDV deverá enviar a não confirmação da transação (comando FinalizaFuncaoSiTefInterativo com o
parâmetro Confrma igual a 0 e os parâmetros CupomFiscal e DataFiscal idênticos aos usados nas vendas
TEF), não confirmando desta forma todas as transações TEF que foram realizadas com aquele CupomFiscal
e DataFiscal.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 83 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
E então o PDV terá encerrado o fluxo de Múltiplos Pagamentos com insucesso, fazendo com que todas as
transações que estavam pendentes referentes àqueles CupomFiscal e DataFiscal sejam canceladas (não
confirmadas). O Status das transações TEF que estavam pendentes no relatório ficará como CANC.PDV.
```
```
7 – Tratamento para Múltiplos Pagamentos que possam ocorrer em uma virada de dia:
```
Caso ocorra de um ou mais TEFs iniciem em um dia (DD) e outro(s) sejam feitos no dia seguinte (DD + 1), haverá
a necessidade de se realizar duas confirmações / não confirmações, porque as confirmações e não confirmações
são amarradas pelos parâmetros: CupomFiscal e DataFiscal.

Caso fosse realizada uma venda em dia DD + 1, e usada a data DD para DataFiscal, o pinpad poderia apresentar
problemas em seu funcionamento, ocasionando efeitos colaterais.

```
O ideal para este caso é que:
```
- para o caso de sucesso nos Múltiplos TEFs sejam enviadas duas confirmações (função
    FinalizaFuncaoSiTefInterativo com o parâmetro Confirma com valor 1): uma com CupomFiscal e
    DataFiscal do dia DD e outra com o número de CupomFiscal e DataFiscal da data DD + 1.
- em caso de insucesso sejam enviadas duas não confirmações (função FinalizaFuncaoSiTefInterativo
    com o parâmetro Confirma com valor 0): uma com CupomFiscal e DataFiscal do dia DD e outra com o
    número de CupomFiscal e DataFiscal da data DD + 1.
- Não há a necessidade de se manter o número do CupomFiscal quando há a virada do dia.
- Verificar se ao final, tanto de sucesso, quanto de insucesso, se as transações envolvidas no processo
    mudaram o Status para diferente de **PENDENTE**.

#### 5.14 TEF (Crédito ou Débito) para Pagamento de Carnê

Alguns adquirentes fornecem aos estabelecimentos taxas diferenciadas para pagamento de boletos/contas ou
para pagamento da fatura do cartão de crédito. Para que o adquirente que possui essas taxas diferenciadas possa
distinguir um TEF “normal” de um TEF para pagamento de Carnê, deve-se informar pela CliSiTef uma modalidade
diferenciada para informar aos módulos do SiTef que trata-se de um TEF para pagamento de contas ou pagamento
de fatura de cartão de crédito.

5.14.1 Débito para Pagamento de Carnê

```
Na CliSiTef deve-se chamar a função / modalidade : 16
```
Caso o módulo em questão trate a funcionalidade Débito para Pagamento de Carnê, a CliSiTef devolve o campo
**2361** com o valor **1** , informando que aquela transação foi acatada como **Débito para Pagamento de Carnê** ; caso o
campo não retorne ou retorne com o valor **0** , a transação foi realizada como **Débito normal**.

**OBSERVAÇÃO:** Cabe à automação comercial fazer o tratamento correto deste campo 2361 para aceitar a
transação ou não em caso do seu não retorno ou retorno do campo com o valor 0, pois a CliSiTef não irá barrr a
transação pelo fato do módulo não aceitar a transação de Crédito para Pagamento de Carnê, ocasionando então a
realização de uma transação de Débito normal, sem a taxa diferenciada.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 84 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
5.14.2 Crédito para Pagamento de Carnê

```
Na CliSiTef deve-se chamar a função / modalidade : 17
```
Caso o módulo em questão trate a funcionalidade Crédito para Pagamento de Carnê, a CliSiTef devolve o campo
**2363** com o valor **1** , informando que aquela transação foi acatada como **Crédito para Pagamento de Carnê** ; caso o
campo não retorne ou retorne com o valor **0** , a transação foi realizada como **Crédito normal**.

**OBSERVAÇÃO:** Cabe à automação comercial fazer o tratamento correto deste campo 236 3 para aceitar a
transação ou não em caso do seu não retorno ou retorno do campo com o valor 0, pois a CliSiTef não irá barrá-la
pelo fato do módulo não aceitar a transação de Crédito para Pagamento de Carnê, ocasionando então a realização
de uma transação de Crédito normal, sem a taxa diferenciada.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 85 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
## 6 Arquivo de configurações CliSiTef.ini ou CLSIT

A **CliSiTef** utiliza um arquivo no formato .ini, de modo a definir previamente determinadas configurações na
estação.

```
Este arquivo se chama CliSiTef.ini , e deve ser colocado na mesma pasta da biblioteca CliSiTef.
```
Em equipamentos POS e plataformas mobile (Android e IOS), o arquivo de configuração utilizado é **CLSIT**. Ao
longo deste documento, todas as menções para **CliSiTef.ini** devem ser entendidas como **CLSIT** quando se tratar
destes ambientes.

```
A seguir descreveremos algumas funcionalidades macro presentes neste arquivo.
```
#### 6.14 Configuração do PinPad

##### 6.14.1 Configuração da porta

```
A porta serial/usb do PinPad é configurada na seção PinPadCompartilhado, campo Porta.
```
```
[PinPadCompartilhado]
Porta=<PORT>
```
```
No Windows, deve-se usar informar o número da porta serial/usb. Por exemplo: 12
```
```
No Linux, deve-se indicar o caminho completo do device. Por exemplo: /dev/ttyS1 ou /dev/ttyACM0
```
A partir da CliSiTef versão 4.0.111.3 para Windows e 4.0.111.18 para Linux, é possível usar o valor ‘AUTO_USB’
para identificar automaticamente a porta de um pinpad USB.

```
[PinPadCompartilhado]
Porta=AUTO_USB
```
**Nota** : a configuração acima é válida somente para a plataforma Windows 32 e Linux 32 (a partir do kernel 2.6),
nas versões mencionadas acima.

```
Pinpads que suportam a configuração AUTO_USB em ambiente WINDOWS:
```
```
Fabricante/Modelo Versão Mínima CliSiTef
Gertec PPC900, PPC910, PPC920 e PPC930 4.0.111.3
Ingenico iCT2xx 4.0.111.3
Ingenico iHT1, iHT2, iHT3, iHT4 e iHT5 4.0.111.3
Ingenico IPPxxx 4.0.111.3
Ingenico iSC2xx 4.0.111.3
Ingenico iSC350 4.0.111.3
Ingenico iST1xx 4.0.111.3
Ingenico iUC1xx 4.0.111.3
Ingenico iUP250 4.0.111.3
Ingenico Lane3000 6.2.115.17 r1
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 86 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
###### PAX D200 4.0.111.3

```
Verifone Vx810 e Vx820 4.0.111.3
Verifone P200 6.2.115.28 r2
```
```
Pinpads que suportam a configuração AUTO_USB em ambiente LINUX:
```
```
Fabricante/Modelo Versão Mínima CliSiTef
Gertec PPC900, PPC910 e PPC920 4.0.111.18
Ingenico iCT2xx 4.0.111.18
Ingenico iHT1, iHT2, iHT3, iHT4 e iHT5 4.0.111.18
Ingenico IPPxxx 4.0.111.18
Ingenico iSC2xx 4.0.111.18
Ingenico iSC350 4.0.111.18
Ingenico iST1xx 4.0.111.18
Ingenico iUC1xx 4.0.111.18
Ingenico iUP250 4.0.111.18
Verifone Vx810 e Vx820 4.0.111.18
```
```
Nota: Pinpads de novos fabricantes ou novos modelos poderão ser incluídos nas listas acima, futuramente.
```
##### 6.14.2 Configuração quando a Automação não utilizar pinpad

```
A CliSiTef , por padrão, assume que a automação possui um PinPad, e tenta até 3 vezes abrir a porta.
```
Nos casos em que a automação não possui/utiliza um PinPad (p/ex. somente transações digitadas), deve-se
configurar o item Porta, na seção PinPadCompartilhado, com o valor **NENHUM.**

```
[PinPadCompartilhado]
Porta=NENHUM
```
##### 6.14.3 Configuração de um segundo pinpad

Conforme mencionado em Correspondente Bancário (Pagamento de Contas), transações de Pagamento de
Contas requerem pinpad especifico do banco. Geralmente, existe um setor do estabelecimento comercial somente
para este tipo de atendimento.

Se a Automação precisar atender às transações de TEF no mesmo check-out que atende as transações de
Pagamento de Contas, é possível configurar um segundo pinpad especifico do Banco, de forma que, o pinpad
principal será usado exclusivamente nas transações de TEF.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 87 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
##### 6.14.4 Definição da mensagem padrão

```
É possível inicializar o PinPad com uma mensagem de até 16 caracteres.
```
```
Esta mensagem é configurada na seção PinPad, campo MensagemPadrao.
```
```
[PinPad]
MensagemPadrao=<MENSAGEM>
```
```
É possível quebrar em duas linhas, utilizando o separador ‘|’.
```
##### 6.14.5 Habilitando confirmação do valor no pinpad

Esta configuração habilita a confirmação do valor da transação no pinpad no caso de transações sem coleta de
senha pelo pinpad, visto que na coleta de senha já é apresentado o valor. Até o momento ela só é válida para
transações de recarga pré-pago e bônus.

```
Para habilitar esta configuração basta adicionar as seguintes configurações ao arquivo “CliSiTef.ini”:
```
```
[Geral]
ConfirmarValorPinPad=1
```
#### 6.15 Configuração de conexão com o servidor SiTef

##### 6.15.1 Configuração de endereços IP adicionais

No arquivo de configuração é possível adicionar endereços alternativos para o servidor SiTef. Estes endereços
são complementares aos informados na função de configuração. São permitidos no máximo 4 endereços a partir
da CliSiTef 6.1.114.59 r3 e anteriormente 3, considerando a soma dos enviados na função de configuração e arquivo
CliSiTef.ini.

```
[SiTef]
EnderecoIP=IP1;IP2;IP3;IP4
```
```
Também é possível informar a porta do servidor, no formato IP:Porta.
```
```
Por exemplo:
```
```
EnderecoIP=127.0.0.1:4096;192.168.0.1:5096
```
##### 6.15.2 Configuração da porta do servidor SiTef

Em raras situações, pode ser necessário alterar a porta de comunicação com o **servidor SiTef**. Por exemplo,
alguma restrição de segurança na rede do cliente.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 88 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
A porta padrão do **servidor SiTef** é **4096**. Para especificar uma nova porta, deve-se incluir na seção **SiTef** o campo
**PortaSiTef**.

```
[SiTef]
PortaSiTef=<porta>
```
##### 6.15.3 Obrigatoriedade de conexão

```
Por padrão, as transações na CliSiTef tentam avançar ao máximo, mesmo sem a conexão com o SiTef.
```
Para retirar este comportamento, e exigir a obrigatoriedade de conexão, inclua na seção SiTef o parâmetro
**ConexaoObrigatoria** com valor um (1). Neste caso, não havendo conexão com o SiTef a transação será encerrada
com erro **- 5**.

```
[SiTef]
ConexaoObrigatoria=1
```
##### 6.15.4 Mantendo conexão ativa

Por padrão, a característica da **CliSiTef** ao fazer uma transação com o **servidor SiTef** é: realizar a conexão, efetuar
a troca de mensagens e desconectar ao final da transação.

Caso haja necessidade de manter a conexão com o SiTef sempre ativa, deve-se incluir na seção **SiTef** o parâmetro
**MantemConexaoAtiva** com valor **1** (um).

```
[SiTef]
MantemConexaoAtiva=1
```
##### 6.15.5 Configuração do mostrador de comunicação

Por padrão, a **CliSiTef** envia para a automação o comando 3 com uma mensagem do tipo “Aguarde, em
processamento...”.

Para desabilitar o mostrador de comunicação, basta incluir na seção Geral o campo
**MostradorComunicacaoHabilitado** com valor zero.

```
[Geral]
MostradorComunicacaoHabilitado=0
```
```
Atenção: ao contrário dos itens anteriores, deve-se usar a seção Geral.
```
##### 6.15.6 Alterando parâmetros de temporizações (timeout)

```
Tempo para timeout de conexão com o servidor SiTef
```
O tempo padrão de espera para que a CliSiTef consiga se conectar com o servidor SiTef é de **6** segundos. Para
aumentar ou diminuir este tempo de espera, configure na seção **SiTef** o campo **TempoEsperaConexao** com o novo
valor, em segundos.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 89 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
[SiTef]
TempoEsperaConexao=<tempo para timeout, em segundos>
```
```
Tempo adicional para timeout da transação
```
Normalmente a CliSiTef recebe parâmetros de timeout com o servidor SiTef. A CliSiTef leva em consideração
estes valores, acrescentando ainda uma margem de segurança sobre eventuais tempos gastos na transmissão.

Em situações de autorizador indisponível, e dependendo do canal de comunicação entre o servidor SiTef e a
CliSiTef, esta margem pode ser insuficiente, podendo ocorrer erros do tipo “Sem conexão com o servidor SiTef”,
quando o correto seria “Serviço do autorizador indisponível”.

```
Para incluir um tempo adicional em segundos, basta incluir o item TempoAdicionalEspera na seção SiTef.
```
```
[SiTef]
TempoAdicionalEspera=<tempo adicional para timeout, em segundos>
```
```
Tempo para espera de desfazimento
```
O tempo padrão de espera ( _timeout_ ) para que a CliSiTef consiga receber a resposta à uma mensagem de
desfazimento enviada ao servidor SiTef é de 6 segundos. Para alterar este valor, configure na seção SiTef o campo
**TempoEsperaDesfazimento** o novo valor, em segundos.

```
[SiTef]
TempoEsperaDesfazimento=<tempo para timeout, em segundos>
```
```
Tempo para espera de confirmação
```
O tempo padrão de espera ( _timeout_ ) para que a CliSiTef consiga receber a resposta à uma mensagem de
confirmação/não-confirmação enviada ao servidor SiTef é de **6** segundos. Para alterar este valor, configure na seção
**SiTef** o campo **TempoEsperaConfirmacao** o novo valor, em segundos.

```
[SiTef]
TempoEsperaConfirmacao=<tempo para timeout, em segundos>
```
#### 6.16 Como passar um novo valor da compra da transação na CliSiTef

```
Na seção [Geral] acrescente a chave PermiteAlterarValorPagamento=1, conforme abaixo:
```
```
[Geral]
PermiteAlterarValorPagamento=1
```
```
Durante o fluxo da transação, a CliSiTef solicitará "Forneca o novo valor do pagamento", através do campo 154.
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_90_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 91 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 6.17 Habilitando/desabilitando formas de pagamento

```
A CliSiTef permite duas maneiras de se configurar as formas de pagamento.
```
Uma delas ocorre em tempo de execução da transação, isto é, a automação comercial define as formas de
pagamento que serão aplicadas para a transação corrente.

Caso a automação não defina estes valores, serão usadas as parametrizações padrões, podendo estar definidas
no arquivo de configurações CliSiTef.ini da estação.

**Importante** : as configurações definidas em tempo de execução não são afetadas por eventuais configurações
locais da estação.

##### 6.17.1 Restringindo formas de pagamento em tempo de execução...........................................................

A CliSiTef permite que o aplicativo de automação restrinja as modalidades de pagamento disponíveis ao
operador de caixa/cliente para uma determinada venda. Isso é feito através do parâmetro “ParamAdic” presente
nas funções que inicial o processo de pagamento ou Correspondente Bancário (IniciaFuncaoSiTefInterativo e
CorrespondenteBancarioSiTefInterativo). O formato desse campo é o seguinte:

```
[<Tipo do meio de pagamento>;<Tipo do meio de pagamento>;...];
```
onde cada um dos sub-campos contém um código numérico que identifica o item de menu que não se aplica à
venda em questão. Por exemplo, se durante o processo de venda já foi negociado com o cliente que é uma venda
para pagamento única e exclusivamente com cartão a vista, o valor do parâmetro deve ser:

```
[10;17;18;19;27;28;34;35;];
```
Consulte a Tabela de códigos de meios de pagamento, configurações e menus para a lista de códigos nesta
configuração.

**Observação** : os valores no arquivo de configurações, detalhadas nos próximos itens, não tem efeito quando a
automação comercial utiliza a restrição em tempo de execução descrita neste item.

##### 6.17.2 Definindo valores padrão para formas de pagamento

Neste caso o ambiente de vendas do cliente não comporta determinado tipo de modalidade de pagamento por
não se aplicar ao seu ramo de negócio. Um exemplo disso é um estabelecimento comercial onde todas as vendas
somente podem ser feitas à vista. Para esse tipo de aplicação é possível definir essa configuração no arquivo de
parâmetros da CliSiTef de forma que, caso o lojista opte no futuro a aceitar outras modalidades de pagamento,
basta alterar a configuração da CliSiTef, sem ser necessário alterar o aplicativo de automação. Essa configuração é
feita através do parâmetro TransacoesHabilitadas a ser colocado na seção [Geral] do arquivo CliSiTef.ini.

```
O formato desse parâmetro é o seguinte:
```
```
[Geral]
TransacoesHabilitadas=<Tipo do meio de pagamento>;<Tipo do meio de pagamento>;...
```
```
onde cada um dos sub-campos possui a mesma descrição do item anterior.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 92 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
Utilizando o mesmo exemplo do item anterior, para limitar as transações apenas as de pagamento à vista e sem
cheque, a definição será:

```
[Geral]
TransacoesHabilitadas=16;26
```
##### 6.17.3 Habilitação de transações adicionais

Por questões de compatibilidade com versões anteriores da biblioteca e também pelo fato de algumas
funcionalidades da mesma não serem de uso geral, existem algumas formas de pagamento que não estão
habilitadas por padrão, sendo necessário que o cliente informe explicitamente que deseja utilizá-las. Isso é feito
através do arquivo de configuração CliSiTef.ini pelo parâmetro _TransacoesAdicionaisHabilitadas_ a ser incluído na
seção [Geral]. O formato desse parâmetro é o seguinte:

```
[Geral]
TransacoesAdicionaisHabilitadas=<Tipo do meio de pagamento>;...
```
```
Onde cada um dos sub-campos possui a mesma descrição dos itens anteriores.
```
Consulte a Tabela de códigos de meios de pagamento, configurações e menus para a lista de códigos nesta
configuração.

```
Os menus que hoje não estão habilitados por padrão são os seguintes:
```
```
Cartão Refeição Eletrônico
```
```
Recarga de celular com cartões de débito ou crédito
```
```
Pagamento de Benefícios e respectivo estorno
```
```
Leitora SmartNet para cartões SmartVR e Sodexho com chip
```
```
Correspondente Bancário
```
```
Paggo
```
```
Débito Digitado
```
```
Extrato CB
```
```
Consulta Saldo CB
```
```
Saque e estorno de saque CB
```
```
Depósito e estorno de depósito CB
```
```
Recarga de Celular Bradesco
```
```
Recarga de Celular Corban SE
```
```
Extrato CB
```
```
Pagamento e Estorno de DARF
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 93 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Pagamento e Estorno de GPS
```
```
Empréstimo Pré-Aprovado
```
```
Abertura de Conta
```
```
Troco Premiado (Surpresa)
```
```
Vale Gás
```
```
Opção Administrativa Redecard
```
```
Cartão Combustível
```
```
Cartão Presente
```
Exemplificando, para habilitar o menu de pagamento com cartão Refeição Eletrônico deve-se incluir a seguinte
configuração em CliSiTef.ini:

```
[Geral]
TransacoesAdicionaisHabilitadas=20
```
##### 6.17.4 Desabilitando transações

De forma análoga às transações adicionais habilitadas do item anterior, é possível desabilitar algumas
transações sem a necessidade de especificar todo o intervalo de operações como nas restrições.

Para tanto, inclua na seção Geral o campo TransacoesDesabilitadas, indicando as transações que serão
desabilitadas ao longo do fluxo transacional.

```
[Geral]
TransacoesDesabilitadas=<Tipo do meio de pagamento>;...
```
Consulte a Tabela de códigos de meios de pagamento, configurações e menus para a lista de códigos nesta
configuração.

#### 6.18 Habilitação de transações de redes específicas

Existem algumas redes que, por não serem de uso generalizado, não estão automaticamente habilitadas na
CliSiTef. Neste caso, para habilitá-las, existe a seção [Redes] no arquivo de configuração CliSiTef.ini e que deve
conter o nome da variável correspondente a rede a ser habilitada com o valor 1.

Caso o estabelecimento trabalhe com mais de uma rede das descritas a seguir, deve ser incluída uma linha para
cada rede.

```
[Redes]
HabilitaRede xxxx =1
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 94 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Onde xxxx pode ser, na presente versão da CliSiTef, um dos seguintes valores abaixo^7.
```
Note que é possível habilitar tantas redes quanto necessário, desde que elas estejam habilitadas no SiTef de
forma compatível.

```
Rede
ACSP
Algorix
Avista
BancoIbi
BancoMercantil
BancoPanamericano
BancoProvincial
BOD
BODDebito
BrazilianCard
CdlPoa
CentralCard
CheckCheck
Cisa
Citibank
ClubCard
CompreMax
Condor
ConsorcioVenezuela
ConsultaValePapel
CooperCred
CredMais
CTF
DDTotal
Dotz
Edenred
Ediguay
Eletrozema
EMS
Fidelize
Formosa
FoxWinCards
Givex
Hiperlife
HotCard
ICards
InfoCard
InComm
```
(^7) Consulte documentos de produtos específicos para outros códigos de redes


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 95 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Rede
JGV
MAR
Mettacard (antigo Consignum)
Neus
Oboe
Omnion
Orbitall
Parati
Platco
PortalCard
Qualicard
Repom
SigaCred
SisCred
Softway
SpcBrasil
SQCF
Starfiche
Sysdata
Telecheque
Teledata
TopCard
Total
Tricard
UpSight
UseCred
Validata
Wappa
```
#### 6.19 Tabela de códigos de meios de pagamento, configurações e menus

A seguir está a tabela que relaciona os tipos de meio de pagamento, configurações e menus, com os respectivos
códigos, para serem utilizados nos itens anteriores^8.

```
Tipo do meio de pagamento Código
Consulta ou garantia de Cheque (todos os tipos) 10
Consulta Cheque Serasa/Associação Comercial 11
Consulta Cheque Tecban 12
Telecheque Garantido Tecban 13
Garantia Cheque Papel Tecban 14
Cartão de débito (todas as combinações) (Descontinuado, não usar) 15
Cartão de débito a vista 16
```
(^8) Consulte documentos de produtos específicos para outros códigos de restrições


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_96_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Tipo do meio de pagamento Código
Cartão de débito pré-datado 17
Cartão de débito parcelado 18
Cartão de débito CDC 19
Cartão Refeição Eletrônico (Exceto Visanet, neste caso usar 3014) 20
Voucher Papel 21
Cartão Benefício 22
Cartão SmartVR/Sodexho com leitora SmartNet 23
Cartão de crédito a vista com juros 24
Cartão de crédito (todas as combinações) (Descontinuado, não usar) 25
Cartão de crédito a vista 26
Cartão de crédito parcelado com financiamento do estabelecimento 27
Cartão de crédito parcelado com financiamento da administradora 28
Cartão de crédito digitado 29
Cartão de crédito magnético 30
Pré-autorização 31
Cartão Fininvest 32
Saque com cartão Fininvest 33
Cartão de Crédito Pró-rata a vista 34
Cartão de Crédito Pró-rata parcelada 35
Consulta parcelas no Cartão de Crédito 36
Crédito Cisa 37
Saldo/Extrato Cisa 38
Cartão Crédito Infocard 39
Cancelamento de transação com cartão de crédito ou débito 40
Consulta AVS 41
Débito Digitado 42
Débito Magnético 43
Crédito Parcelado 44
Private Label Pré-Datado 45
Pagamento Dinheiro 46
Pagamento Private Label com Cheque 47
Paggo 48
Garantia Cheque CDL Rio 49
Pagamento de Conta 50
Estorno de pagamento de conta 51
Re-impressão de pagamento de conta 52
Pagamento de Benefício 53
Estorno do Pagamento de Benefício 54
Tratamento de troco no pagamento de contas com dinheiro 55
Reimpressão 56
Reimpressão do Último Comprovante 57
Reimpressão Específica 58
Recarga de celular com Dinheiro 60
Recarga de celular com Cheque 61
Recarga de celular com cartão de débito a vista 62
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_97_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Tipo do meio de pagamento Código
Recarga de celular com cartão de crédito a vista 63
Indica o Menu para seleção da operadora de recarga 64
Reimpressão do lojista 70
Reimpressão do portador do cartão 71
Todas as reimpressões 72
Crédito Centralizado 73
Consulta de Saldo - Corresponde Bancário 74
Saque - Corresponde Bancário 75
Estorno de Saque - Corresponde Bancário 76
Depósito - Corresponde Bancário 77
Estorno de Depósito - Corresponde Bancário 78
Conta Corrente 79
Conta Poupança 80
Conta Benefício 81
Conta Salário 82
Conta Empresa 83
Conta Investimento 84
Conta Funcionário Viajante 85
Consulta de Saldo com Cartão Magnético - Corresponde Bancário 86
Consulta de Saldo com Digitação dos Dados da Conta - CB 87
Saque de Benefício INSS - Corresponde Bancário 88
Saque com Cartão Magnético - Corresponde Bancário 89
Saque com Cheque - Corresponde Bancário 90
Saque com Recibo de Retirada - Corresponde Bancário 91
Estorno de Saque de Benefício INSS - Corresponde Bancário 92
Estorno de Saque com Cheque - Corresponde Bancário 93
Estorno de Saque com Recibo de Retirada - Corresponde Bancário 94
Estorno de Depósito com Dinheiro - Corresponde Bancário 95
Estorno de Depósito com Cheque - Corresponde Bancário 96
Estorno de Depósito com Dinheiro + Cheque – CB 97
Consulta Cheque SPC Brasil 98
Garantia Cheque SPC Brasil 99
Tipo Conta: FAL 3000
Tipo Conta: Pontos 3001
SCCard 3002
Consulta Saldo Débito 3003
Consulta Saldo Crédito 3004
Recarga de Celular Bradesco 3005
Reimpressão Específica Redecard 3006
Reimpressão Específica Visanet 3007
Troco Surpresa (Premiado) 3008
Pagamento em dinheiro 3009
Pagamento CB em cheque 3010
Pagamento com TEF Débito 3011
Pagamento com TEF Crédito 3012
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_98_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Tipo do meio de pagamento Código
Pagamento em outra forma 3013
Produtos de Vales da Cielo 3014
ValeGás 3015
ValeGás Ultragaz 3016
ValeGás GetNet 3017
Pagamento de Conta Orbitall 3018
Estorno de pagamento de Conta Orbitall 3019
Cartão Combustível 3020
Cartão Combustível Digitado 3021
Cartão Combustível Magnético 3022
Cartão Débito Pré-Pago 3023
Consulta Saldo Cartão Débito Pré-Pago 3024
Cartão Crédito Código em Barras 3025
Cartão Presente 3026
Opção Administrativa Redecard 3027
Cartão Presente Magnético 3028
Cartão Presente Digitado 3029
Cartão Presente Código em Barras 3030
Opção Compra e Saque Redecard 3031
Pagamento de Fatura 3032
Pagamento de Convênio 3033
Saque Banco IBI 3034
Estorno de Saque Banco IBI 3035
Pagamento de Fatura Banco IBI 3036
Estorno de Pagamento de Fatura Banco IBI 3037
Saldo SPTrans 3038
Recarga SPTrans 3039
Garantia Cheque Infocard 3040
Estorno Garantia Cheque Infocard 3041
Garantia Cheque CDL-Poa 3042
Extrato 3043
Extrato Magnético 3044
Extrato Digitado 3045
Recarga Corban SE 3046
Saque Crédito 3047
Estorno de Saque Crédito 3048
Consultas de Cartão de Crédito 3049
Extrato Cartão de Crédito 3050
Saldo Convênio Crédito 3051
Consulta Liberação de Cartão Crédito 3052
Consulta Última Fatura de Cartão Crédito 3053
Altera Senha de Cartão Crédito 3054
Libera Cartão de Crédito 3055
Produtos SPTrans 3056
DARF 3057
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_99_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Tipo do meio de pagamento Código
GPS 3058
DARF Simples 3059
DARF Preto 3060
Estorno DARF 3061
Estorno GPS 3062
Empréstimo Pré-Aprovado 3063
Empréstimo Pré-Aprovado Magnético 3064
Empréstimo Pré-Aprovado Digitado 3065
Abertura de Conta 3066
Conta Individual 3067
Conta Conjunta E / OU 3068
Conta Conjunta E (Solidária) 3069
Pagamento de Conta Infocard 3070
Estorno de Pagamento de Conta Infocard 3071
Pagamento de Conta Banrisul 3072
Pagamento de Conta Central Card 3073
Pagamento de Conta Portal Card 3074
Pagamento de Conta Softway 3075
Pagamento de Conta Parati 3076
Pagamento de Conta Ediguay 3077
Pagamento de Conta CooperCred 3078
Pagamento de Conta Validata 3079
Pagamento de Conta Panamericano 3080
Pagamento de Conta SigaCred 3081
Pagamento de Conta UseCred 3082
Pagamento de Conta SisCred 3083
Pagamento de Conta Fininvest (Menu principal) 3084
Estorno de Pagamento de Conta Banrisul 3085
Estorno de Pagamento de Conta Fininvest 3086
Estorno de Pagamento de Conta Central Card 3087
Estorno de Pagamento de Conta Portal Card 3088
Estorno de Pagamento de Conta Softway 3089
Estorno de Pagamento de Conta Ediguay 3090
Estorno de Pagamento de Conta CooperCred 3091
Estorno de Pagamento de Conta Panamericano 3092
Estorno de Pagamento de Conta SigaCred 3093
Estorno de Pagamento de Conta UseCred 3094
Estorno de Pagamento de Conta SisCred 3095
Repasse CB 3096
Administrativo CB 3097
Administrativo CB Banrisul 3098
Pagamento de Conta Cartão EMS 3099
Estorno de Pagamento de Conta Cartão EMS 3100
Código Resumido EMS 3101
Código de Barras do Carnê 3102
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_100_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Tipo do meio de pagamento Código
Digitação do Dados do Carnê 3103
Menu de Consultas EMS 3104
Consulta Rápida EMS 3105
Consulta Extrato EMS 3106
Consulta Milhas EMS 3107
Consulta Mini-Extrato EMS 3108
Registro de Ocorrência EMS 3109
Registro de Cancelamento de Ocorrência EMS 3110
Inclusão de Cliente EMS 3111
Alteração de Dados Cadastrais Cliente EMS 3112
Consulta Dados Cadastrais Cliente EMS 3113
Transação EMS por Cartão Magnético 3114
Transação EMS por Digitação do Cartão 3115
Transação EMS por Digitação do CPF 3116
Extrato EMS Parcial 3117
Extrato EMS Total 3118
Sexo Masculino 3119
Sexo Feminino 3120
Menus de Vendas EMS 3121
Venda Cartão EMS 3122
Venda EMS Outros Meio de Pagamento 3123
Venda EMS A Vista 3124
Venda EMS Parcelada Sem Juros 3125
Venda EMS Parcelada Com Juros 3126
Venda Normal EMS 3127
Venda Forçada EMS 3128
Compra EMS Vinculada a Lista de Presentes 3129
Compra EMS Outros Vínculos 3130
Venda EMS - Dinheiro 3131
Venda EMS - Cheque a Vista 3132
Venda EMS - Cheque Pré 3133
Venda EMS – Cartão de Débito 3134
Venda EMS – Cartão de Crédito 3135
Venda EMS – Ticket 3136
Venda EMS – Cheque Administrativo 3137
Venda EMS – Traveller Check 3138
Venda EMS – Desconto em Folha 3139
Venda EMS – Vale 3140
Venda EMS - Milhas 3141
Venda EMS - Debito em folha 3142
Venda EMS – Voucher 3143
Venda EMS – Cartão Presente 3144
Venda EMS – Private Label 3145
Venda Rotativo A Vista Fininvest 3160
Venda Rotativo Pré-Datado Fininvest 3161
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_101_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Tipo do meio de pagamento Código
Venda Parcelado Fininvest 3162
Venda Parcelado Pré-Datado Fininvest 3163
Saque Rotativo Fininvest 3164
Saque Parcelado Fininvest 3165
Consulta Saque Fininvest 3166
Saque Fininvest 3167
Boleto Bancário 3168
Contrato 3169
Pagamento de Conta Fininvest 3170
Pagamento de Fatura Fininvest 3171
Documento Provincial 3172
Documento Não Provincial 3173
Com Provimillhas 3174
Sem Provimilhas 3175
Débito Parcelas Iguais 3176
Consulta Cheque Banco Provincial 3177
Consulta Cheque BOD 3178
Garantia Cheque Banco Mercantil 3179
Consulta Cheque Consorcio Venezuela 3180
Fechamento do Lote Atual Banco Mercantil 3181
Fechamento de Lote Especifico Banco Mercantil 3182
Ajuste de Compra 3183
Ajuste de Compra Débito 3184
Ajuste de Compra Crédito 3185
Consulta Totais de Compra Banco Provincial 3186
Consulta Totais A Pagar Banco Provincial 3187
Consulta Estado Lote Banco Provincial 3188
Fechamento de Lote Banco Provincial 3189
Fechamento de Lote BOD 3190
Fechamento de Lote Banco Mercantil 3191
Vale Refeição (Exceto Visanet) 3192
Vale Alimentação (Exceto Visanet) 3193
Venda Milhagem CooperCred 3194
Cancelamento de Venda Milhagem CooperCred 3195
Consulta de Saldo Cisa 3196
Consulta de Extrato Cisa 3197
Consulta de Saldo Softway 3198
Saque Softway 3199
Cancelamento de Saque Softway 3200
Carga de Pré-Pago 3201
Cancelamento de Carga de Pré-Cargo 3202
Executa Teste de Comunicação 3203
Transações de Correspondente Bancário 3204
Transações de Recarga de Celular 3205
Transações SPTrans 3206
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_102_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Tipo do meio de pagamento Código
SCCard 3207
Provedor Wappa 3208
Abertura de Caixa CB 3209
Fechamento de Caixa CB 3210
Sangria de Caixa CB 3211
Menu cartão Condor 3212
Opção crédito parcelado simples 3213
Pagamento cartão Condor 3214
Estorno pagamento cartão Condor 3215
Consulta extrato Condor 3216
Cancelamento Parcele mais 3217
Menu Starfiche 3218
Menu saque CB Banrisul 3219
Pagamento de conta UP SIGHT 3220
Estorno de Pagamento de conta UP SIGHT 3221
Menu opção NTPC 3222
Menu NTPC 3223
Pagamento com saque 3224
Recarga de celular com saque 3225
Troca de Senha Supervisor PinPad 3226
Menu Crédito CDC 3227
Opção conta pessoa jurídica 3228
Pagamento de conta rede MAR 3229
Estorno pagamento de conta rede MAR 3230
Pagamento de conta rede iCards 3231
Estorno de pagamento de conta rede iCards 3232
Menu opção Liberação Crédito Coopercred 3236
Menu opção Liberação Débito Coopercred 3237
Menu opção Recarga Débito Digitado Coopercred 3238
Menu opção Recarga Débito Magnético Coopercred 3239
Menu opção crédito a vista Resgate Pontos 3261
Menu pagamento de conta Oboé 3262
Menu acúmulo de pontos Oboé 3263
Menu cancelamento acúmulo de pontos Oboé 3264
Menu venda crédito com autorização à vista 3267
Menu opção cartão magnético (PBM) 3270
Menu opção cartão digitado (PBM) 3271
Menu opção código de autorização (PBM) 3272
Menu pagamento de conta Qualicard 3276
Menu estorno de pagamento de conta Qualicard 3277
Menu de autorização genérica SEM 3278
Menu pagamento de conta rede Avista 3279
Menu cartão virtual Formosa 3280
Menu pagamento de contas Neus 3281
Menu estorno de pagamento de contas Neus 3282
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_103_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Tipo do meio de pagamento Código
Menu pagamento de contas Algorix 3283
Menu estorno de pagamento de contas Algorix 3284
Menu carga de cartão presente Algorix 3285
Menu de cancelamento de carga de cartão presente Algorix 3286
Menu venda crédito CompreMax 3287
Menu cancelamento CompreMax 3288
Menu cancelamento Cartão Combustível 3289
Menu pagamento de contas SysData 3296
Menu estorno de pagamento de contas SysData 3297
Menu consulta de pagamento Validata 3298
Menu pagamento recarga SPTrans (Menu gerencial) 3299
Menu pagamento de conta SQCF 3303
Menu cancelamento de pagamento de conta SQCF 3304
Menu cartão Qualidade (ICI Card) 3305
Menu opção Saque Crédito Transferência 3306
Menu opção Cancelamento Saque Crédito Transferência 3307
Menu saque GetNet 3319
Menu estorno de saque GetNet 3320
Resgate Plataforma Promocional (Cielo) 3323
Menu conta especial 3324
Menu conta fidelidade 3325
Menu outra conta 3326
Menu fechamento de lote Platco 3327
Menu registro de gorjeta 3328
Menu consulta última venda 3329
Menu garantia de cheque Platco 3330
Menu devolução Platco 3331
Menu pagamento recarga SPTrans (Menu específico) 3334
Menu Pagamento Conta FoxWin Cards 3335
Menu estorno de Pagamento Conta FoxWin Cards 3336
Menu Pagamento Conta HotCard 3337
Menu estorno de Pagamento Conta HotCard 3338
Menu Adm Gift 3339
Consulta Saldo de Cartão Gift 3340
Recarga de Cartão Gift 3341
Cancelamento de Recarga de Cartão Gift 3342
Venda com Cartão Gift 3343
Cancelamento de Venda com Cartão Gift 3344
Menu Cancelamento Gift 3345
Tipo de conta FAL 3346
Tipo de conta principal 3347
Menu Emissão de Pontos 3348
Menu Cancelamento de Emissão de Pontos 3349
Menu Resgate de Pontos 3350
Menu Cancelamento de Resgate de Pontos (não usado ainda) 3351
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_104_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Tipo do meio de pagamento Código
Menu Opcão Cartão Pré Pago Digitado 3352
Menu Pagamento TriCard 3353
Menu Extrato Por Período (CB) 3363
Menu Extrato – Últimos Lançamentos (CB) 3364
Menu Extrato – Últimos Dias (CB) 3365
Menu Desbloqueio de Cheques (CB) 3366
Menu Opção de Pagamento c/ cartão de Débito CB 3367
Menu de Transferência de Contas – CB 3368
Menu Revalidação de Senha INSS – CB 3369
Menu Depósito Identificado – CB 3370
Menu Nome do Depositante (Depósito Identificado CB) 3371
Menu Código do Depositante (Depósito Identificado CB) 3372
Menu Cartão de Pagamento (Depósito Identificado CB) 3373
Menu Pagamento de Fatura (Depósito Identificado CB) 3374
Menu opção de Pagamento c/ cartão Digitado (CB) 3375
Menu opção de Pagamento c/ cartão Magnético (CB) 3376
Menu opção Pagamento de Fatura Digitado (CB) 3377
Menu opção Pagamento de Fatura Magnético (CB) 3378
Menu Pagamento de Fatura genérico 3379
Menu opção Pré Autorização Cartão Combustível 3389
Menu Ativação Gift 3390
Menu Pagamento Dinheiro – Ativação Gift 3391
Menu Pagamento Cheque – Ativação Gift 3392
Menu Pagamento Cartão Débito – Ativação Gift 3393
Menu Pagamento Cartão Crédito – Ativação Gift 3394
Menu Pagamento ClubCard 3407
Menu Estorno Pagamento ClubCard 3408
Menu Pagamento Citibank 3409
Menu opção Cartão Porto Seguro Auto Magnético 3410
Menu opção Cartão Porto Seguro Auto Digitado 3411
Menu Saque ClubCard 3412
Menu Pagamento CredMais 3466
Menu Consulta parcelas crédito 3480
Menu Estorno Pagto. Contas Banco Ibi 3500
Menu Cartao Eletrozema 3510
Menu Cancelamento Cartao Eletrozema 3511
Menu Consulta Eletrozema 3512
Menu Cancelamento de Pagamento de Fatura genérico 3515
Cartão EGift (Hug) 3517
Menu Alteração de Pré-Autorização 3519
Menu formas de pagamento para pagamento de cartão Siscred 3530
Saque Gift 3553
Cancelamento de saque Gift 3554
Cancelamento de ativação Gift 3556
Carga de tabelas no pinpad 3624
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_105_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Tipo do meio de pagamento Código
Carga forcada de tabelas no pinpad (Local) 3625
Carga forçada de tabelas no pinpad (SiTef) 3626
Consulta Saldo – Alelo (Cielo) 3653
Atualiza Chip -Alelo (Cielo) 3654
Debito Alelo Auto (Cielo) 3655
Reimpressão Especifica Outros 3675
Menu Administrativo WayUp 3700
Acúmulo de Pontos WayUp 3701
Resgate de Pontos WayUp 3702
Consulta Saque WayUp 3703
Prospecção de Portador WayUp 3704
Menu de Cancelamentos WayUp 3705
Cancelamento de Acúmulo WayUp 3706
Cancelamento de Resgate WayUp 3707
Menu Código de Barras (Tipo de documento – Débito\Crédito para pagamento de carnê) 3720
Menu CPF (Tipo de documento – Débito\Crédito para pagamento de carnê) 3721
Menu Número do Cartão (Tipo de documento – Débito\Crédito para pagamento de carnê) 3722
Menu Outros (Tipo de documento – Débito\Crédito para pagamento de carnê) 3723
Menu Adesão de Seguro Tricard 3742
Menu Recarga de cartão de crédito 3744
Menu Cancelamento de recarga de cartão de crédito 3745
Menu Consulta Saldo Tricard 3746
Menu Recarga de cartão de débito Coopercred 3772
Menu Cancelamento de recarga de cartão de débito Coopercred 3773
Pagamento em Dinheiro Ultragáz Revenda 3900
Pagamento com TEF Crédito Ultragáz Revenda 3901
Pagamento com TEF Débito Ultragáz Revenda 3902
Menu IATA à Vista 3958
Menu IATA Parcelado Estabelecimento 3959
Menu IATA Parcelado Administradora 3960
Menu Simulação Crediário 3989
Menu Outros Cielo 4158
Recarga Celular com Carteira Digital 4162
Recarga Celular com PIX 4163
Menu Venda Crédito Banco Ibi 4193
Menu Cancelamento Venda Crédito Banco Ibi 4194
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 106 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 6.20 Habilitação de configurações especiais por transação

Em determinadas transações, é possível incluir novas funcionalidades e características ao fluxo transacional,
permitindo maior flexibilidade de operação sem que estas funcionalidades não estejam vinculadas a um meio de
pagamento específico.

Para tanto, basta acrescentar um novo campo ao parâmetro “ _ParamAdic_ ”, presente nas funções que iniciam o
processo de pagamento ou Correspondente Bancário ( _IniciaFuncaoSiTefInterativo_ e
_CorrespondenteBancarioSiTefInterativo_ ). O formato deste campo é o seguinte:

```
{<Funcionalidade1>;<Funcionalidade2>;...;<Funcionalidaden>;};
```
Note que neste formato as funcionalidades estão entre chaves (‘{’ e ‘}’), ao passo que as restrições estão entre
colchetes (‘[’ e ‘]’).

Exemplo: no processo de venda exemplificado no item 5.1, suponha que o valor da venda possa ser alterado
durante o fluxo, e que o aplicativo da automação deseje fazer seu tratamento, então o valor do parâmetro
“ _ParamAdic_ ” deve ser:

```
[10;17;18;19;27;28;34;35;];{TrataPagamentoExtendido=1;}
```
```
A seguir, descrevemos as funcionalidades previstas neste campo.
```
```
Funcionalidade Descrição
CodigoCliente=xxxxxx Código de cliente de uma determinada loja, limitado a 36
caracteres, a ser vinculado nos relatórios do SiTef Web.
ExecutaAteLeituraCartao=0 Se um arquivo de chaves .CHA estiver presente no servidor Sitef,
então, a CliSiTef se comporta da seguinte maneira: Se a CliSiTef
estiver sem comunicação com o Sitef, ao invés de retornar um erro
de comunicação, a CliSiTef continua o fluxo da transação até a
leitura do cartão. Para inibir este comportamento, utilizar a
funcionalidade ao lado.
HabilitaVendaViaCodigoBarras=1 Este parâmetro informa a CliSiTef que a opção de venda crédito
através de cartões gravados em código em barras deve ser
habilitada na transação corrente. Lembrando que além dessa
configuração a opção de menu (3025) também deve estar
habilitada.
ItemMenuIdentificado=1 O aplicativo de automação informa a CliSiTef que ele está
preparado para tratar o comando de menu com itens identificados
(comando 42).
Quando esse parâmetro está habilitado a CliSiTef substitui a
utilização do comando 21 pelo comando 42, na maior parte dos
menus utilizados na navegação.
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_107_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Funcionalidade Descrição**
{MKRede=A,B,C,D}

OBS: Esta configuração deve ser passada
entre chaves ({}) separadamente, ou seja,
não deve ser concatenada com nenhuma
outra configuração separada por ponto-e-
vírgula (;)

Configuração válida somente para CliSiTef Reduzida Redecard. Os
parâmetros A,B,C,D são índices das chaves de criptografia
Redecard nos POS’s. Esses parâmetros irão sobrepor os índices das
chaves recebidos no serviço 3. Os parâmetros C e D serão
implementados somente a partir da versão (4.0.104.1, a
confirmar). Se alguma chave não for configurada é preciso passar
o parâmetro com valor -1. Exemplo: {MKRede=-1,-1,-1,2} vai
configurar somente a chave relativa à criptografia DUKPT 3DES.
A = Índice da master key DES
B = Índice da master key 3DES
C = Índice do registro de tratamento DUKPT DES
D = Índice do registro de tratamento DUKPT 3DES
{MKRedeDados=A,B,C,D}

OBS: Esta configuração deve ser passada
entre chaves ({}) separadamente, ou seja,
não deve ser concatenada com nenhuma
outra configuração separada por ponto-e-
vírgula (;)

```
Igual a MKRede (Ver descrição acima), exceto que as chaves de
criptografia serão usadas para criptografar trilhas.
```
NumCartaoCripto=<Cartão criptografado> O fornecimento do campo adicional “NumCartaoCripto”, com o
cartão criptografado, desabilita a captura do número do cartão
digitado. Este parâmetro depende da correta configuração do
arquivo de chaves .cha no **servidor SiTef** , isto é, com as chaves de
criptografia correspondentes.
RedeDestino=nnnn Esta configuração permite forçar que a transação seja realizada
por uma rede específica (nnnn = 4 dígitos numéricos). Consulte o
item 0 - Transações crédito/débito com cartão sem BIN.
TrataConsultaSaqueComSaque=1 Inicialmente projetada para transações do Banco Ibi, este
parâmetro permite vincular, em uma única transação, a “Consulta
a Saque” e “Saque”.
Caso seja passado este parâmetro, o menu administrativo
oferecerá somente a opção “Consulta Saque com Saque”.
TrataPagamentoExtendido=1 Esta função informa que o aplicativo da automação está
preparado para tratar informações de recebimento a menor (falta
saldo a ser recebido com outra forma de pagamento) ou a maior
(deve ser devolvido um troco para o cliente).
Esta função também habilita o recebimento dos campos **137**
(Saldo a ser pago) e **138** (Valor efetivamente recebido).
ValidadeCartao=<AAMM ou MMAA> A entrega do campo adicional “ValidadeCartao”, com a data de
validade do cartão, desabilita a sua captura, porém a utilização do
valor passado através do parâmetro adicional é condicionada à
passagem bem sucedida do campo “NumCartaoCripto”.
ValorIncluiTaxa=1 Este parâmetro informa que o aplicativo da automação incluiu no
valor compra o valor da taxa de embarque ou serviço.
Se durante o fluxo de captura for solicitada a taxa, o valor que foi
acrescentado à venda deve ser repassado pela automação.


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_108_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Funcionalidade Descrição**
TipoDocFiscal=x Indica o tipo de Documento Fiscal emitido pela “Automação
Comercial”.
Onde x:
0 - Cupom Fiscal (Cupom Fiscal - Legado)
1 - NFC-e (Nota Fiscal Consumidor - Eletrônica)
2 – SAT-CF-e (Cupom Fiscal - Eletrônico)

```
OBS:. Na ausência desta “funcionalidade”, a CliSiTef assume que
o “Documento Fiscal” emitido é do tipo ‘0’ (Cupom Fiscal -
Legado).
```
. Qualquer valor de ‘x’ diferente dos definidos, a transação será
abortada pela CliSiTef indicando parâmetros inválido.
ChaveAcessoDocFiscal=<Dados da chave> Chave de acesso do Documento Fiscal Eletrônico (tamanho 44
digitos). Necessário informar quando “TipoDocFiscal” for igual a ‘1’
ou ‘2’.

```
OBS:. Na ausência desta “funcionalidade” para “TipoDocFiscal”
igual a ‘1’ ou ‘2’, ou na presença da ”funcionalidade” para
“TipoDocFiscal” igual a ‘0’, a transação será abortada pela CliSiTef
indicando parâmetros inválidos.
```
```
Exemplos:
{TipoDocFiscal=0}
```
```
{TipoDocFiscal=1;ChaveAcessoDocFiscal=1111111111222222222
233333333334444}
```
{TipoDocFiscal=2;ChaveAcessoDocFiscal=5555555555666666666
677777777778888}
CPFColetado=XXXXXXXXXXX A coleta default do CPF é realizada pelo PinPad, quando solicitado
na transação. Caso a automação comercial já o tenha capturado
anteriormente, ou já o possua por algum motivo, e não quer que
o usuário tenha que digitar novamente o dado no pinpad, deve-se
passá-lo via parâmetros adicionais.
Inicialmente previsto para utilização com Carteiras Digitais, surgiu
a necessidade de utilização com outros produtos.

```
Exemplo:
{CPFColetado=99966633300;}
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 109 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Funcionalidade Descrição
SPLITPAY:Estab1=Valor1|Estab2=Valor2|...
|Estab5=valor5
```
```
Este prefixo poderá ser enviado nas transações de
Crédito/Débito/Cancelamentos. Podem ser informados até 5
códigos de estabelecimentos.
IMPORTANTE: O código de estabelecimento do vendedor
principal não deve fazer parte dos estabelecimentos do Split, que
deve conter apenas dados dos vendedores secundários.
O código do estabelecimento deve ser um CNPJ válido de no
máximo 15 dígitos, e o valor, 12 dígitos, considerando os 2 últimos
dígitos como casas decimais. Campos menores serão completados
com zeros a esquerda. Campos formatados serão considerados
apenas os dígitos. O valor associado é opcional.
O caracter ‘|’ serve de separador quando houver vários conjuntos
de dados.
```
```
Exemplos:
{SPLITPAY:1222555000101=500|111222111000101=0000000010
00|111.222.333/0001-01=15,00|111.222.444/0001-01;};
```
#### 6.21 Transações crédito/débito com cartão sem BIN

Em determinadas transações, em que o aplicativo da automação deseje utilizar um cartão especial (sem BIN
definido), é necessário passar algumas restrições, e para isso existem duas formas:

Indicando a configuração “RedeDestino” no parâmetro “ParamAdic”, presente nas funções que iniciam o
processo de pagamento (IniciaFuncaoSiTefInterativo) ou Correspondente Bancário
(CorrespondenteBancarioSiTefInterativo), conforme exemplo a seguir:

```
{RedeDestino= nnnn }
```
```
Onde nnnn é o código da rede a qual pertence o cartão especial (vide tabela abaixo).
```
Indicando esta rede especial, a qual pertence o cartão especial, no arquivo de configuração da CliSiTef
(“CliSiTef.ini”).

Para tanto, indique nas seções Debito, Credito, CartaoCombustivel, Gift, SaqueCredito ou SaqueDebito, os pares
(Texto, Rede) correspondentes ao texto que será exibido e o código de rede.

```
[Debito]
Texto1=SomarCard
Rede1=172
```
```
Texto2= StarFiche
Rede2=178
```
```
TextoN=MinhaRede
RedeN=nnnn
```
```
[Credito]
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 110 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Texto1=SomarCard
Rede1=172
```
```
Texto2= StarFiche
Rede2=178
```
```
Texton=MinhaRede
Reden=nnnn
```
```
[CartaoCombustivel]
Texto1=FitCard
Rede1=263
```
```
[CartaoGift]
Texto1=Condor
Rede1=174
TextoN=MinhaRede
RedeN=nnnn
```
```
[SaqueCredito]
Texto1= Condor
Rede1=174
TextoN=MinhaRede
RedeN=nnnn
```
```
[SaqueDebito]
Texto1= Condor
Rede1=174
TextoN=MinhaRede
RedeN=nnnn
```
Através do arquivo de configuração é permitido definir até 5 redes de débito, 5 redes de crédito crédito, 5 redes
de combustível, 5 redes de gift, 5 redes de SaqueCrédito e 5 redes de SaqueDébito. Feito isso, quando a automação
realizar uma transação com uma das modalidades descritas acima, a CliSiTef apresentará um menu com todas as
redes definidas e com a opção de débito, crédito, combustível, gift, SaqueCredito ou SaqueDebito em que é
realizada a consulta de bins.

Além disso, é necessário definir se a rede em questão permite a captura do cartão através do leitor magnético
ou através de digitação, com a configuração das seguintes chaves:

- HabilitaDigitadoN = 1
- HabilitaMagneticoN = 1

Para a seção [CartaoCombustivel] também pode ser habilitada a leitura de código de barras através da
configuração abaixo:

- HabilitaCodBarN = 1

```
Para as transações Gift efetuar as seguintes configurações abaixo para habilitar os seguintes modos de entrada:
```
- HabilitaDigitadoN: Habilitar o modo de entrada EAN 13.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 111 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
- HabilitaCodUnitarioGiftN: Habilitar o modo de entrada EAN 128.
- HabilitaEgiftDigitadoGiftN: Essa coleta é utilizada quando o autorizador emitir um número virtual que
    pode ser um número enviado por email. Esse número será utilizado com o
    cartão, será solicitado a entrada do número do Egift.

Exemplo:

```
[Debito]
Texto1=SomarCard
Rede1=172
```
```
Texto2=StarFiche
Rede2=178
```
```
Texto3=Libercard
Rede3=196
HabilitaDigitado3=1
HabilitaMagnetico3=0
```
```
Texto4=VeroPay
Rede4=21
HabilitaDigitado4=1
HabilitaMagnetico4=0
```
```
[Credito]
Texto1=SomarCard
Rede1=172
```
```
Texto2= StarFiche
Rede2=178
```
```
Texto3=Libercard
Rede3=196
HabilitaDigitado3=1
HabilitaMagnetico3=0
```
```
[CartaoCombustivel]
Texto1=FitCard
Rede1=263
HabilitaDigitado1=0
HabilitaMagnetico1=1
HabilitaCodBar1=0
```
```
[CartaoGift]
Texto1=Condor
Rede1=174
HabilitaDigitado1=0
HabilitaMagnetico1=1
HabilitaCodBar1=0
HabilitaCodUnitarioGift1=0
HabilitaEgiftDigitadoGift1=0
```
```
[SaqueCredito]
Texto1= Condor
Rede1=174
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 112 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
TextoN=MinhaRede
RedeN=nnnn
HabilitaDigitadoN=0
HabilitaMagneticoN=1
```
```
[SaqueDebito]
Texto1= Condor
Rede1=174
```
```
TextoN=MinhaRede
RedeN=nnnn
HabilitaDigitadoN=0
HabilitaMagneticoN=1
```
Também é possível definir as transações adicionais que serão capturadas pela rede em questão. O parâmetro
que determina essa característica é o TransacoesAdicionaisn, sendo n o índice da rede. Os valores indicados são as
funções do item 3.2.2 - Tabela de códigos de funções, separados por ponto-e-vírgula.

```
No momento, somente a transação 602 (Consulta Saldo Cartão de Crédito) foi implementada.
```
```
Exemplo:
```
```
[Credito]
Rede1=205
Texto1=GoldenFarma
TransacoesAdicionais1=602;
```
```
A seguir, listamos o código das redes que possuem cartões nesta situação.
```
```
Código da Rede Nome da Rede
21 VeroPay (Vero Débito Digitado)
97 Cartesys
172 SomarCard
178 StarFiche
196 Libercard
205 GoldenFarma
263 FitCard
```
#### 6.22 Habilitação de crédito parcelado quando em um pagamento vinculado

Por padrão da CliSiTef, uma transação de pagamento de contas/recarga/ativação de cartão Gift que tenha um
pagamento vinculado não habilitará a opção de parcelamento por padrão.

No entanto, existe um parâmetro que, em conjunto com a habilitação no SiTef dessas transações, pode habilitar
essa forma de pagamento na biblioteca. O parâmetro é o seguinte:

```
[Geral]
ModalidadesPermitePagVinculadoCredParcAdm=XXX;
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 113 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
ModalidadesPermitePagVinculadoCredParcLoja=XXX;
```
Onde XXX é o código da função/modalidade que irá executar a transação. Então, se o desejado for habilitar o
parcelamento na transação de ativação Gift, por exemplo, o código a ser usado seria o **265**.

```
Lembrando que somente é possível habilitar o parcelamento para transações de crédito.
```
**_IMPORTANTE:_** Como o parcelamento de transações geralmente tem taxas é importante estudar se para essas
transações é vantagem ou não permitir o parcelamento.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 114 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
## 7 Arquivos de controle

A CliSiTef permite configurar o diretório onde serão gerados os seus arquivos de controle. Essa configuração
deve ser feita pelo item DiretorioBase da seção SalvaEstado no arquivo CliSiTef.ini.

```
No Windows, a pasta padrão utilizada é C:\CliSiTef\ChavesCliSiTef.
```
```
No Linux, a pasta padrão é /tmp/ChavesCliSiTef.
```
```
[SalvaEstado]
DiretorioBase=<DIRETORIO>
```
```
Exemplo Windows:
```
```
[SalvaEstado]
DiretorioBase=C:\Chaves
```
```
Exemplo Linux:
```
```
[SalvaEstado]
DiretorioBase =/home/usuario/chaves
```
```
Observação: é importante que seja indicada uma pasta local, e não um mapeamento de rede.
```
**Importante:** a pasta tmp foi escolhida inicialmente no Linux pelo fato de, geralmente, não haver problemas de
permissão no uso da pasta. Entretanto, um reboot na máquina Linux pode fazer com que os arquivos sejam
apagados.

Desta forma, é recomendável que a automação configure para que a CliSiTef acesse uma pasta com a permissão
de leitura e escrita. Isto é, no usuário de sistema que rodará a automação.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 115 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
## 8 Trace

A CliSiTef normalmente grava informações em um único arquivo diário, com mecanismo de rotação de logs. Ou
seja, arquivos mais antigos são removidos automaticamente.

```
No Windows, o arquivo é gravado no padrão C:\CliSiTef\CliSiTef.<AAAAMMDD>.dmp.
```
```
No Linux, o arquivo é gravado na pasta local, no padrão CliSiTef.<AAAAMMDD>.dmp.
```
```
Em equipamentos POS, o arquivo é gravado na pasta local, no padrão TRACE.
```
#### 8.14 Configurando histórico

No arquivo de configuração “CliSiTef.ini”, é possível configurar o número de dias durante os quais o trace será
mantido. Por padrão o trace fica habilitado por cinco dias.

```
[GERAL]
NumeroDeDiasNoLog=n
```
```
onde é n é o número de dias. Zero grava indefinidamente.
```
```
Observação: esta configuração não é aplicada caso o modo Trace Rotativo esteja habilitado.
```
#### 8.15 Configuração de diretório

```
No Windows, a pasta padrão para gravação dos arquivos de trace é C:\CliSiTef.
```
```
No Linux, é usada a pasta corrente.
```
A CliSiTef permite configurar os diretórios onde serão gerados os seus arquivos de trace. Para tanto, altere o
arquivo CliSiTef.ini conforme mostrado abaixo:

```
[CliSiTef]
DiretorioTrace=<DIRETORIO>
```
```
Exemplo Windows:
```
```
[CliSiTef]
DiretorioTrace=C:\Trace
```
```
Exemplo Linux:
```
```
[CliSiTef]
DiretorioTrace=/home/usuario/trace
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 116 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 8.16 Arquivos de trace por terminal

Para facilitar algumas análises, é possível configurar a CliSiTef para gerar arquivos de trace por terminal
(parâmetro _IdTerminal_ da função _ConfiguraIntSiTefInterativo_ ).

Além da geração de traces por terminal, também é possível alterar a geração do arquivos de trace do modo
diário para o modo por hora, em que são gerados diversos arquivos de trace fragmentados por hora.

Ao habilitar o modo multi-terminal da CliSiTef, a geração de traces é automaticamente alterada para o modo
por terminal. Para maiores informações sobre o modo multi-terminal, consulte o documento específico “CliSiTef -
Configuração Multi-terminal.doc”.

Caso não esteja configurada no modo multi-terminal e ainda assim queira habilitar a geração de traces por
terminal, basta adicionar o item TracePorTerminal na seção CliSiTef do arquivo “CliSiTef.ini”.

```
[CliSiTef]
TracePorTerminal=1
```
```
Para habilitar a geração de traces por hora deve ser adicionada a seguinte configuração ao arquivo “CliSitef.ini”:
```
```
[CliSiTef]
TracePorHora=1
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 117 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
#### 8.17 Trace Rotativo

A partir da versão 4.0.112.45 da CliSiTef, é possível separar cada transação efetuada pela automação em um
arquivo de trace próprio.

Entenda-se transação, ao conjunto de trocas de mensagens sob o mesmo cupom fiscal. Ou seja, cupom fiscal e
data fiscal, passados como parâmetro na função _IniciaFuncaoSiTefInterativo_ (hora fiscal não é considerada).

Por exemplo: uma transação de recarga de celular seguida de um TEF, no mesmo cupom fiscal, ficam
armazenados no mesmo arquivo de trace.

```
Neste cenário, os arquivos são gravados na forma:
```
```
Transação Windows, Linux e plataformas
mobile (e outras plataformas não-
POS)
```
```
Plataformas POS
```
```
1 (mais recente)
2
3
```
```
n (mais antiga)
```
```
CliSiTef.dmp
CliSiTef.dmp.1
CliSiTef.dmp.2
```
```
CliSiTef.dmp. n- 1
```
###### TRACE

###### TRACE.1

###### TRACE.2

TRACE. _n- 1_
A cada nova transação, os arquivos são rotacionados (renomeados), e os arquivos mais antigos são removidos,
mantendo a quantidade de arquivos desejada.

Esta opção permite também o envio destes arquivos para o servidor SiTef, desde que este esteja configurado
com o módulo **NServices**.

##### 8.17.1 Habilitando o trace rotativo

Para habilitar a geração de traces rotativos, deve-se indicar a quantidade de arquivos máxima a serem
armazenados na seção CliSiTef, item TraceRotativo.

```
[CliSiTef]
TraceRotativo=n
```
```
Exemplo: armazenar até 10 transações
```
```
[CliSiTef]
TraceRotativo=10
```
```
Observação: ao habilitar a opção de trace rotativo, a configuração NumeroDeDiasNoLog será desprezada.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 118 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
##### 8.17.2 Limitando o tamanho dos arquivos

Em situações onde há restrições de espaço em disco (POS, por exemplo), pode-se ainda limitar o tamanho do
arquivo de trace. Neste caso, uma mesma transação pode ficar armazenada em um ou mais arquivos separados.

```
Para tanto, indique o tamanho (em bytes) do limite do arquivo na seção CliSiTef, item TamanhoTraceRotativo.
```
```
Por exemplo, para limitar o tamanho de cada arquivo em cerca de 32Kb:
```
```
[CliSiTef]
TraceRotativo=10
TamanhoTraceRotativo=32768
```
```
Observação : esta limitação de tamanho só é aplicada quando a opção TraceRotativo está habilitada.
```
##### 8.17.3 Enviando arquivos de trace para o servidor SiTef

É possível submeter os arquivos de trace de uma estação PDV ou terminal POS para o servidor SiTef. Esta
situação pode ser especialmente útil para análise de eventuais problemas em produção.

Ao habilitar a configuração de trace rotativo, automaticamente será disponibilizada no menu administrativo da
clisitef (função **110** ) a opção “Envio de trace para o servidor SiTef”.

Caso a automação deseje desabilitar esta opção, restrinja o menu **3627**. Para maiores informações, consulte
“Restrição ou habilitação das formas de pagamento”.

Também é possível comandar esta transação através da função **121** , que deve ser passada na
_IniciaFuncaoSiTefInterativo_.

```
Função Descrição
121 Envio de arquivos de trace para o servidor SiTef.
```
Em caso de queda na comunicação, a automação pode executar novamente a função **121** após o
reestabelecimento do canal. Nesta situação, a clisitef confirmará se deseja continuar o envio anterior.

Ao submeter os arquivos de trace para o servidor SiTef, certifique-se que o mesmo tenha o módulo **NServices**
devidamente configurado.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 119 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
## 9 Processo de desenvolvimento/homologação

#### 9.14 Arquivo de trace adicional durante a fase de desenvolvimento

A CliSiTefI possui um mecanismo de auxilio ao desenvolvedor da aplicação que interage com ela de forma a
simplificar a busca por problemas durante a fase de desenvolvimento. Esse mecanismo, uma vez habilitado, faz
com que seja gerado um arquivo de trace contendo os parâmetros trocados entre a CliSiTef e a aplicação. O arquivo
fica localizado no diretório corrente ou em C:\CliSiTef, dependendo se o ambiente for Linux ou Windows,
respectivamente. O nome do arquivo é **_CliSiTef.AAAAMMDD.txt_**.

```
Para habilitar essa característica, inclua o seguinte parâmetro no arquivo de configuração CliSiTef.ini:
```
```
[Geral]
DataEmAmbienteDeDesenvolvimento=AAAAMMDD
```
```
Onde AAAAMMDD corresponde ao dia que o teste em laboratório está sendo feito.
```
Em ambiente de produção essa configuração **_NÃO DEVE EXISTIR_** , sendo que a análise de problemas nesse
ambiente deverá ser feita pela Software Express pela ativação de traces internos da CliSiTef, através de
configurações passadas pelo Suporte. Essa opção habilita, automaticamente, a opção a seguir.

#### 9.15 Processo de homologação

Como descrito anteriormente, o fluxo descrito neste documento deve ser seguido a risca para que não ocorram
erros estranhos durante a execução da CliSiTef. Para tanto, existe um parâmetro configurável que será utilizado
pelos homologadores da Software Express para confirmar que o aplicativo de automação somente concretiza o
processo de venda pela impressão de um comprovante ou pela chamada a função _FinalizaFuncaoSiTefInterativo_
após o retorno final da _ContinuaFuncaoSiTefInterativo_. Esse parâmetro é o seguinte:

```
[Geral]
EmAmbienteDeHomologacao=1
```
```
Por introduzir uma mensagem adicional no processo, ele jamais deverá ser utilizado em ambiente de produção.
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 120 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
## 10 Tradução de mensagens

É possível alterar parte das mensagens enviadas para a automação, para efeitos de tradução ou, em alguns
casos, para reduzir as mensagens.

Para habilitar esta característica, basta incluir na seção TabTraducao da CliSiTef.ini o item NomeArqTraducao,
indicando o nome do arquivo de tradução.

```
[TabTraducao]
NomeArqTraducao=<Nome do arquivo>
```
```
As mensagens devem ficar em um arquivo no formato INI separado, sob a seção TabTraducao.
```
```
Um exemplo deste arquivo seria:
```
```
[TabTraducao]
MsgNovoValor=Forneca o novo valor do pagamento
MsgEmbosso=Forneca os 4 digitos finais do cartao
MsgCodigoSeguranca=Informe Cod. Seg, ou\n0 = inexistente\n1 = ilegivel
```
Como a CliSiTef está em constante inclusão de módulos e mensagens, a lista completa de itens de tradução
encontra-se no documento “SiTef - Interface Simplificada com a aplicação - Tabela de Mensagens”.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 121 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
## 11 Tabelas

#### 11.14 Código das Redes Autorizadoras

```
Código das Redes Autorizadoras Descrição
00000 Outra, não definida
00001 Tecban
00002 ITAÚ
00003 BRADESCO
00004 Visanet - Especificação 200001
00005 Redecard
00006 Amex
00007 SOLLO
00008 E CAPTURE
00009 Serasa
00010 SPC Brasil
00011 SERASA DETALHADO
00012 TELEDATA
00013 ACSP
00014 ACSP DETALHADO
00015 TECBIZ
00016 CDL DF
00017 Repom
00018 STANDBY
00019 EDMCARD
00020 CREDICESTA
00021 Banrisul
00022 ACC CARD
00023 Clubcard
00024 ACPR
00025 Vidalink
00026 CCC_WEB
00027 Ediguay
00028 Carrefour
00029 Softway
00030 Multicheque
00031 Ticket combustível
00032 YAMADA
00033 Citibank
00034 Infocard
00035 BESC
00036 EMS
00037 CHEQUE CASH
00038 Central Card
00039 Drogaraia
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_122_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Código das Redes Autorizadoras Descrição
00040 OUTRO SERVIÇO
00041 Edenred
00042 EPAY GIFT
00043 Parati
00044 TOKORO
00045 Coopercred
00046 SERVCEL
00047 Sorocred
00048 Vital
00049 SAX FINANCEIRA
00050 Formosa
00051 Hipercard
00052 Tricard
00053 CHECK OK
00054 Policard
00055 Cetelem Carrefour
00056 LEADER
00057 Consórcio Credicard Venezuela
00058 GAZINCRED
00059 Telenet
00060 Cheque Pré
00061 Brasil Card
00062 Epharma
00063 Total
00064 Consórcio Amex Venezuela
00065 GAX
00066 Peralta
00067 SERVIDOR PAGAMENTO
00068 BANESE
00069 RESOMAQ
00070 Sysdata
00071 CDL POA
00072 BIGCARD
00073 DTRANSFER
00074 VIAVAREJO
00075 CHECK EXPRESS
00076 Givex
00077 Valecard
00078 Portal Card
00079 Banpara
00080 SOFTNEX
00081 SUPERCARD
00082 GetNet
00083 Prevsaude
00084 BANCO POTTENCIAL
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_123_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Código das Redes Autorizadoras Descrição
00085 SOPHUS
00086 MARISA 2
00087 MAXICRED
00088 BLACKHAWK
00089 EXPANSIVA
00090 SAS NT
00091 LEADER 2
00092 SOMAR
00093 CETELEM AURA
00094 CABAL
00095 CREDSYSTEM
00096 Banco Provincial
00097 CARTESYS
00098 CISA
00099 TRNCENTRE
00100 ACPR D
00101 CARDCO
00102 CHECK CHECK
00103 CADASA
00104 PRIVATE BRADESCO
00105 CREDMAIS
00106 GWCEL
00107 CHECK EXPRESS 2
00108 GETNET PBM
00109 USECRED
00110 SERV VOUCHER
00111 TREDENEXX
00112 Bonus Presente Carrefour
00113 CREDISHOP
00114 ESTAPAR
00115 Banco Ibi
00116 WORKERCARD
00117 Telecheque
00118 OBOE
00119 PROTEGE
00120 SERASA CARDS
00121 Hotcard
00122 Banco Panamericano
00123 Banco Mercantil
00124 Sigacred
00125 Visanet – Especificação 4.1
00126 SPTRANS
00127 PRESENTE MARISA
00128 COOPLIFE
00129 BOD
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_124_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Código das Redes Autorizadoras Descrição
00130 G CARD
00131 TCREDIT
00132 SISCRED
00133 FOXWINCARDS
00134 CONVCARD
00135 Voucher
00136 EXPAND CARDS
00137 Ultragaz
00138 Qualicard
00139 HSBC UK
00140 Wappa
00141 SQCF
00142 INTELLISYS
00143 BOD DÉBITO
00144 ACCREDITO
00145 COMPROCARD
00146 ORGCARD
00147 MINASCRED
00148 Farmácia Popular
00149 Fidelidade Mais
00150 ITAÚ SHOPLINE
00151 CDL RIO
00152 FORTCARD
00153 PAGGO
00154 SMARTNET
00155 INTERFARMACIA
00156 VALECON
00157 CARTÃO EVANGÉLICO
00158 VEGASCARD
00159 SCCARD
00160 ORBITALL
00161 ICARDS
00162 FACILCARD
00163 FIDELIZE
00164 FINAMAX
00165 BANCO GE
00166 UNIK
00167 TIVIT
00168 VALIDATA
00169 BANESCARD
00170 CSU CARREFOUR
00171 VALESHOP
00172 SOMAR CARD
00173 OMNION
00174 CONDOR
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_125_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Código das Redes Autorizadoras Descrição
00175 STANDBYDUP
00176 BPAG BOLDCRON
00177 MARISA SAX SYSIN
00178 STARFICHE
00179 ACE SEGUROS
00180 TOP CARD
00181 GETNET LAC
00182 UP SIGHT
00183 MAR
00184 FUNCIONAL CARD
00185 PHARMA SYSTEM
00186 MARKET PAY
00187 SICREDI
00188 ESCALENA
00189 N SERVIÇOS
00190 CSF CARREFOUR
00191 ATP
00192 AVST
00193 ALGORIX
00194 AMEX EMV
00195 COMPREMAX
00196 LIBERCARD
00197 SEICON
00198 SERASA AUTORIZ CRÉDITO
00199 SMARTN
00200 PLATCO
00201 SMARTNET EMV
00202 PROSA MÉXICO
00203 PEELA
00204 NUTRIK
00205 GOLDENFARMA PBM
00206 GLOBAL PAYMENTS
00207 ELAVON
00208 CTF
00209 BANESTIK
00210 VISA ARG
00211 AMEX ARG
00212 POSNET ARG
00213 AMEX MÉXICO
00214 ELETROZEMA
00215 BARIGUI
00216 SIMEC
00217 SGF
00218 HUG
00219 CARTÃO CONSIGNUM CARTÃO METTACARD
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_126_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

```
Código das Redes Autorizadoras Descrição
00220 DDTOTAL
00221 CARTÃO QUALIDADE
00222 REDECONV
00223 NUTRICARD
00224 DOTZ
00225 PREMIAÇÕES RAIZEN
00226 TROCO SOLIDÁRIO
00227 AMBEV SÓCIO TORCEDOR
00228 SEMPRE
00229 BIN
00230 COCIPA
00231 IBI MÉXICO
00232 SIANET
00233 SGCARDS
00234 CIAGROUP
00235 FILLIP
00236 CONDUCTOR
00237 LTM RAIZEN
00238 INCOMM
00239 VISA PASS FIRST
00240 CENCOSUD
00241 HIPERLIFE
00242 SITPOS
00243 AGT
00244 MIRA
00245 AMBEV 2 SÓCIO TORCEDOR
00246 JGV
00247 CREDSAT
00248 BRAZILIAN CARD
00249 RIACHUELO
00250 ITS RAIZEN
00251 SIMCRED
00252 BANCRED CARD
00253 CONEKTA
00254 SOFTCARD
00255 ECOPAG
00256 C&A AUTOMAÇÃO IBI
00257 C&A PARCERIAS BRADESCARD
00258 OGLOBA
00259 BANESE VOUCHER
00260 RAPP
00261 Monitora POS
00262 SOLLUS
00263 FITCARD
00264 ADIANTI
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 127 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
```
Código das Redes Autorizadoras Descrição
00265 STONE
00266 DMCARD
00267 ICATU 2
00268 FARMASEG
00269 BIZ
00270 SEMPARAR RAIZEN
00272 PBM GLOBAL
00273 PAYSMART
00275 ONEBOX
00276 CARTO
00277 WAYUP
00296 SAFRA
00301 CTF Frota
00303 SIPAG
```
#### 11.15 Código da Bandeira

Abaixo alguns dos valores que podem ser retornados no TipoCampo **132** , através da rotina
_ContinuaFuncaoSiTefInterativo_.

```
A lista completa de códigos de bandeiras está disponível no documento “Bandeira Padrao SiTef.pdf”.
```
```
Código da Bandeira Descrição
00000 Outro, não definido
00001 Visa (Crédito)
00002 Mastercard (Crédito)
00004 American Express (Crédito)
00011 JCB (Crédito)
10014 Discovery (Voucher)
20001 Maestro (Débito)
20002 Visa Electron (Débito)
20137 Telenet (Débito)
```

```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 128 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
## 12 Plataformas suportadas

As bibliotecas CliSiTefI e CliSiTef estão disponíveis atualmente para as seguintes plataformas:

```
Sistema Operacional Ambientes Arquiteturas
Windows Desktop / Embarcado Intel x86 / x64
Windows CE Embarcado / Mobile Intel x86,
ARM 32
Windows Phone Mobile ARM 32
Mac OS Desktop Intel x64
Linux Desktop / Embarcado Intel x86 / x64,
ARM 32 (v4, v5tej e v6-Raspberry)
ARM 64
Android Mobile Intel x86 / x64,
Mips, Mips64,
ARMEABI / ARMEABI-v7a
ARM 32 (v7a),
ARM 64 (v8a)
IOS Mobile Intel x86 / x64,
ARM 32 (v7/v7s),
ARM 64 (v8a)
```
## 13 Rotinas descontinuadas

```
Rotina Antiga Rotina Nova
LeCartaoInterativo LeCartaoSeguro
LeCartaoInterativoA LeCartaoSeguroA
LeCartaoDireto LeCartaoDiretoSeguro
LeCartaoDiretoA LeCartaoDiretoSeguroA
LeCartaoDiretoEx LeCartaoDiretoSeguro
LeCartaoDiretoExA LeCartaoDiretoSeguroA
FinalizaTransacaoSiTefInterativo FinalizaFuncaoSiTefInterativo¹
IniciaFuncaoAASiTefInterativo IniciaFuncaoSiTefInterativo
IniciaFuncaoAASiTefInterativoA IniciaFuncaoSiTefInterativoA
Observações:
```
1 – A função _FinalizaFuncaoSiTefInterativo_ recebe um parâmetro a mais que sua antecessora, a
_FinalizaTransacaoSiTefInterativo_ (ver item **Erro! Fonte de referência não encontrada.** ). Caso a automação não n
ecessite usar esse parâmetro adicional, o mesmo deve ser passado como vazio/NULL.


```
SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )
Copyright Software Express 129 de 140
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,
```
## 14 Histórico de Alterações

```
Versão do
Documento Data^
```
```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
###### 26/08/2004

```
0.98.z.8
0.98.nv.14
```
```
Corrigida a documentação dos parâmetros na função
LeCartaoDiretoExA
Acerto na numeração das versões mínimas e no texto
descritivo das funções e correção da versão anterior que
NÃO era 0.99
```
```
09/09/2004 1.00.a.4
```
```
Modificada a forma de numerar as versões. Retornou a
forma padrão V.VV[.release]
Incluída a geração de trace não criptografado para ser
utilizado em ambiente de desenvolvimento
Incluída as transações CentralCard e InfoCard
```
```
09/09/2004
```
```
1.00.a.5
1.00.a.20
```
```
Incluído os tipos de campo necessários para tratar a coleta
de números de telefone para consulta a cheques
```
```
19/11/2004
```
```
1.00.a.5
1.00.a.42
```
```
Devolução do código em barras cujo pagamento foi
aprovado
```
```
28/12/2005 1.00.a.5
```
```
Inclusão do TipoCampo 518 e 519 na tabelas de valores para
Tipo Campo.
```
```
04/04/2006 1.00.a.20
```
```
Inclusão da possibilidade de gerar trace em aberto para
auxiliar o desenvolvimento da interface com a CliSiTef
```
```
17/08/2006 1.01.a.138
```
```
Passou a devolver os NSU do SiTef e do Host Autorizador
quando uma transação de recarga for paga com cartão
Passou a devolver o Código da Filial que autorizou a recarga
do celular
```
```
08/11/2006 ????
```
```
Inclusão de novos campos para tratamento do cartão
combustível (GoodCard e PortalCard).
```
```
15/01/2006 1.01.c.55
```
```
Inclusão somente na versão EMV FULL da possibilidade de
adição de IP secundário no CLISITEF.INI.
A gravação de trace passa a ser habilitada por padrão e o
período de armazenamento é configurável.
```
```
17/08/2007
```
```
Acrescentados códigos de redes autorizadoras à tabela
existente.
06/02/2008 1.01.c.080.1 Inclusão do campo tipo 1131 e dos menus 3063,3064,3065.
```
```
18/03/2008 1.01.c.082.1
```
```
Descrição de configurações especiais no parâmetro
ParamAdic.
28/03/2008 1.01.c.082.2 Inclusão do campo tipo 1049.
17/07/2008 1.01.c.089.1 Inclusão de campos para a rede Condor, Starfiche e SEM
```
```
01/06/2009 1.01.c.094.57
```
```
Inclusão das configurações especiais EMS.
Inclusão dos campos do pagamento de cartão Qualicard.
08/06/2009 1.01.c.094.63 Inclusão autorização genérica EMS.
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_130_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Versão do
Documento Data**^

```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
```
01/07/2009 1.01.c.094.71 Inclusão da rede Pharma System
23/07/2009 1.01.c.094.31 Inclusão da rede Oboé
23/07/2009 1.01.c.94.xx Inclusão da rede Avista
11/08/2009 1.01.c.94.xx Inclusão do menu venda crédito com autorização à vista
12/08/2009 1.01.c.94.105 Inclusão do cartão virtual Formosa.
20/08/2009 1.01.c.94.109 Inclusão do cartão Neus.
27/08/2009 1.01.c.94.113 Inclusão da rede Algorix
14/09/2009 1.01.c.94.129 Inclusão do PBM Fidelize
30/09/2009 1.01.c.94.135 Inclusão da rede CompreMax
07/10/2009 1.01.c.94.137 Inclusão do cancelamento de cartão combustível genérico
```
```
12/01/2010 1.01.c.94.191 Inclusão do campo 537 (código de área da cidade do
cheque)
27/01/2010 1.01.c.94.195 Documentação do campo 2054 para o tipo de CDC Crédito.
28/01/2010 1.01.c.94.201 Inclusão da rede SQCF
11/02/2010 1.01.c.94.207 Inclusão da opção Cartão Gridcard
```
```
14/06/2010 - Reservado o Range de 8000 a 9999 para a tabela de Tipo
Campos para a IntPos.dll.
06/07/2010 1.01.c.94.254 Inclusão dos menus de saque/estorno de saque GetNet
06/08/2010 1.01.c.94.259 Inclusão da função Consulta Saque com Saque Banco IBI
```
```
21/09/2010 1.01.c.94.265
```
```
Alteração da identificação dos campos Código Produto Hopi-
Hari (de 2049 para 2120), Descrição Produto Hopi-Hari (de
2050 para 2121), Quantidade Máxima de produtos Hopi-
Hari (de 2051 para 2122), Produtos Hopi-Hari (de 2052 para
2123).
```
```
21/10/2010
```
```
Incluído campo 3334 (Pagamento SPTrans) e modalidades
700 e 701 (Oi Paggo)
```
```
11/11/2010 1.01.c.95.13
```
```
Inclusão do pagamento de fatura/estorno FoxWinCards,
menus 3335 e 3336; Inclusão da
RedeHabilitadaFoxWinCards.
Inclusão das funções 702 (Pagamento de contas) e 703
(Cancelamento de Pagamento Cartão Benefício).
```
```
06/12/2010 -
```
```
Adicionadas descrições dos códigos de erro -43, -50 e -100.
Eventos 5011, 5012 e 5013.
```
```
28/01/2011 -
```
```
Inclusão do campo 2301.
Criada tabela de Modalidades, para melhor visualização.
18/02/2011 Inclusão dos campos 2125 e 2126 (fatura HotCard).
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_131_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Versão do
Documento Data**^

```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
```
11/05/2011 4.0.102.3.r1
```
```
Inclusão dos campos 3337 até 3352.
Inclusão das funções(modalidades) Resgate de Pontos
(modalidade 665), Emissao Pontos (667), Cancel. Emissao
Pontos (668), 669 (Carga de Pré Pago), 670 (Cancel. Carga de
Pré Pago) e 680 (Cons. Saldo Pré Pago)
27/05/2011 4.0.102.6.r1 Parâmetro HabilitaRedeTricard
```
```
13/06/2011 4.0.102.7.r1
```
```
Inclusão dos campos 3339 a 3345.
Inclusão das funções (modalidades): Venda com Cartão Gift
(modalidade 15), Consulta a Saldo Gift (modalidade 152),
Cancelamento de Venda com Cartão Gift (modalidade 213),
Cancelamento de Recarga de Cartão Gift (modalidade 257) e
Recarga de Cartão Gift (modalidade 264).
08/07/2011 4.0.102.9.r1 Inclusão do campo 5501.
12/07/2011 - Corrigido o nome da rede InfoCard nas redes habilitadas.
```
```
01/08/2011 4.0.102.10.r1
```
```
Inclusão da rede TopCard e da transação de Pagamento de
Fatura Genérico (3379)
```
```
22/09/2011 4.0.102.12 r1 Inclusão do modo “2:” (Digitação do CMC-7) na captura do
cheque
```
```
25/10/2011 4.0.102.12 r14
```
```
Inclusão dos campos 3407 e 3408; Inclusão da Rede
ClubCard
15/12/2011 - Alteração na descrição do campo 178 que estava errada.
09/05/2012 4.0.104.6 b6 Inclusão do tipo campo 3409; Inclusão da Rede Citibank
```
```
14/11/2012 -
```
```
Revisão geral do documento; inclusão de tipos de parâmetro
(entrada/saída e valor/referência).
21/12/2012 4.0.106.18 r1 Parâmetro HabilitaRedeDotz
```
```
02/01/2013 4.0.106.18 r1 Inclusão da descrição dos campos 1 e 2, além do
detalhamento do campo 100.
```
```
18/01/2013 4.0.106.18 r1
```
```
Inclusão da modalidade 420, do tipo campo 2355 e
alteração no texto do campo 1122.
26/02/2013 4.0.106.20 r1 Inclusão do parâmetro ConexaoObrigatoria na seção “SiTef”
06/03/2013 - Inclusão do tipo campo 5050 na tabela de eventos.
```
###### 13/03/2013 -

```
v119 - Revisão editorial do item Informações do PinPad, e
do campo 2355.
Incluído esclarecimentos sobre o processo de
Descarregamento de Mensagens.
```
```
29/04/2013 -
```
```
v120 – Correção na descrição de campos específicos ACSP
que são retornados em outras redes, tornando-os genéricos.
```
```
14/06/2013 -
```
```
v121 – Inclusão do tipo campo 2362 e retificação do tipo
campo 131 da Tabela de valores
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_132_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Versão do
Documento Data**^

```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
###### 17/09/2013 -

```
v122 – Correção na descrição do TipoCampo 112.
(Gift) Incluídos os campos 3553, 3554 e 3557 na tabela de
opções de menu (5.7)
```
```
02/10/2013 -
```
```
v123 - Retificação do campo para Cancelamento de ativação
Gift.
18/10/2013 - v124 – Revisão do item LeCartaoDireto.
```
```
02/01/2014 - v125 –^ Incluso referência para documento de Tabela de
Tradução.
```
###### 13/01/2014 -

```
v127 – Movida configurações entre clisitef e sitef do
documento “Configurações Especiais”, agora extinto.
Observação sobre a necessidade de chamar a rotina
ConfiguraIntSiTefInterativo(Ex).
Incluídas funções 770, 771 e 772 para carga de tabelas de
pinpad.
Incluída função 775 (informações do pinpad)
```
```
29/01/2014 4.0.111.3 r1
```
```
v128 – Incluída a configuração de porta de pinpad
‘AUTO_USB’ para plataforma Windows.
11/02/2014 4.0.111.4 r1 Inclusão da rede Consignum
27/02/2014 - Atualizada descrição do campo 3014.
02/04/2014 Atualizados códigos de erro retornados pelas rotinas.
03/04/2014 Inclusão do campo 2369 (Brazilian Card).
```
###### 09/04/2014

```
Inclusão da descrição para o campo 205x e diferenciação
deste com o campo 203x, pois ambos se tratam de campos
referentes a Hash.
```
```
14/05/2014
```
```
Alteração na descrição do Tipo Campo 1190 de Embosso Gol
Off-Line para Embosso (4 últimos dígitos) do cartão.
10/06/2014 Alteração na descrição do Tipo Campo 110.
17/06/2014 Atualização da Tabela de Código das Redes Autorizadoras.
```
```
23/06/2014 4.0.111.16 r1
```
```
Mudança na configuração de HabilitaRedeConsignum para
HabilitaRedeMettacard, pois o autorizador Consignum passa
a se chamar Mettacard.
22/07/2014 Incluídas funções LeTrilhaChipInterativo e derivações ASCII
```
```
18/08/2014 4.0.111.18 r1
```
```
Alteração na descrição do item 4.1.1 para configuração do
pinpad para reconhecimento automático de porta USB.
Antes da versão 4.0.111.18 r1, era habilitada apenas para
Windows. A partir desta versão permite também a
configuração para Linux 32, a partir do kernel 2.6.
21/08/2014 Inclusão do Tipo Campo 1321.
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_133_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Versão do
Documento Data**^

```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
###### 28/08/2014

- Inclusão de configuração para realizar transações com
cartão combustível forçando a rede (por exemplo FitCard).
- Inclusão do retorno -21 para possíveis códigos de retorno.
Item 3.2.1.

```
05/09/2014
```
```
Inclusão dos Tipo Campos 3270, 3271 e 3272 que são
opções de menu para TrnCentre PBM.
11/09/2014 Atualização da lista de redes habilitadas.
```
```
23/09/2014
```
```
Detalhamento das funções/modalidades 10 e 11 incluindo a
informação que são especifica para rede Wappa.
16/10/2014 Removidos campos legados 141 e 142.
29/10/2014 Incluídas as modalidades/funções 675 e 676.
```
```
31/10/2014
```
```
Inclusão das rotinas LeCartaoDiretoSeguroEx e
LeCartaoDiretoSeguroExA.
28/11/2014 Atualizada descrição do campo 731.
24/02/2015 Inclusão do menu reimpressão especifico outros 3675.
```
```
26/03/2015 4.0.112.26 r1
```
```
Inclusão da modalidade 658 para poder efetuar a transação
de Saque Crédito de forma direta.
Inclusão na tabela de eventos os campos 5027, 5028, 5029,
5030, 5031, 5036, 5037, 5038, 5039, 5040, 5041, 5042,
5043, 5044.
```
```
09/04/2015
```
```
Inclusão dos campos 587 e 588, serão retornados nas
transações de recarga.
```
```
15/04/2015
```
```
Inclusão da modalidade de pagamento Cartão Fidelidade ao
TipoCanpo 100.
```
###### 27/05/2015

```
Inclusão dos códigos de menus 3624, 3625 e 3626.
Inclusão do item 3.18 Carga de Tabelas no PinPad sem
alteração na Automação;
Inclusão do item 4.1.2 Configuração quando a Automação
não utilizar pinpad;
Inclusão do item 4.2.7 Como passar um novo valor da
compra da transação na CliSiTef
29/05/2015 Inclusão do item 4.1.3 Configuração de um segundo pinpad
```
###### 27/08/2015

```
Esclarecimento para o item 3.4, Confirmação ou Não do
Pagamento. A confirmação da transação deve possuir
mesmo número de cupom fiscal e mesma data da transação
realizada para ser confirmada com sucesso.
```
```
14/09/2015 4.0.112.42 r1 -^ Inclusão de configuração para realizar transações com
cartão Gift forçando a rede (por exemplo Condor).
01/10/2015 - Inclusão dos campos 2467, 2468 e 2469.
19/10/2015 - Inclusão tópico Prefixo Especifico Enviado pela Automação
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_134_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Versão do
Documento Data**^

```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
```
10/11/2015 4.0.112.45 r1
```
```
Observações adicionais para definição da pasta de
armazenamento de arquivos de controle.
Inclusão das configurações para trace rotativo.
11/11/2015 - Inclusão tópico Plataformas Suportadas.
02/12/2015 Alteração da descrição dos campos 3720, 3721, 3722, 3723
```
```
10/12/2015
```
```
Atualizado transação Cartão Presente - Modalidade 262 ,
uso exclusivo do Carrefour.
```
```
14/12/2015 Alteração no tamanho máximo para o campo 134 de 15 para
20.
14/01/2016 Inclusão do tipocampo 2470 e do item 4.2.8 Ponto flutuante
```
```
21/01/2016
```
```
Inclusão do formato da data de vencimento do catão
(AAMM) retornado pela rotina LeCartaoDiretoSeguro.
```
```
03/02/2016
```
```
Retificação no item Como a automação informa à CliSiTef
que sabe tratar campos com ponto flutuante.
```
```
05/02/2016 Alteração no item Como a automação informa à CliSiTef que
sabe tratar campos com ponto flutuante
```
```
24/02/2016
```
```
Incluído “Observação” no tratamento do comando 23 (item
3.3.1)
```
###### 09/03/2016

```
Inclusão de: Menu Cancelamento Saque Crédito
Transferência (3307) , Menu opção crédito a vista Resgate
Pontos (3261) e campo Número Autorização NFCE (952).
```
###### 22/03/2016

```
Inclusão da função FinalizaFuncaoSiTefInterativo em
detrimento à FinalizaTransacaoSiTefInterativo ; adicionada
explicação sobre os parâmetros adicionais da primeira.
```
###### 24/03/2016

```
Alteração na descrição do campo IdTerminal da função
ConfiguraIntSiTefInterativo incluindo observações
importantes.
05/04/2016 Tornados obsoletos os TipoCampo 596 e 596.
```
```
15/0/2016 4.0.113.12.r2
```
```
Inclusão das modalidades 117 – Ajuste de pré autorização e
118 - Consulta de pré autorização.
```
```
14/06/2016
```
```
Atualização item 5.6. Incluido transações Cielo(3323, 3653,
3654 e 3655)
```
```
19/08/2016 Atualização 5.7, melhorando a descrição da configuração
CodigoCliente.
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_135_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Versão do
Documento Data**^

```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
###### 31/09/2016

```
Alterações ref. implementação das modalidades abaixo:
```
- Modalidades:
430 – Le Cartão Seguro (LeCartaoSeguro)
431 – Le Trilha Chip Seguro (LeTrilhaChipEx)
- Adicionado “Obervação” no item:
3.8 Leitura do cartão - rotinas de captura segura
- Inclusão de campos:
CAMPO_MENSAGEM_PINPAD 2601
CAMPO_SEMENTE_HASH 2602
CAMPO_MODALIDADE_LECARTAO_SEGURO 2603

```
02/09/2016 Inclusão da modalidade 354 Ultragaz Revenda, Menus 3900,
3901, 3902. Tipo Campo 4076 (Identificação Loja).
```
```
27/09/2016 5.0.114.6 r1
```
. Inclusão da Modalidade para Adesão de Seguro - 422.
. Inclusão dos Tipo Campos 3742 (Menu Adesão de Seguro
Tricard) e 3746 (Menu Consulta de Saldo Tricard).

###### 10/10/2016

```
Inclusão dos parâmetros que habilitam o pagamento
parcelado em transações que tem pagamento vinculado
```
```
07/11/2016
```
. Inclusão da modalidade 908 (alteração de senha débito
combustível).

###### 11/11/2016

```
5.0.114.13 r1
```
```
Inclusão dos menus 3744 (Recarga de cartão de crédito) e
3745 (Cancelamento de recarga de cartão de crédito).
```
6.1.114.13 r1

```
Inclusão das funções 899 (Recarga de cartão de crédito) e
900 (Cancelamento de recarga de cartão de crédito).
```
###### 09/01/2017

```
Inserção dos “Tipo Campos” para tratamento do boleto
registrado:
```
- 4095 CPF/CNPJ Cedente;
- 4096 CPF/CNPJ Sacador;
- 4097 CPF/CNPJ Pagador.

```
17/02/2017
```
```
Ampliado tamanho do campo de retorno da trilha2 na
LeCartaoSeguro*, de 64 para 80.
```
```
04/04/2017
```
```
Inclusão de modalidade e menu da transação de alteração
de pré- autorização.
```
###### 04/04/2017

```
Inclusão de PRÉ-REQUISITO IMPERATIVO APÓS A
INSTALAÇÃO DO ARQUIVO .CHA NO SITEF no item 3.8
Leitura do cartão - rotinas de captura segura.
```
###### 05/04/2017

```
Retificação na observação PRÉ-REQUISITO IMPERATIVO
APÓS A INSTALAÇÃO DO ARQUIVO .CHA NO SITEF no item
3.8 Leitura do cartão - rotinas de captura segura.
27/04/2017 Inclusão do Tipo Campo 4058
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_136_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Versão do
Documento Data**^

```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
###### 24/05/2017

```
Inclusão de configuração para Débito Digitado da Vero
(VeroPay) no item 5.8.
```
###### 25/05/2017

```
No item 1.1 Descrição Resumida Passo inicial A regra de
formatação da identificação do terminal duas letras + 000 +
número do Terminal de Vendas não é mais obrigatória
```
###### 06/06/2017

```
No item 5.7, funcionalidade “CodigoCliente”, mudada a
quantidade de dígitos permitida para o campo de 31 para 32
dígitos. Para tanto haverá uma alteração no gerpdv. Não há
alteração na CliSiTef.
```
```
09/06/2017
```
```
Inclusão de lista de pinpads que suportam configuração
AUTO_USB no Item “4.1.1 Configuração da porta”.
```
###### 22/06/2017

```
Incluído erro “-13” e observação na função
IniciaFuncaoSiTefInterativo sobre substituição dos dados de
vendas atual quando se inicia uma nova transação.
```
###### 12/07/2017

```
5.0.114.31 r1
6.1.114.31 r1
```
```
Atualização referente “Documento Fiscal Eletronico”
Inclusão do item:
3.2.3 Parâmetros Adicionais
```
```
Atualização dos itens:
3.1.1 Configurações especiais gerais
3.11 Correspondente Bancário (Pagamento de Contas)
5.7 Habilitação de configurações especiais por transação
```
```
08/08/2017 Revisão editorial
```
###### 09/08/2017

```
No item 6.11 (antigo item 5.7), funcionalidade
“CodigoCliente”, mudada a quantidade de dígitos permitida
para o campo de 31 para 36 dígitos. Não houve alteração na
CliSiTef. Há a necessidade do gerpdv estar com a versão
mínima 5.0.0.30/6.1.3.30 (de 04/08/2017) que foi a versão
aonde houve a alteração para aceitar os 36 dígitos do
Código do Cliente. Além disto, o SiTef Web também deve
estar atualizado para exibição correta do campo com 36
dígitos.
```
```
18/08/2017
```
```
Editado o nome do TipoCampo 4095 de Cedente para
Beneficiário.
```
```
23/08/2017
```
```
Inserido Modalidade 928 – Cancelamento de Pagamento de
Carnê Débito Rede Forçada.
```
###### 25/08/2017

```
Movido códigos de campo para documentos específicos:
ACSP, Aura, Conductor/Softway, SmartNet, Ticket Car,
Recarga de Celular Pré-pago
10/11/2017 Atualização da tabela de eventos
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_137_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Versão do
Documento Data**^

```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
###### 14/11/2017

```
Tornadas obsoletas as funções de Auto-Atendimento
IniciaFuncaoAASiTefInterativo e
IniciaFuncaoAASiTefInterativoA.
```
```
14/11/2017 6.1.114.40 r1
```
```
Alteração no tratamento de confirmações, permitindo
consulta de pendências em documentos fiscais anteriores.
Adicionadas modalidades 130 (consulta de todas as
pendências no terminal) e 131 (consulta de pendências em
um documento fiscal específico).
TipoCampo 210 – Quantidade de transações pendentes no
terminal
TipoCampo 211 – Código de “Funcao” da transação.
10/01/2018 Incluído comentário no campo 2355
23/01/2018 Alterado a referência ao nome HSBC para Corban SE
```
```
26/03/2018
```
```
Melhoria nas explicações sobre restrições de formas de
pagamento.
```
```
02/04/2018 Inclusão dos Menus IATA (à vista, parcelado estab e
parcelado admin)
15/06/2018 Inclusão dos tipos 3 e 4 no ParmsClient
27/06/2018 Alteração na informação da porta do Pinpad
25/07/2018 Inclusão da função FinalizaFuncaoSiTefInterativoA
```
###### 04/09/2018

```
Detalhamento do campo 2090 (tipo do cartão lido) incluindo
informações adicionais sobre cartões sem contato e
aplicativos NFC.
```
```
03/10/2018 Maior detalhamento dos campos: 161, Toda a faixa de 800
a 849, 950, 951,953, 1002, 1003, 2364, 4100, 5049 e 5074.
```
```
12/12/2018
```
```
Inclusão de observação sobre o campo 2124 (Valor da Tarifa
de Recarga de Celular).
```
###### 17/12/2018

```
Removida descrição de exclusividade do TipoCampo 2321
(Código do Cliente) para CorBan. O TipoCampo já estava em
uso pelas modalidades não CorBan 19, 29 e 782.
```
###### 21/01/2019

```
Criado 3 novos campos para indicar se os cupons
Cliente/Estabelecimento estarão disponíveis para serem
consultados, ou reimpressos, via retaguarda, e a quantidade
de dias que eles serão armazenados
(utilizado primeiramente pela Drogaria São Paulo)
```
###### 12/03/2019

```
Inclusão da modalidade 17 (Crédito para pagamento de
carnê) e o campo 2363 (indica que foi efetuada uma
transação de Crédito para Pagamento de Carnê).
10/05/2019 Inclusão dos campos 3772, 3773, 3774 e 4077
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_138_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Versão do
Documento Data**^

```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
###### 23/05/2019

```
Inclusão dos PinPads: Gertec PPC930, Ingenico Lane3000 e
VERIFONE P200 na lista de pinpads que suportam
configuração AUTO_USB
05/06/2019 Inclusão dos campos 2925 e 2965
```
```
07/06/2019
```
```
Inclusão do campo 3152: Pagamento de Conta Senff com
Troco (antigo:Parati)
```
```
18/06/2019 6.2.115.30 r1
```
```
Exclusão do campo 3152: Pagamento de Conta Senff com
Troco (antigo:Parati).
A solução foi refeita da seguinte forma: Criada chave
HabilitaColetaFormaPagSenff na seção
[PagamentoFaturaGenerico] - quando ligada será tratado o
troco.
```
```
26/06/2019 Inclusão do código 05 (Crediário) na descrição do
TipoCampo (100).
```
###### 11/07/2019

```
Exclusão do campo 3774; campos 3772 e 3773 passaram a
ser exclusivos da Rede Coopercred; incluídos 3236, 3237,
3238 e 3239
```
```
16/07/2019
```
```
Alteração do documento: item 11.2.
```
- Referencia ao documento **“Bandeira Padrao SiTef.pdf”**.

```
23/07/2019 6.2.115.31 r4
```
```
Incluído descrição do parâmetro adicional “CPFColetado” na
seção 6.7.
Inicialmente previsto para utilização nas transações com
Carteiras Digitais, surgiu a necessidade de utilização nas
transações com outros produtos
```
###### 30/072019

```
Incluído descrição do tipoCampo 2699, utilizado pelo
módulo SQCF. Indica se a transação é uma Ativação/Recarga
Gift.
02/08/2019 Inclusão dos menus 3988 e 3989.
```
```
VRS 228 08/10/2019 6.2.115.35.r1
```
```
Inclusão configuração 3989 e alterada rede Neus para
Market Pay.
```
```
VRS 229 03/02/2020
```
```
Adequação na quantidade máxima de endereços de servidor
permitidos para 4.
```
###### VRS 230 21/02/2020

- Passou a ser relevante informar HoraFiscal na
    chamada da função IniciaFuncaoSiTefInterativo.
- Incluso detalhes e mais informações sobre a
    necessidade do cupomFiscal ser um número
    crescente.

```
VRS 231 e
232
```
```
09/03/2020 7.0.116.5.r1
```
```
Alterada seção 6.8 - Transações crédito/débito com cartão
sem BIN. Criação de [SaqueCredito] e [SaqueDebito].
Na versão 232 foram realizados ajustes no texto referente as
alterações descritas acima.
```

**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_139_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Versão do
Documento Data**^

```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
###### VRS 233 27/03/2020

```
Criado parâmetro adicional para indicar divisão de
pagamento entre cinco empresas no máximo. Alterado item
6.7 - Habilitação de configurações especiais por transação.
```
###### VRS 234 03/04/2020

```
Correção do código de retorno -43 quando ocorre algum
erro nas rotinas de PIN pad ( foi apagado)
Adicionado a versão mínima de CliSiTef para P200 com
AUTO_USB
Algumas formatações de tabelas e algumas correções de
ortografia.
VRS 235 27/04/2020 Inclusão do código de menu 3481.
```
###### VRS 236 26/05/2020

```
Inclusão código rede Autorizadora SAFRA (296) e SIPAG
(303). Alterada descrição do código 296 de FIRST DATA para
BIN
```
```
VRS 237 03/09/2020 7.0.116.17.r2
```
```
Inclusão do campo 4158, possibilitando restringir essa opção
do menu Administrativo.
VRS 238 03/09/2020 Inclusão da descrição dos campos 2974,2975,2976.
```
```
VRS 239 27/10/2020 Documentação da modalidade 698 (Saque Débito)^
```
###### VRS 240 03/05/2021

```
Atualização do item 5.4.3 da descrição dos campos 731 e
732, incluindo novos Ids para o prefixo NFPAG. Motivação
principal: informação nas transações para Pix e Carteiras
Digitais.
```
```
VRS 241 14/05/2021
```
```
Inclusão da descrição das rotinas LeTeclaPinPad e
EscreveMensagemPinPad.
```
```
VRS 242 21/05/2021 7.0.117.11.r1
```
```
Inclusão de novas formas de pagamentos no item “6.6
Tabela de códigos de meios de pagamento, configurações e
menus”: 4162 e 4163.
```
###### VRS 243 05/08/2021

```
Inclusão de opção de menu no item “6.6 Tabela de códigos
de meios de pagamento, configurações e menus”.
```
- 4192 : Habilita opção “Bradescard Parcerias” no menu de
    cancelamento de venda crédito.

###### VRS 244 03/09/2021

```
Inclusão de opção de menu no item “6.6 Tabela de códigos
de meios de pagamento, configurações e menus”.
```
- 4193 : Habilita opção “Banco Ibi” no menu de venda
    crédito.
- 4194 : Habilita opção “Banco Ibi” no menu de
Cancelamento de venda crédito.


**_SiTef - Interface Simplificada com a aplicação(VRS-253).docx (versão 253 )_**
_Copyright Software Express_ **_140_** _de_ **_140_**
Este documento contém informações CONFIDENCIAIS e PROPRIETÁRIAS da Software Express e não pode ser publicado ou distribuído sem a sua permissão,

**Versão do
Documento Data**^

```
Versão mínima
```
```
CliSiTef
```
```
Descrição
```
###### VRS 245 21/09/2021

```
Removido a opção de menu no item “6.6 Tabela de códigos
de meios de pagamento, configurações e menus”.
```
- 4192 : Habilita opção “Bradescard Parcerias” no menu de
    cancelamento de venda crédito. Esta opção não deve ser
       utilizada (Foi cancelada).

```
VRS 246 08/1/2021 Inclusão dos códigos de funções 943 e 944.^
```
```
VRS 247 08/11/2021 Correção na descrição do prefixo SPLITPAY^
```
```
VRS 248 01/02/2022 7.0.117.41.r3
```
```
Inclusão das modalidades diretas para se transacionar
diretamente com o cartão Qualidade (ICI Card): 28 (Venda) e
101 (Cancelamento).
```
```
VRS 249 17/01/2023 Incluido ítem 5.6.9 Remover cartão inserido no PinPad^
```
```
VRS 250 17/04/2023 Inclusão de compilação para a plataforma ARM 64^
```
###### VRS 251 17/05/2023

```
Inclusão do campo 4221 e sua descrição, para o projeto de
identificação de cartão pré-pago, mandate do BACEN.
```
###### VRS 252 17/11/2023

```
Inclusão do item 5.13 – Tratamento para Múltiplos
Pagamentos.
```

