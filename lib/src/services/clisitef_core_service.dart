import 'dart:async';
import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';
import 'package:agente_clisitef/src/core/services/message_manager.dart';
import 'package:agente_clisitef/src/models/clisitef_config.dart';
import 'package:agente_clisitef/src/models/transaction_data.dart';
import 'package:agente_clisitef/src/models/transaction_response.dart';
import 'package:agente_clisitef/src/models/transaction_result.dart';
import 'package:agente_clisitef/src/repositories/clisitef_repository.dart';

/// Serviço core do CliSiTef baseado na especificação oficial
class CliSiTefCoreService {
  final CliSiTefRepository _repository;
  final CliSiTefConfig _config;
  final AgenteClisitefMessageManager _messageManager = AgenteClisitefMessageManager.instance;

  bool _isInitialized = false;
  bool _isTransactionInProgress = false;
  String? _currentSessionId;

  CliSiTefCoreService({
    required CliSiTefRepository repository,
    required CliSiTefConfig config,
  })  : _repository = repository,
        _config = config;

  /// Configura o CliSiTef
  Future<bool> configure() async {
    // Apenas valida a configuração localmente
    final errors = _config.validate();
    if (errors.isNotEmpty) {
      _messageManager.processError(errorMessage: 'Erros de validação: ${errors.join(', ')}');
      return false;
    }
    _isInitialized = true;
    _messageManager.messageCashier.value = '✅ Configuração validada com sucesso';
    return true;
  }

  /// Executa uma transação completa seguindo o fluxo da especificação
  Future<TransactionResult> executeTransaction(TransactionData transactionData) async {
    try {
      if (!_isInitialized) {
        _messageManager.processError(errorMessage: 'Módulo não inicializado');
        return TransactionResult.error(
          statusCode: -1,
          message: 'Módulo não inicializado',
        );
      }

      if (_isTransactionInProgress) {
        _messageManager.processError(errorMessage: 'Transação já em andamento');
        return TransactionResult.error(
          statusCode: -12,
          message: 'Transação já em andamento',
        );
      }

      _isTransactionInProgress = true;
      _messageManager.messageCashier.value = '🚀 Iniciando transação...';

      // Validar dados da transação
      final errors = transactionData.validate();
      if (errors.isNotEmpty) {
        _isTransactionInProgress = false;
        return TransactionResult.error(
          statusCode: -20,
          message: 'Dados da transação inválidos: ${errors.join(', ')}',
        );
      }

      // Iniciar transação
      final startResponse = await _repository.startTransaction(transactionData);

      if (!startResponse.isServiceSuccess) {
        _isTransactionInProgress = false;
        return TransactionResult.fromResponse(startResponse);
      }

      // Se não precisa continuar, finaliza
      if (!startResponse.shouldContinue) {
        _isTransactionInProgress = false;
        return TransactionResult.fromResponse(startResponse);
      }

      // Processo iterativo
      final iterativeResult = await _executeIterativeProcess(startResponse);
      _isTransactionInProgress = false;
      return iterativeResult;
    } catch (e) {
      _isTransactionInProgress = false;
      return TransactionResult.error(
        statusCode: -100,
        message: 'Erro interno: $e',
      );
    }
  }

  /// Executa o processo iterativo conforme especificação
  Future<TransactionResult> _executeIterativeProcess(TransactionResponse initialResponse) async {
    try {
      TransactionResponse currentResponse = initialResponse;
      final responses = <TransactionResponse>[currentResponse];
      String? sessionId = currentResponse.sessionId ?? _currentSessionId;
      if (sessionId == null) {
        return TransactionResult.error(
          statusCode: -10,
          message: 'SessionId não encontrado',
        );
      }
      // Loop iterativo conforme especificação
      while (currentResponse.shouldContinue) {
        final userInput = await _processCommand(currentResponse);
        currentResponse = await _repository.continueTransaction(
          sessionId: sessionId,
          command: currentResponse.command!,
          data: userInput,
        );
        responses.add(currentResponse);
        if (!currentResponse.isServiceSuccess) {
          return TransactionResult.fromResponse(currentResponse);
        }
      }
      return TransactionResult.fromResponse(currentResponse);
    } catch (e) {
      return TransactionResult.error(
        statusCode: -12,
        message: 'Erro no processo iterativo: $e',
      );
    }
  }

  /// Processa um comando da transação
  Future<String?> _processCommand(TransactionResponse response) async {
    try {
      switch (response.command) {
        case CliSiTefConstants.COMMAND_DISPLAY_MESSAGE:
          return '';
        case CliSiTefConstants.COMMAND_COLLECT_AMOUNT:
          return '10,00';
        case CliSiTefConstants.COMMAND_COLLECT_OPERATOR:
          return 'CAIXA';
        case CliSiTefConstants.COMMAND_COLLECT_CUPOM:
          return '123456';
        case CliSiTefConstants.COMMAND_COLLECT_DATE:
          return '20241201';
        case CliSiTefConstants.COMMAND_COLLECT_TIME:
          return '1430';
        case CliSiTefConstants.COMMAND_COLLECT_PASSWORD:
          return '1234';
        case CliSiTefConstants.COMMAND_COLLECT_CARD:
          return '';
        case CliSiTefConstants.COMMAND_COLLECT_YES_NO:
          return 'S';
        case CliSiTefConstants.COMMAND_COLLECT_MENU:
          return '1';
        case CliSiTefConstants.COMMAND_COLLECT_FLOAT:
          return '10.50';
        default:
          return '';
      }
    } catch (e) {
      return null;
    }
  }

  /// Verifica a presença do PinPad
  Future<bool> checkPinPadPresence() async {
    try {
      if (!_isInitialized) {
        return false;
      }
      return await _repository.checkPinPadPresence();
    } catch (e) {
      return false;
    }
  }

  /// Define mensagem no PinPad
  Future<int> setPinPadMessage(String message) async {
    try {
      if (!_isInitialized) {
        return -1;
      }
      return await _repository.setPinPadMessage(message);
    } catch (e) {
      return -1;
    }
  }

  /// Verifica se está inicializado
  bool get isInitialized => _isInitialized;

  /// Verifica se há transação em andamento
  bool get isTransactionInProgress => _isTransactionInProgress;

  /// Obtém a configuração
  CliSiTefConfig get config => _config;

  /// Obtém o MessageManager
  AgenteClisitefMessageManager get messageManager => _messageManager;
}
