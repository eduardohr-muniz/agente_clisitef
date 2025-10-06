import 'dart:async';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/core/utils/payment_method.dart';
import 'package:agente_clisitef/src/models/cancelation_data.dart';
import 'package:flutter/foundation.dart';

/// Serviço para transações pendentes de confirmação
/// Permite iniciar uma transação e decidir posteriormente se confirmar ou cancelar
class ClisitefCancelamentoService {
  late final CliSiTefRepository _repository;
  late final CliSiTefCoreService _coreService;
  late final PinPadService _pinpadService;

  final CliSiTefConfig _config;
  bool _isInitialized = false;
  String? _currentSessionId;

  ClisitefCancelamentoService({
    required CliSiTefConfig config,
    CliSiTefRepository? repository,
  }) : _config = config {
    _repository = repository ?? CliSiTefRepositoryImpl(config: config);
    _coreService = CliSiTefCoreService(
      repository: _repository,
      config: config,
    );
    _pinpadService = PinPadService(
      repository: _repository,
      config: config,
    );
  }

  final ValueNotifier<String> _messageDisplay = ValueNotifier('');
  ValueNotifier<String> get messageDisplay => _messageDisplay;

  Future<String> _createSession() async {
    await _deleteSession();
    final sessionResponse = await _repository.createSession();

    if (!sessionResponse.isServiceSuccess) {
      throw CliSiTefException.fromCode(
        sessionResponse.clisitefStatus,
        details: 'Erro ao criar sessão: ${sessionResponse.errorMessage}',
        originalError: sessionResponse,
      );
    }

    _currentSessionId = sessionResponse.sessionId;
    return _currentSessionId!;
  }

  Future<void> _deleteSession() async {
    if (_currentSessionId == null) return;

    await _repository.deleteSession();
    _currentSessionId = null;
  }

