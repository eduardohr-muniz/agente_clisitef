import 'dart:async';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/core/utils/format_utils.dart';

/// Serviço principal do CliSiTef para integração com AgenteCliSiTef
class CliSiTefServiceAgente {
  late final CliSiTefRepository _repository;
  late final CliSiTefCoreService _coreService;
  late final CliSiTefPinPadService _pinpadService;
  final AgenteClisitefMessageManager _messageManager = AgenteClisitefMessageManager.instance;

  final CliSiTefConfig _config;
  bool _isInitialized = false;
  String? _currentSessionId;

  CliSiTefServiceAgente({
    required CliSiTefConfig config,
    CliSiTefRepository? repository,
  }) : _config = config {
    _repository = repository ?? CliSiTefRepositoryImpl(config: config);
    _coreService = CliSiTefCoreService(
      repository: _repository,
      config: config,
    );
    _pinpadService = CliSiTefPinPadService(
      repository: _repository,
      config: config,
    );
  }

  /// Inicializa o serviço
  Future<bool> initialize() async {
    try {
      _messageManager.messageCashier.value = 'Inicializando serviço...';

      // Validar configuração
      final errors = _config.validate();
      if (errors.isNotEmpty) {
        _messageManager.processError(errorMessage: 'Erros de validação: ${errors.join(', ')}');
        return false;
      }

      // Criar sessão
      _messageManager.messageCashier.value = 'Criando sessão...';
      final sessionResponse = await _repository.createSession();

      if (!sessionResponse.isServiceSuccess) {
        _messageManager.processError(errorMessage: 'Erro ao criar sessão: ${sessionResponse.errorMessage}');
        return false;
      }

      _currentSessionId = sessionResponse.sessionId;
      _isInitialized = true;

      _messageManager.messageCashier.value = '✅ Serviço inicializado com sucesso';
      return true;
    } catch (e) {
      _messageManager.processError(errorMessage: 'Erro ao inicializar serviço: $e');
      return false;
    }
  }

  /// Executa uma transação completa
  Future<TransactionResult> executeTransaction(TransactionData data) async {
    try {
      if (!_isInitialized) {
        return TransactionResult.error(
          statusCode: CliSiTefConstants.TRANSACTION_NOT_INITIALIZED,
          message: 'Serviço não inicializado',
        );
      }

      // Usar o use case para processar a transação
      final useCase = StartTransactionUseCase(_repository);
      final result = await useCase.execute(
        data: data,
        autoProcess: true,
        stopBeforeFinish: false, // Transação normal finaliza automaticamente
      );

      if (!result.isSuccess) {
        return TransactionResult.fromResponse(result.response);
      }

      if (result.isCompleted) {
        return TransactionResult.fromResponse(result.response);
      }

      // Caso pendente (não deveria acontecer no serviço normal)
      return TransactionResult.fromResponse(result.response);
    } catch (e) {
      return TransactionResult.error(
        statusCode: CliSiTefConstants.TRANSACTION_INTERNAL_ERROR,
        message: 'Erro interno: $e',
      );
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
  CliSiTefPinPadService get pinpadService => _pinpadService;

  /// Obtém a versão do SDK
  String get version => '1.0.0';

  /// Obtém o repositório (para controle manual do fluxo)
  CliSiTefRepository get repository => _repository;

  /// Obtém o MessageManager
  AgenteClisitefMessageManager get messageManager => _messageManager;

  /// Inicia uma transação manualmente
  Future<TransactionResponse> startTransaction(TransactionData data) async {
    if (!_isInitialized) {
      throw Exception('Serviço não inicializado');
    }
    return await _repository.startTransaction(data);
  }

  /// Continua uma transação manualmente
  Future<TransactionResponse> continueTransaction({
    required String sessionId,
    required int command,
    String? data,
  }) async {
    if (!_isInitialized) {
      throw Exception('Serviço não inicializado');
    }
    return await _repository.continueTransaction(
      sessionId: sessionId,
      command: command,
      data: data,
    );
  }

  /// Finaliza uma transação manualmente
  Future<TransactionResponse> finishTransaction({
    required String sessionId,
    required bool confirm,
    String? taxInvoiceNumber,
    required DateTime taxInvoiceDate,
    required DateTime taxInvoiceTime,
  }) async {
    if (!_isInitialized) {
      throw Exception('Serviço não inicializado');
    }
    return await _repository.finishTransaction(
      sessionId: sessionId,
      confirm: confirm,
      taxInvoiceNumber: taxInvoiceNumber,
      taxInvoiceDate: FormatUtils.formatDate(taxInvoiceDate),
      taxInvoiceTime: FormatUtils.formatTime(taxInvoiceTime),
    );
  }

  /// Verifica a conectividade com o servidor
  Future<bool> checkConnectivity() async {
    try {
      final response = await _repository.getState();
      final isConnected = response.isServiceSuccess;
      return isConnected;
    } catch (e) {
      return false;
    }
  }

  /// Finaliza o serviço
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
