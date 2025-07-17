import 'dart:async';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/core/exceptions/clisitef_exception.dart';
import 'package:agente_clisitef/src/core/exceptions/clisitef_error_codes.dart';
import 'package:agente_clisitef/src/core/utils/format_utils.dart';
import 'package:agente_clisitef/src/models/clisitef_config.dart';
import 'package:agente_clisitef/src/models/clisitef_response.dart';
import 'package:agente_clisitef/src/models/captura_tardia_transaction.dart';
import 'package:agente_clisitef/src/models/transaction_data.dart';
import 'package:agente_clisitef/src/repositories/clisitef_repository.dart';
import 'package:agente_clisitef/src/repositories/clisitef_repository_impl.dart';
import 'package:agente_clisitef/src/services/clisitef_core_service.dart';
import 'package:agente_clisitef/src/services/clisitef_pinpad_service.dart';
import 'package:agente_clisitef/src/services/core/start_transaction_usecase.dart';

/// Serviço para transações pendentes de confirmação
/// Permite iniciar uma transação e decidir posteriormente se confirmar ou cancelar
class CliSiTefServiceCapturaTardia {
  late final CliSiTefRepository _repository;
  late final CliSiTefCoreService _coreService;
  late final CliSiTefPinPadService _pinpadService;

  final CliSiTefConfig _config;
  bool _isInitialized = false;
  String? _currentSessionId;

  CliSiTefServiceCapturaTardia({
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
      // Validar configuração
      final errors = _config.validate();
      if (errors.isNotEmpty) {
        throw CliSiTefException.invalidConfiguration(
          details: 'Erros de validação: ${errors.join(', ')}',
        );
      }

      // Criar sessão
      final sessionResponse = await _repository.createSession();

      if (!sessionResponse.isServiceSuccess) {
        throw CliSiTefException.fromCode(
          sessionResponse.clisitefStatus,
          details: 'Erro ao criar sessão: ${sessionResponse.errorMessage}',
          originalError: sessionResponse,
        );
      }

      _currentSessionId = sessionResponse.sessionId;
      _isInitialized = true;

      return true;
    } catch (e) {
      // Se já é uma CliSiTefException, rethrow
      if (e is CliSiTefException) {
        rethrow;
      }

      // Converter erro genérico para CliSiTefException
      throw CliSiTefException.internalError(
        details: 'Erro ao inicializar serviço: $e',
        originalError: e,
      );
    }
  }

  /// Inicia uma transação e retorna um modelo pendente
  /// A transação NÃO é finalizada automaticamente
  Future<CapturaTardiaTransaction?> startPendingTransaction(TransactionData data) async {
    try {
      if (!_isInitialized) {
        throw CliSiTefException.serviceNotInitialized(
          details: 'Serviço não foi inicializado antes de iniciar transação',
        );
      }

      // Usar o use case para processar a transação
      final useCase = StartTransactionUseCase(_repository);
      final result = await useCase.execute(
        data: data,
        autoProcess: true,
        stopBeforeFinish: true, // Transação pendente para antes da finalização
      );

      if (!result.isSuccess) {
        // Verificar se é um código de cancelamento específico
        final errorCode = result.response.clisitefStatus;
        if (CliSiTefErrorCode.isCancellationCode(errorCode)) {
          throw _createCancellationException(errorCode, result.errorMessage);
        }

        throw CliSiTefException.fromCode(
          errorCode,
          details: result.errorMessage,
          originalError: result.response,
        );
      }

      // Criar transação pendente com os campos mapeados
      if (result.response.clisitefStatus < 0) {
        throw CliSiTefException.fromCode(
          result.response.clisitefStatus,
          details: result.response.errorMessage,
          originalError: result.response,
        );
      }
      return CapturaTardiaTransaction(
        invoiceNumber: data.taxInvoiceNumber,
        sessionId: result.response.sessionId ?? _currentSessionId!,
        response: result.response,
        repository: _repository,
        clisitefFields: result.clisitefFields ?? CliSiTefResponse(),
        invoiceDate: data.taxInvoiceDate,
        invoiceTime: data.taxInvoiceTime,
      );
    } catch (e) {
      // Se já é uma CliSiTefException, rethrow
      if (e is CliSiTefException) {
        rethrow;
      }

      // Converter erro genérico para CliSiTefException
      throw CliSiTefException.internalError(
        details: 'Erro inesperado na transação: $e',
        originalError: e,
      );
    }
  }

  Future<bool> cancelarTransacao({
    required String taxInvoiceNumber,
    required DateTime taxInvoiceDate,
    required DateTime taxInvoiceTime,
  }) async {
    if (!_isInitialized) {
      throw Exception('Serviço não inicializado');
    }
    return await _repository.finishEstornandoTransaction(
      confirm: 0,
      sitefIp: _config.sitefIp,
      storeId: _config.storeId,
      terminalId: _config.terminalId,
      taxInvoiceNumber: taxInvoiceNumber,
      taxInvoiceDate: FormatUtils.formatDate(taxInvoiceDate),
      taxInvoiceTime: FormatUtils.formatTime(taxInvoiceTime),
    );
  }

  /// Cria uma exceção de cancelamento baseada no código de erro
  CliSiTefException _createCancellationException(int code, String? message) {
    switch (code) {
      case -2:
        return CliSiTefException.operatorCancelled(
          details: message ?? 'Operador cancelou a operação',
        );
      case -6:
        return CliSiTefException.userCancelled(
          details: message ?? 'Usuário cancelou a operação no pinpad',
        );
      case -15:
        return CliSiTefException.automationCancelled(
          details: message ?? 'Sistema cancelou automaticamente a operação',
        );
      default:
        return CliSiTefException.fromCode(
          code,
          details: message ?? 'Cancelamento desconhecido',
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

  /// Verifica a conectividade com o servidor
  Future<bool> checkConnectivity() async {
    try {
      final response = await _repository.getState();
      final isConnected = response.isServiceSuccess;
      return isConnected;
    } catch (e) {
      throw CliSiTefException.connectionError(
        details: 'Erro ao verificar conectividade: $e',
        originalError: e,
      );
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
