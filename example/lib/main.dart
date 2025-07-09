import 'package:flutter/material.dart';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/core/utils/format_utils.dart';
import 'src/pages/pending_transaction_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CliSiTef SDK - Exemplos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CliSiTef SDK - Exemplos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Escolha um exemplo para testar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Exemplo de Transação Normal
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TotemExamplePage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.payment, color: Colors.blue, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transação Normal',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  'Fluxo completo com finalização automática',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Demonstra o fluxo tradicional onde a transação é finalizada automaticamente após o processamento.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Exemplo de Transação Pendente
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PendingTransactionPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.pending_actions, color: Colors.orange, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transação Pendente',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  'Controle manual de confirmação/cancelamento',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Demonstra o novo fluxo onde você inicia a transação, emite o cupom fiscal e depois decide se confirma ou cancela.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Informações adicionais
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre os Exemplos',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.blue.shade800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Transação Normal: Fluxo tradicional com finalização automática\n'
                      '• Transação Pendente: Novo fluxo com controle manual de confirmação\n'
                      '• Ambos os exemplos demonstram integração com AgenteCliSiTef',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TotemExamplePage extends StatefulWidget {
  const TotemExamplePage({super.key});

  @override
  State<TotemExamplePage> createState() => _TotemExamplePageState();
}

class _TotemExamplePageState extends State<TotemExamplePage> {
  bool _isLoading = false;
  String _statusMessage = 'Pronto para transações';
  String _sessionId = '';
  CliSiTefServiceAgente? _service;

  // Estado do fluxo iterativo
  bool _isInTransaction = false;
  String _currentData = '';
  int _currentCommandId = 0;
  int _currentFieldId = 0;
  final int _currentFieldMinLength = 0;
  final int _currentFieldMaxLength = 0;
  String _currentMessage = '';
  List<String> _menuOptions = [];
  String _selectedMenuOption = '';
  bool _waitingForUserInput = false;

  // Controllers para os campos
  final _serverIPController = TextEditingController(text: 'intranet5.wbagestao.com');
  final _storeIdController = TextEditingController(text: '00000000');
  final _terminalIdController = TextEditingController(text: 'REST0001');
  final _functionCodeController = TextEditingController(text: '122');
  final _amountController = TextEditingController(text: '100');
  final _cupomFiscalController = TextEditingController(text: '1234');
  final _operatorController = TextEditingController(text: 'CAIXA');

  // Controller para entrada do usuário
  final _userInputController = TextEditingController();

