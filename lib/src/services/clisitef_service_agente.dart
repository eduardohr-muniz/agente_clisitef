import 'dart:async';
import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';
import 'package:agente_clisitef/src/core/services/message_manager.dart';
import 'package:agente_clisitef/src/models/clisitef_config.dart';
import 'package:agente_clisitef/src/models/clisitef_response.dart';
import 'package:agente_clisitef/src/models/transaction_data.dart';
import 'package:agente_clisitef/src/models/transaction_response.dart';
import 'package:agente_clisitef/src/models/transaction_result.dart';
import 'package:agente_clisitef/src/repositories/clisitef_repository.dart';
import 'package:agente_clisitef/src/repositories/clisitef_repository_impl.dart';
import 'package:agente_clisitef/src/services/clisitef_core_service.dart';
import 'package:agente_clisitef/src/services/clisitef_pinpad_service.dart';
import 'package:agente_clisitef/src/services/core/start_transaction_usecase.dart';

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
      print('[CliSiTefAgente] Inicializando serviço...');
      _messageManager.messageCashier.value = 'Inicializando serviço...';

      // Validar configuração
      final errors = _config.validate();
      if (errors.isNotEmpty) {
        print('[CliSiTefAgente] Erros de validação: ${errors.join(', ')}');
        _messageManager.processError(errorMessage: 'Erros de validação: ${errors.join(', ')}');
        return false;
      }

      // Criar sessão
      print('[CliSiTefAgente] Criando sessão...');
      _messageManager.messageCashier.value = 'Criando sessão...';
      final sessionResponse = await _repository.createSession();

      if (!sessionResponse.isServiceSuccess) {
        print('[CliSiTefAgente] Erro ao criar sessão: ${sessionResponse.errorMessage}');
        _messageManager.processError(errorMessage: 'Erro ao criar sessão: ${sessionResponse.errorMessage}');
        return false;
      }

      _currentSessionId = sessionResponse.sessionId;
      _isInitialized = true;

      print('[CliSiTefAgente] Serviço inicializado com sucesso. SessionId: $_currentSessionId');
      _messageManager.messageCashier.value = '✅ Serviço inicializado com sucesso';
      return true;
    } catch (e) {
      print('[CliSiTefAgente] Erro ao inicializar serviço: $e');
      _messageManager.processError(errorMessage: 'Erro ao inicializar serviço: $e');
      return false;
    }
  }

  /// Executa uma transação completa
  Future<TransactionResult> executeTransaction(TransactionData data) async {
    try {
      if (!_isInitialized) {
        print('[CliSiTefAgente] Serviço não inicializado');
        return TransactionResult.error(
          statusCode: CliSiTefConstants.TRANSACTION_NOT_INITIALIZED,
          message: 'Serviço não inicializado',
        );
      }

      print('[CliSiTefAgente] Executando transação: ${data.functionId}');

      // Usar o use case para processar a transação
      final useCase = StartTransactionUseCase(_repository);
      final result = await useCase.execute(
        data: data,
        autoProcess: true,
        stopBeforeFinish: false, // Transação normal finaliza automaticamente
      );

      if (!result.isSuccess) {
        print('[CliSiTefAgente] Erro na transação: ${result.errorMessage}');
        return TransactionResult.fromResponse(result.response);
      }

      if (result.isCompleted) {
        print('[CliSiTefAgente] Transação executada com sucesso');
        return TransactionResult.fromResponse(result.response);
      }

      // Caso pendente (não deveria acontecer no serviço normal)
      print('[CliSiTefAgente] Transação pendente inesperada');
      return TransactionResult.fromResponse(result.response);
    } catch (e) {
      print('[CliSiTefAgente] Erro inesperado na transação: $e');
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
    String? taxInvoiceDate,
    String? taxInvoiceTime,
  }) async {
    if (!_isInitialized) {
      throw Exception('Serviço não inicializado');
    }
    return await _repository.finishTransaction(
      sessionId: sessionId,
      confirm: confirm,
      taxInvoiceNumber: taxInvoiceNumber,
      taxInvoiceDate: taxInvoiceDate,
      taxInvoiceTime: taxInvoiceTime,
    );
  }

  /// Verifica a conectividade com o servidor
  Future<bool> checkConnectivity() async {
    try {
      print('[CliSiTefAgente] Verificando conectividade...');
      final response = await _repository.getState();
      final isConnected = response.isServiceSuccess;
      print('[CliSiTefAgente] Conectividade: ${isConnected ? 'OK' : 'FALHA'}');
      return isConnected;
    } catch (e) {
      print('[CliSiTefAgente] Erro ao verificar conectividade: $e');
      return false;
    }
  }

  /// Finaliza o serviço
  Future<void> dispose() async {
    try {
      print('[CliSiTefAgente] Finalizando serviço...');

      if (_currentSessionId != null) {
        await _repository.deleteSession();
        _currentSessionId = null;
      }

      _isInitialized = false;
      print('[CliSiTefAgente] Serviço finalizado');
    } catch (e) {
      print('[CliSiTefAgente] Erro ao finalizar serviço: $e');
    }
  }
}