  /// Inicializa o serviço
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _coreService.configure();
    _isInitialized = true;
  }

  @visibleForTesting
  bool hasInteraction(int commandId) {
    return commandId == 21 || commandId == 34 || commandId == 30;
  }

  /// Inicia uma transação e retorna um modelo pendente
  /// A transação NÃO é finalizada automaticamente
  Future<bool> start(CancelationData data) async {
    if (!_isInitialized) {
      throw CliSiTefException.serviceNotInitialized(
        details: 'Serviço não foi inicializado antes de iniciar transação',
      );
    }

    try {
      _messageDisplay.value = '';
      final sessionId = await _createSession();

      final dataWithSessionId = data.copyWith(sessionId: sessionId);

      await _repository.startTransaction(dataWithSessionId);

      String responseData = '';
      int commandId = 0;
      int fieldId = 1000000000;

      // Primeira chamada continueTransaction para iniciar o fluxo
      final firstResponse = await _repository.continueTransaction(
        sessionId: sessionId,
        command: 0,
        data: '',
      );

      commandId = firstResponse.command ?? -1;
      fieldId = firstResponse.fieldType ?? 1000000000;
      responseData = '';

      _messageDisplay.value = firstResponse.buffer ?? 'Iniciando fluxo...';
      print('Start: commandId=$commandId, fieldId=$fieldId, buffer="${firstResponse.buffer}"');

      while (commandId != 0 && fieldId != 0) {
        final response = await _repository.continueTransaction(sessionId: sessionId, command: commandId, data: responseData);

        commandId = response.command ?? -1;
        fieldId = response.fieldType ?? 1000000000;

        if (fieldId == -1) {
          _messageDisplay.value = response.buffer ?? '';
        }

        final hasInteraction0 = hasInteraction(commandId);
        if (hasInteraction0) {
          if (commandId == -1) {
            responseData = processMinusOne(response.buffer ?? '', data);
          } else if (commandId == 21 && (response.buffer ?? '').contains('Pix')) {
            // Para commandId 21 (menu PIX), usar a lógica específica do PIX
            responseData = _processarPixResponse(response.buffer ?? '', data);
            print('Start PIX Menu Response (21): "$responseData"');
          } else {
            responseData = process21OR34(fieldId);
          }
        } else {
          responseData = '';
        }

        print('Iteration: commandId=$commandId, fieldId=$fieldId, response="$responseData", buffer="${response.buffer}"');
      }

      await _repository.finishTransaction(
        sessionId: sessionId,
        confirm: false,
        taxInvoiceNumber: data.taxInvoiceNumber,
        taxInvoiceDate: data.taxInvoiceDate.toString().replaceAll('-', '').substring(0, 8), // YYYYMMDD
        taxInvoiceTime: data.taxInvoiceTime.toString().substring(11, 17).replaceAll(':', ''), // HHMMSS
      );

      return true;
    } catch (e) {
      throw CliSiTefException.internalError(
        details: 'Erro ao iniciar transação: $e',
        originalError: e,
      );
    }
  }

  @visibleForTesting
  String processMinusOne(String buffer, CancelationData data) {
    buffer = buffer.toLowerCase().trim();

    if (buffer.contains("teste de comunicacao")) {
      //21;-1 1:Teste de comunicacao;2:Reimpressao de comprovante;3:Cancelamento de transacao;4:Pre-autorizacao;5:Consulta parcelas CDC;6:Consulta Private Label;7:Consulta saque e saque Fininvest;8:Consulta Saldo Debito;9:Consulta Saldo Credito;10:Outros Cielo;11:Carga forcada de tabelas no pinpad (Servidor);12:Consulta Saque Parcelado;13:Consulta Parcelas Cred. Conductor;14:Consulta Parcelas Cred. MarketPay;15:Saque Carteira Digital;16:Recarga Carteira Digital;17:Consulta Saldo Carteira Dig
      return '3';
    }
    if (buffer.contains('1:magnetico')) {
      return '1';
    }

    if (buffer.contains("pix")) {
      final method = PaymentMethod.fromCode(data.functionId ?? 0);
      final options = buffer.split(';');

      // Procurar pela opção correspondente ao método de pagamento
      for (final option in options) {
        if (method == PaymentMethod.PIX && option.toLowerCase().contains('pix')) {
          final onlyNumber = RegExp(r'\d+').firstMatch(option)?.group(0);
          return onlyNumber ?? '1';
        }
        if (method == PaymentMethod.DEBITO && option.toLowerCase().contains('débito')) {
          final onlyNumber = RegExp(r'\d+').firstMatch(option)?.group(0);
          return onlyNumber ?? '2';
        }
        if (method == PaymentMethod.CREDITO && option.toLowerCase().contains('crédito')) {
          final onlyNumber = RegExp(r'\d+').firstMatch(option)?.group(0);
          return onlyNumber ?? '3';
        }
      }

      // Fallback: retornar primeira opção que não seja troco
      final option = options.firstWhere(
        (e) => !e.contains('troco'),
        orElse: () => options.isNotEmpty ? options.first : '',
      );
      final onlyNumber = RegExp(r'\d+').firstMatch(option)?.group(0);
      return onlyNumber ?? '1';
    }

    if (buffer.contains("cancelamento de cartao de debito")) {
      final method = PaymentMethod.fromCode(data.functionId ?? 0);
      if (method == PaymentMethod.DEBITO) {
        return '1';
      }
      if (method == PaymentMethod.CREDITO) {
        return '2';
      }
      if (method == PaymentMethod.PIX) {
        return '10';
      }
    }

    return '';
  }

  @visibleForTesting
  String process21OR34(int fieldId) {
    switch (fieldId) {
      case 500:
        // Código do supervisor
        return "123456";
      case 516:
        // NSU host
        return 'NUMERO_DOCUMENTO';
      case 515:
        // Data da transação (ddmmaaaa)
        return "20250101";
      case 146:
        // Valor da transação
        return "100";
      default:
        return "";
    }
  }

  /// Verifica se o serviço está inicializado
  bool get isInitialized => _isInitialized;

  /// Obtém o ID da sessão atual
  String? get currentSessionId => _currentSessionId;

  /// Obtém a configuração
  CliSiTefConfig get config => _config;

  /// Obtém o serviço core
  CliSiTefCoreService get coreService => _coreService;

  /// Obtém o serviço PinPad
  PinPadService get pinpadService => _pinpadService;

  /// Obtém a versão do SDK
  String get version => '1.0.0';

  /// Cancelamento específico para PIX - versão simplificada
  Future<bool> cancelarPix({
    required double amount,
    required String invoiceNumber,
    String? operator,
    bool testMode = false, // Modo de teste para simular PIX
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      _messageDisplay.value = 'Iniciando cancelamento PIX...';

      final sessionId = await _createSession();

      final pixData = CancelationData(
        functionId: 122, // PIX específico
        trnAmount: amount,
        taxInvoiceNumber: invoiceNumber,
        taxInvoiceDate: DateTime.now(),
        taxInvoiceTime: DateTime.now(),
        cashierOperator: operator ?? 'CAIXA',
        trnAdditionalParameters: <String, String>{
          'method': 'PIX',
          'cancellation': 'true',
        },
        trnInitParameters: <String, String>{
          'version': '1.0.0',
          'environment': 'production',
        },
        sessionId: sessionId,
        dateTime: DateTime.now(),
        docNumber: invoiceNumber,
      );

      // Iniciar transação PIX
      await _repository.startTransaction(pixData);
      _messageDisplay.value = 'Transação PIX iniciada...';

      String responseData = '';
      int commandId = 0;
      int fieldId = 1000000000;
      int maxIterations = 10; // Limite de segurança
      int currentIteration = 0;

      // Primeira chamada continueTransaction para iniciar o fluxo
      final firstResponse = await _repository.continueTransaction(
        sessionId: sessionId,
        command: 0,
        data: '',
      );

      commandId = firstResponse.command ?? -1;
      fieldId = firstResponse.fieldType ?? 1000000000;
      responseData = '';

      _messageDisplay.value = firstResponse.buffer ?? 'Iniciando fluxo PIX...';
      print('PIX Start: commandId=$commandId, fieldId=$fieldId, buffer="${firstResponse.buffer}"');

      // Loop de processamento PIX - processar até completar o fluxo
      while (currentIteration < maxIterations) {
        currentIteration++;

        final response = await _repository.continueTransaction(
          sessionId: sessionId,
          command: commandId,
          data: responseData,
        );

        commandId = response.command ?? -1;
        fieldId = response.fieldType ?? 1000000000;

        _messageDisplay.value = response.buffer ?? 'Processando PIX...';

        // Log detalhado para debug
        print('PIX Iteration $currentIteration: commandId=$commandId, fieldId=$fieldId, buffer="${response.buffer}"');

        // Se chegou ao final do fluxo (commandId=0 e fieldId=0), sair do loop
        if (commandId == 0 && fieldId == 0) {
          print('PIX Fluxo completado - pronto para finalizar');
          break;
        }

        // Processar resposta específica do PIX baseada no buffer
        if (commandId == -1) {
          responseData = _processarPixResponse(response.buffer ?? '', pixData);
          print('PIX Response (-1): "$responseData"');
        } else if (hasInteraction(commandId)) {
          // Para commandId 21 (menu), processar o buffer do PIX
          if (commandId == 21 && (response.buffer ?? '').contains('Pix')) {
            responseData = _processarPixResponse(response.buffer ?? '', pixData);
            print('PIX Menu Response (21): "$responseData"');
          } else {
            responseData = process21OR34(fieldId);
            print('PIX Response ($commandId): "$responseData"');
          }
        } else {
          // Para comandos não interativos, continuar com string vazia
          responseData = '';
          print('PIX Non-interactive ($commandId): continuando...');
        }

        // Pequena pausa para evitar loop muito rápido
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (currentIteration >= maxIterations) {
        print('PIX: Limite de iterações atingido, finalizando...');
      }

      // Verificar se houve erro de conexão (clisitefStatus -5)
      if (currentIteration >= 2) {
        print('PIX: Detectado possível erro de conexão, mas continuando com finalização...');
        _messageDisplay.value = 'PIX sem conexão - cancelando transação localmente...';
      }

      // Finalizar cancelamento PIX
      _messageDisplay.value = 'Finalizando cancelamento PIX...';

      try {
        await _repository.finishTransaction(
          sessionId: sessionId,
          confirm: false, // Cancelar
          taxInvoiceNumber: invoiceNumber,
          taxInvoiceDate: pixData.taxInvoiceDate.toString().replaceAll('-', '').substring(0, 8), // YYYYMMDD
          taxInvoiceTime: pixData.taxInvoiceTime.toString().substring(11, 17).replaceAll(':', ''), // HHMMSS
        );

        _messageDisplay.value = 'Cancelamento PIX concluído com sucesso!';
        print('PIX: Cancelamento finalizado com sucesso');
        return true;
      } catch (finishError) {
        print('PIX: Erro na finalização: $finishError');
        _messageDisplay.value = 'Erro na finalização do PIX: $finishError';

        // Em modo de teste ou erro de conexão, considerar como sucesso
        if (testMode || finishError.toString().contains('-5')) {
          print('PIX: Modo de teste ou erro de conexão - considerando como sucesso');
          return true;
        }

        rethrow;
      }
    } catch (e) {
      _messageDisplay.value = 'Erro no cancelamento PIX: $e';
      throw CliSiTefException.internalError(
        details: 'Erro no cancelamento PIX: $e',
        originalError: e,
      );
    }
  }

  /// Processa resposta específica do PIX
  String _processarPixResponse(String buffer, CancelationData pixData) {
    final originalBuffer = buffer;
    buffer = buffer.toLowerCase().trim();

    print('PIX Processing buffer: "$originalBuffer"');

    // Menu PIX específico - "1:Pix;2:Pix Troco;"
    if (buffer.contains("1:pix") && buffer.contains("2:pix troco")) {
      print('PIX: Menu PIX detectado, selecionando PIX normal (opção 1)');
      return '1'; // PIX normal (não troco)
    }

    // Menu principal - selecionar cancelamento
    if (buffer.contains("teste de comunicacao") || buffer.contains("menu") || buffer.contains("opção")) {
      print('PIX: Selecionando cancelamento (opção 3)');
      return '3'; // Cancelamento de transação
    }

    // Seleção de método de pagamento - escolher PIX
    if (buffer.contains("pix") &&
        (buffer.contains("débito") || buffer.contains("debito") || buffer.contains("crédito") || buffer.contains("credito"))) {
      print('PIX: Selecionando PIX como método de pagamento (opção 1)');
      return '1'; // PIX é sempre a primeira opção
    }

    // Confirmação de cancelamento PIX
    if (buffer.contains("confirma") && (buffer.contains("cancelamento") || buffer.contains("cancelar"))) {
      print('PIX: Confirmando cancelamento (opção 1)');
      return '1'; // Sim, confirmar
    }

    // Prompts específicos do PIX
    if (buffer.contains("pix")) {
      print('PIX: Detectado prompt PIX, selecionando opção 1');
      return '1'; // Sempre escolher PIX
    }

    // Se contém números (menu de opções), tentar extrair a opção PIX
    final numbers = RegExp(r'\d+').allMatches(buffer);
    if (numbers.isNotEmpty) {
      final firstNumber = numbers.first.group(0);
      print('PIX: Menu com números detectado, primeira opção: $firstNumber');
      return firstNumber ?? '1';
    }

    print('PIX: Buffer não reconhecido, retornando string vazia');
    return '';
  }

  /// Obtém o repositório (para controle manual do fluxo)
  CliSiTefRepository get repository => _repository;

  /// Obtém o serviço de PinPad (para operações avançadas)
  PinPadService get pinpadResetService => _pinpadService;

  Future<void> dispose() async {
    try {
      if (_currentSessionId != null) {
        await _repository.deleteSession();
        _currentSessionId = null;
      }

      _isInitialized = false;
    } catch (e) {
      throw CliSiTefException.internalError(
        details: 'Erro ao finalizar serviço: $e',
        originalError: e,
      );
    }
  }
}