  // Tipo de transação selecionado
  String _selectedTransactionType = 'PIX'; // PIX, CREDITO, DEBITO

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Inicializando serviço...';
    });

    try {
      final config = CliSiTefConfig(
        sitefIp: _serverIPController.text,
        storeId: _storeIdController.text,
        terminalId: _terminalIdController.text,
        cashierOperator: _operatorController.text,
        enableLogs: true,
      );

      _service = CliSiTefServiceAgente(config: config);
      final initialized = await _service!.initialize();

      setState(() {
        _isLoading = false;
        _statusMessage = initialized ? 'Serviço inicializado com sucesso' : 'Erro ao inicializar serviço';
        _sessionId = _service?.currentSessionId ?? '';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Erro ao inicializar: $e';
      });
    }
  }

  // Obtém o código da função baseado no tipo de transação
  int _getFunctionCode(String transactionType) {
    switch (transactionType.toUpperCase()) {
      case 'CREDITO':
        return 3; // Venda a crédito
      case 'DEBITO':
        return 4; // Venda a débito
      case 'PIX':
        return 122; // Carteira Digital (PIX)
      default:
        return 122; // PIX como padrão
    }
  }

  Future<void> _executeTransaction() async {
    if (_service == null || !_service!.isInitialized) {
      _showMessage('Serviço não inicializado');
      return;
    }

    setState(() {
      _isLoading = true;
      _isInTransaction = true;
      _statusMessage = 'Iniciando transação $_selectedTransactionType...';
      _currentMessage = '';
      _menuOptions = [];
      _selectedMenuOption = '';
      _userInputController.clear();
      _waitingForUserInput = false;
    });

    try {
      final functionCode = _getFunctionCode(_selectedTransactionType);
      final amount = _amountController.text;
      final cupomFiscal = _cupomFiscalController.text;
      final operator = _operatorController.text;

      // Data e hora atuais
      final now = DateTime.now();
      final amountValue = double.tryParse(amount) ?? 0.0;

      final transactionData = TransactionData(
        functionId: functionCode,
        trnAmount: amountValue,
        taxInvoiceNumber: cupomFiscal,
        taxInvoiceDate: now,
        taxInvoiceTime: now,
      );

      // Inicia a transação usando o repositório
      final startResult = await _service!.startTransaction(transactionData);

      if (!startResult.isServiceSuccess) {
        throw Exception('Erro ao iniciar transação: ${startResult.errorMessage}');
      }

      setState(() {
        _sessionId = startResult.sessionId ?? '';
        _statusMessage = 'Transação iniciada. Status: ${startResult.clisitefStatus}';
        _isLoading = false;
      });

      // Processa o fluxo iterativo
      await _processInteractiveFlow();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isInTransaction = false;
        _statusMessage = 'Erro na transação: $e';
      });
      _showMessage('Erro: $e');
    }
  }

  Future<void> _processInteractiveFlow() async {
    if (!_isInTransaction || _sessionId.isEmpty) return;

    try {
      setState(() {
        _isLoading = true;
      });

      // Continua a transação usando o repositório
      final continueResult = await _service!.continueTransaction(
        sessionId: _sessionId,
        command: _currentCommandId,
        data: _currentData.isNotEmpty ? _currentData : null,
      );

      if (!continueResult.isServiceSuccess) {
        throw Exception('Erro ao continuar transação: ${continueResult.errorMessage}');
      }

      setState(() {
        _isLoading = false;
        _currentCommandId = continueResult.command ?? 0;
        _currentFieldId = continueResult.fieldType ?? 0;
        _currentData = continueResult.buffer ?? '';
        _statusMessage = 'Transação continuada. Status: ${continueResult.clisitefStatus}';
      });

      // Verifica se a transação foi finalizada
      if (continueResult.clisitefStatus == 0) {
        // Transação finalizada com sucesso
        setState(() {
          _isInTransaction = false;
          _statusMessage = 'Transação finalizada com sucesso!';
        });
        await _finishTransaction(true);
        return;
      } else if (continueResult.clisitefStatus == -2) {
        // Transação cancelada
        setState(() {
          _isInTransaction = false;
          _statusMessage = 'Transação cancelada';
        });
        await _finishTransaction(false);
        return;
      } else if (continueResult.clisitefStatus != 10000) {
        // Outro status que não é 10000 (continuação) nem 0 (sucesso) nem -2 (cancelamento)
        setState(() {
          _isInTransaction = false;
          _statusMessage = 'Status desconhecido: ${continueResult.clisitefStatus}';
        });
        await _finishTransaction(false);
        return;
      }

      // Processa o comando atual
      await _processCommand(continueResult);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isInTransaction = false;
        _statusMessage = 'Erro no fluxo iterativo: $e';
      });
      _showMessage('Erro no fluxo: $e');
    }
  }

  Future<void> _processCommand(TransactionResponse response) async {
    final commandId = response.command ?? 0;
    final data = response.buffer ?? '';

    setState(() {
      _currentMessage = 'Processando comando: $commandId';
      _waitingForUserInput = false;
    });

    void continueFlow() {
      Future.delayed(const Duration(milliseconds: 100), () {
        _processInteractiveFlow();
      });
    }

    switch (commandId) {
      case 0:
        _currentData = data;
        continueFlow();
        break;
      case 1:
        setState(() {
          _currentMessage = 'Mensagem para operador: $data';
        });
        _currentData = '';
        continueFlow();
        break;
      case 2:
        setState(() {
          _currentMessage = 'Mensagem para cliente: $data';
        });
        _currentData = '';
        continueFlow();
        break;
      case 3:
        setState(() {
          _currentMessage = 'Mensagem para ambos: $data';
        });
        _currentData = '';
        continueFlow();
        break;
      case 4:
        setState(() {
          _currentMessage = 'Título do menu: $data';
        });
        _currentData = '';
        continueFlow();
        break;
      case 20:
        setState(() {
          _currentMessage = 'Confirmação: $data';
          _waitingForUserInput = true;
        });
        await _waitForUserConfirmation();
        break;
      case 21:
        await _processMenuCommand(data);
        break;
      case 22:
        setState(() {
          _currentMessage = 'Pressione uma tecla: $data';
          _waitingForUserInput = true;
        });
        await _waitForUserInput();
        break;
      case 23:
        setState(() {
          _currentMessage = 'Deseja interromper? $data';
          _waitingForUserInput = true;
        });
        await _waitForUserConfirmation();
        break;
      case 29:
      case 30:
        await _processFieldCollection();
        break;
      case 31:
        await _processCheckCollection();
        break;
      case 34:
        await _processMonetaryFieldCollection();
        break;
      case 35:
        await _processBarcodeCollection();
        break;
      case 41:
        await _processMaskedFieldCollection();
        break;
      default:
        setState(() {
          _currentMessage = 'Comando desconhecido: $commandId';
        });
        _currentData = '';
        continueFlow();
        break;
    }
  }

  Future<void> _processMenuCommand(String menuData) async {
    // Parse das opções do menu (formato: "1:texto;2:texto;...")
    final options = <String>[];
    final parts = menuData.split(';');

    for (final part in parts) {
      final colonIndex = part.indexOf(':');
      if (colonIndex > 0) {
        final index = part.substring(0, colonIndex);
        final text = part.substring(colonIndex + 1);
        options.add('$index: $text');
      }
    }

    setState(() {
      _menuOptions = options;
      _currentMessage = 'Selecione uma opção:';
      _waitingForUserInput = true;
    });

    // Aguarda seleção do usuário
    await _waitForMenuSelection();
  }

  Future<void> _waitForMenuSelection() async {
    // Aguarda o usuário clicar em uma opção
    // A seleção será feita através do método _selectMenuOption
    // Não faz nada aqui, apenas aguarda o usuário clicar
  }

  void _selectMenuOption(String optionIndex) {
    if (_waitingForUserInput && _menuOptions.isNotEmpty) {
      final selectedOption = _menuOptions.firstWhere(
        (option) => option.startsWith('$optionIndex:'),
        orElse: () => _menuOptions.first,
      );

      setState(() {
        _selectedMenuOption = optionIndex;
        _currentData = optionIndex;
        _currentMessage = 'Opção selecionada: $selectedOption';
        _waitingForUserInput = false;
      });

      // Continua o fluxo após um pequeno delay
      Future.delayed(const Duration(milliseconds: 100), () {
        _processInteractiveFlow();
      });
    }
  }

  Future<void> _waitForUserConfirmation() async {
    // Aguarda o usuário clicar em Sim ou Não
    // A confirmação será feita através dos métodos _confirmYes ou _confirmNo
    // Não faz nada aqui, apenas aguarda o usuário clicar
  }

  void _confirmYes() {
    if (_waitingForUserInput) {
      setState(() {
        _currentData = '0'; // 0 = confirma
        _currentMessage = 'Confirmação enviada: Sim';
        _waitingForUserInput = false;
      });
      // Continua o fluxo após um pequeno delay
      Future.delayed(const Duration(milliseconds: 100), () {
        _processInteractiveFlow();
      });
    }
  }

  void _confirmNo() {
    if (_waitingForUserInput) {
      setState(() {
        _currentData = '1'; // 1 = cancela
        _currentMessage = 'Confirmação enviada: Não';
        _waitingForUserInput = false;
      });
      // Continua o fluxo após um pequeno delay
      Future.delayed(const Duration(milliseconds: 100), () {
        _processInteractiveFlow();
      });
    }
  }

  Future<void> _waitForUserInput() async {
    // Aguarda o usuário clicar em OK
    // A confirmação será feita através do método _confirmInput
    // Não faz nada aqui, apenas aguarda o usuário clicar
  }

  void _confirmInput() {
    if (_waitingForUserInput) {
      setState(() {
        _currentData = 'OK';
        _currentMessage = 'Tecla pressionada: OK';
        _waitingForUserInput = false;
      });
      // Continua o fluxo após um pequeno delay
      Future.delayed(const Duration(milliseconds: 100), () {
        _processInteractiveFlow();
      });
    }
  }

  Future<void> _processFieldCollection() async {
    setState(() {
      _currentMessage = 'Digite um valor ($_currentFieldMinLength-$_currentFieldMaxLength caracteres):';
      _waitingForUserInput = true;
    });

    // Aguarda entrada do usuário
    // A entrada será feita através do método _submitFieldInput
  }

  void _submitFieldInput() {
    if (_waitingForUserInput && _userInputController.text.isNotEmpty) {
      final input = _userInputController.text;
      setState(() {
        _currentData = input;
        _currentMessage = 'Valor digitado: $input';
        _waitingForUserInput = false;
      });
      _userInputController.clear();
      // Continua o fluxo após um pequeno delay
      Future.delayed(const Duration(milliseconds: 100), () {
        _processInteractiveFlow();
      });
    }
  }

  Future<void> _processCheckCollection() async {
    setState(() {
      _currentMessage = 'Digite o número do cheque:';
      _waitingForUserInput = true;
    });
  }

  Future<void> _processMonetaryFieldCollection() async {
    setState(() {
      _currentMessage = 'Digite o valor monetário:';
      _waitingForUserInput = true;
    });
  }

  Future<void> _processBarcodeCollection() async {
    setState(() {
      _currentMessage = 'Digite ou leia o código de barras:';
      _waitingForUserInput = true;
    });
  }

  Future<void> _processMaskedFieldCollection() async {
    setState(() {
      _currentMessage = 'Digite o valor (mascarado):';
      _waitingForUserInput = true;
    });
  }

  Future<void> _finishTransaction(bool confirm) async {
    try {
      final finishResult = await _service!.finishTransaction(
        sessionId: _sessionId,
        confirm: confirm,
        // Envia dados fiscais conforme homologação
        taxInvoiceNumber: _cupomFiscalController.text,
        taxInvoiceDate: FormatUtils.formatDate(DateTime.now()),
        taxInvoiceTime: FormatUtils.formatTime(DateTime.now()),
      );

      setState(() {
        _isLoading = false;
        _isInTransaction = false;
        _statusMessage = finishResult.isServiceSuccess
            ? 'Transação finalizada com sucesso (${finishResult.clisitefStatus})'
            : 'Erro ao finalizar: ${finishResult.message} (${finishResult.clisitefStatus})';
      });

      if (finishResult.isServiceSuccess && confirm) {
        _showMessage('Transação confirmada com sucesso!');
      } else if (finishResult.isServiceSuccess && !confirm) {
        _showMessage('Transação cancelada com sucesso!');
      } else {
        _showMessage('Erro ao finalizar transação: ${finishResult.message}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isInTransaction = false;
        _statusMessage = 'Erro ao finalizar: $e';
      });
      _showMessage('Erro ao finalizar: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('CliSiTef SDK - Totem Exemplo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: $_statusMessage',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _service?.isInitialized == true ? Icons.check_circle : Icons.error,
                          color: _service?.isInitialized == true ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(_service?.isInitialized == true ? 'Serviço inicializado' : 'Serviço não inicializado'),
                      ],
                    ),
                    if (_sessionId.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.key, size: 16),
                          const SizedBox(width: 8),
                          Text('Session ID: $_sessionId'),
                        ],
                      ),
                    ],
                    if (_isInTransaction) ...[
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(Icons.sync, size: 16, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Transação em andamento'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Estado da Transação
            if (_isInTransaction) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estado da Transação',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Comando: $_currentCommandId'),
                      Text('Campo: $_currentFieldId'),
                      if (_currentFieldMinLength > 0 || _currentFieldMaxLength > 0) Text('Tamanho: $_currentFieldMinLength-$_currentFieldMaxLength'),
                      if (_currentMessage.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('Mensagem: $_currentMessage'),
                      ],
                      if (_menuOptions.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text('Opções do Menu:'),
                        ...(_menuOptions.map((option) => Text('  • $option'))),
                        if (_selectedMenuOption.isNotEmpty) Text('Selecionado: $_selectedMenuOption'),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Interface de Interação
              if (_waitingForUserInput) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ação Necessária',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),

                        // Menu de opções
                        if (_menuOptions.isNotEmpty) ...[
                          const Text('Selecione uma opção:'),
                          const SizedBox(height: 8),
                          ...(_menuOptions.map((option) {
                            final optionIndex = option.split(':')[0];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ElevatedButton(
                                onPressed: () => _selectMenuOption(optionIndex),
                                child: Text(option),
                              ),
                            );
                          })),
                        ],

                        // Confirmação Sim/Não
                        if (_currentCommandId == 20 || _currentCommandId == 23) ...[
                          const Text('Confirmação:'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _confirmYes,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('SIM'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _confirmNo,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('NÃO'),
                                ),
                              ),
                            ],
                          ),
                        ],

                        // Aguarda tecla
                        if (_currentCommandId == 22) ...[
                          const Text('Pressione uma tecla:'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _confirmInput,
                            child: const Text('OK'),
                          ),
                        ],

                        // Campo de entrada
                        if (_currentCommandId == 29 ||
                            _currentCommandId == 30 ||
                            _currentCommandId == 31 ||
                            _currentCommandId == 34 ||
                            _currentCommandId == 35 ||
                            _currentCommandId == 41) ...[
                          TextField(
                            controller: _userInputController,
                            decoration: const InputDecoration(
                              labelText: 'Digite o valor',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _submitFieldInput,
                            child: const Text('Enviar'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],

            // Configuração
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuração',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _serverIPController,
                      decoration: const InputDecoration(
                        labelText: 'Sitef IP',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _storeIdController,
                      decoration: const InputDecoration(
                        labelText: 'Store ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _terminalIdController,
                      decoration: const InputDecoration(
                        labelText: 'Terminal ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Transação
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transação',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    // Seleção do tipo de transação
                    const Text('Tipo de Transação:'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() => _selectedTransactionType = 'CREDITO'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedTransactionType == 'CREDITO' ? Colors.blue : null,
                              foregroundColor: _selectedTransactionType == 'CREDITO' ? Colors.white : null,
                            ),
                            child: const Text('CRÉDITO'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() => _selectedTransactionType = 'DEBITO'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedTransactionType == 'DEBITO' ? Colors.blue : null,
                              foregroundColor: _selectedTransactionType == 'DEBITO' ? Colors.white : null,
                            ),
                            child: const Text('DÉBITO'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() => _selectedTransactionType = 'PIX'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedTransactionType == 'PIX' ? Colors.blue : null,
                              foregroundColor: _selectedTransactionType == 'PIX' ? Colors.white : null,
                            ),
                            child: const Text('PIX'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Tipo selecionado: $_selectedTransactionType (Código: ${_getFunctionCode(_selectedTransactionType)})'),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Valor (R\$)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _cupomFiscalController,
                      decoration: const InputDecoration(
                        labelText: 'Cupom Fiscal',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _operatorController,
                      decoration: const InputDecoration(
                        labelText: 'Operador',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botões
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_isLoading || _isInTransaction) ? null : _executeTransaction,
                    child: const Text('Executar Transação'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_isLoading || !_isInTransaction) ? null : () => _finishTransaction(false),
                    child: const Text('Cancelar Transação'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _showMessage('Verificar Estado não implementado'),
                    child: const Text('Verificar Estado'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _showMessage('Obter Versão não implementado'),
                    child: const Text('Obter Versão'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _initializeService,
              child: const Text('Reinicializar'),
            ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _service?.dispose();
    super.dispose();
  }
}
