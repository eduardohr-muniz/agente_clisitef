import 'dart:async';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/core/utils/format_utils.dart';
import 'package:agente_clisitef/src/core/utils/payment_method.dart';
import 'package:flutter/foundation.dart';

/// Serviço para transações pendentes de confirmação
/// Permite iniciar uma transação e decidir posteriormente se confirmar ou cancelar

const Duration _TIMEOUT_DURATION = Duration(minutes: 2);

class ClisitefReimpressaoComprovanteService {
  late final CliSiTefRepository _repository;
  late final CliSiTefCoreService _coreService;

  final CliSiTefConfig _config;
  bool _isInitialized = false;
  String? _currentSessionId;

  DateTime? _startTime;

  bool _forceCancel = false;

  ClisitefReimpressaoComprovanteService({
    required CliSiTefConfig config,
    CliSiTefRepository? repository,
  }) : _config = config {
    _repository = repository ?? CliSiTefRepositoryImpl(config: config);
    _coreService = CliSiTefCoreService(
      repository: _repository,
      config: config,
    );
  }

  final ValueNotifier<String> _messageDisplay = ValueNotifier('');
  ValueNotifier<String> get messageDisplay => _messageDisplay;

  void _preventLoop(TransactionResponse response) {
    if ((response.command ?? 0) < -1) {
      throw CliSiTefException.internalError(
        details: 'Erro ao processar transação: ${response.buffer ?? ''}',
        originalError: response,
      );
    }
    final timeoutExceeded = _startTime != null && DateTime.now().difference(_startTime!) > _TIMEOUT_DURATION;
    if (timeoutExceeded) {
      _forceCancel = true;
    }
  }

  void cancel() {
    _forceCancel = true;
  }

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
  Future<CliSiTefResponse> start(CancelationData data) async {
    if (!_isInitialized) {
      throw CliSiTefException.serviceNotInitialized(
        details: 'Serviço não foi inicializado antes de iniciar transação',
      );
    }

    try {
      CliSiTefResponse cliSiTefResponse = CliSiTefResponse();

      _startTime = DateTime.now();
      _forceCancel = false;
      final sessionId = await _createSession();

      final dataWithSessionId = data.copyWith(sessionId: sessionId, functionId: 110);

      await _repository.startTransaction(dataWithSessionId);

      String responseData = '';
      int clisitefStatus = -10;
      int commandId = 0;
      int fieldId = -10;

      // Primeira chamada continueTransaction para iniciar o fluxo
      final firstResponse = await _repository.continueTransaction(
        sessionId: sessionId,
        command: 0,
        data: '',
      );

      commandId = firstResponse.command ?? -1;

      fieldId = firstResponse.fieldType ?? 1000000000;
      responseData = '';

      while (true) {
        final response = await _repository.continueTransaction(sessionId: sessionId, command: commandId, data: responseData);

        if (response.fieldType != null) cliSiTefResponse.onFieldId(fieldId: response.fieldType!, buffer: response.buffer ?? '');
        _preventLoop(response);

        commandId = response.command ?? -10;
        fieldId = response.fieldType ?? -10;
        clisitefStatus = response.clisitefStatus;

        if (fieldId == -1) {
          _messageDisplay.value = response.buffer ?? '';
        }

        final hasError = _isErrorResponse(response);
        if (hasError) {
          throw CliSiTefException.internalError(
            details: 'Erro ao cancelar transação',
            originalError: response,
          );
        }

        final hasInteraction0 = hasInteraction(commandId);
        if (hasInteraction0) {
          if (commandId == 21 && fieldId == -1) {
            responseData = processMinusOne(response.buffer ?? '', data);
          } else {
            responseData = process21OR34(fieldId: fieldId, data: data);
          }
        } else {
          responseData = '';
        }
        if (commandId == 0 && fieldId == 0 && clisitefStatus == 255) {
          throw CliSiTefException.internalError(
            details: 'Erro ao cancelar transação',
            originalError: response,
          );
        }
        if (_forceCancel) break;
        // se o comando for 0 e o campo for 0, precisa finalizar a transação
        if (commandId == 0 && fieldId == 0 && clisitefStatus == 0) break;
      }

      if (_forceCancel) return cliSiTefResponse;

      await _repository.finishTransaction(
        sessionId: sessionId,
        confirm: true,
        taxInvoiceNumber: data.taxInvoiceNumber,
        taxInvoiceDate: data.taxInvoiceDate.toString().replaceAll('-', '').substring(0, 8), // YYYYMMDD
        taxInvoiceTime: data.taxInvoiceTime.toString().substring(11, 17).replaceAll(':', ''), // HHMMSS
      );

      return cliSiTefResponse;
    } catch (e) {
      throw CliSiTefException.internalError(
        details: 'Erro ao iniciar transação: $e',
        originalError: e,
      );
    }
  }

  bool _isErrorResponse(TransactionResponse response) {
    // Padrão identificado: fieldId 5084 com commandId 22 indica erro
    if (response.serviceStatus == 1) return true;

    if (response.clisitefStatus != 0 && response.clisitefStatus != 10000) {
      return true;
    }

    return false;
  }

  @visibleForTesting
  String processMinusOne(String buffer, CancelationData data) {
    buffer = buffer.toLowerCase().trim();

    if (buffer.contains("teste de comunicacao")) {
      //21;-1 1:Teste de comunicacao;2:Reimpressao de comprovante;3:Cancelamento de transacao;4:Pre-autorizacao;5:Consulta parcelas CDC;6:Consulta Private Label;7:Consulta saque e saque Fininvest;8:Consulta Saldo Debito;9:Consulta Saldo Credito;10:Outros Cielo;11:Carga forcada de tabelas no pinpad (Servidor);12:Consulta Saque Parcelado;13:Consulta Parcelas Cred. Conductor;14:Consulta Parcelas Cred. MarketPay;15:Saque Carteira Digital;16:Recarga Carteira Digital;17:Consulta Saldo Carteira Dig
      return '2';
    }
    if (buffer.contains('Ultimo comprovante')) {
      return '2';
    }

    return '';
  }

  @visibleForTesting
  String process21OR34({required int fieldId, required CancelationData data}) {
    switch (fieldId) {
      case 500:
        // Código do supervisor
        return "123456";
      case 516:
        // NSU host
        return data.nsuHost;
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

  /// Obtém a versão do SDK
  String get version => '1.0.0';

  /// Obtém o repositório (para controle manual do fluxo)
  CliSiTefRepository get repository => _repository;

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
