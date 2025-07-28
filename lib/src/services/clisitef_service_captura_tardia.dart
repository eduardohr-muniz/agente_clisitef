import 'dart:async';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/core/exceptions/clisitef_error_codes.dart';
import 'package:agente_clisitef/src/core/utils/format_utils.dart';
import 'package:agente_clisitef/src/models/clisitef_response.dart';
import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';
import 'package:agente_clisitef/src/services/pinpad_service.dart';

/// Serviço para transações pendentes de confirmação
/// Permite iniciar uma transação e decidir posteriormente se confirmar ou cancelar
class CliSiTefServiceCapturaTardia {
  late final CliSiTefRepository _repository;
  late final CliSiTefCoreService _coreService;
  late final PinPadService _pinpadService;

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
    _pinpadService = PinPadService(
      repository: _repository,
      config: config,
    );
  }

  Future<void> _createSession() async {
    final sessionResponse = await _repository.createSession();

    if (!sessionResponse.isServiceSuccess) {
      throw CliSiTefException.fromCode(
        sessionResponse.clisitefStatus,
        details: 'Erro ao criar sessão: ${sessionResponse.errorMessage}',
        originalError: sessionResponse,
      );
    }

    _currentSessionId = sessionResponse.sessionId;
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
      await _createSession();
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
      await _createSession();
      final dataWithSessionId = TransactionData(
        functionId: data.functionId,
        trnAmount: data.trnAmount,
        taxInvoiceNumber: data.taxInvoiceNumber,
        taxInvoiceDate: data.taxInvoiceDate,
        taxInvoiceTime: data.taxInvoiceTime,
        cashierOperator: data.cashierOperator,
        trnAdditionalParameters: data.trnAdditionalParameters,
        trnInitParameters: data.trnInitParameters,
        sessionId: _currentSessionId,
      );
      // Usar o use case para processar a transação com seleção inteligente de PIX
      final useCase = StartTransactionUseCase(_repository, useSmartPixSelection: true);
      final result = await useCase.execute(
        data: dataWithSessionId,
        autoProcess: true,
        stopBeforeFinish: true,
        // Transação pendente para antes da finalização
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
  PinPadService get pinpadService => _pinpadService;

  /// Obtém a versão do SDK
  String get version => '1.0.0';

  /// Obtém o repositório (para controle manual do fluxo)
  CliSiTefRepository get repository => _repository;

  /// Obtém o serviço de PinPad (para operações avançadas)
  PinPadService get pinpadResetService => _pinpadService;

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

  /// Abre o PinPad (delegando para o PinPadService)
  Future<bool> openPinPad({String? sessionId}) async {
    try {
      if (!_isInitialized) {
        return false;
      }

      _pinpadService.setCurrentSession(sessionId ?? _currentSessionId);
      return await _pinpadService.openPinPad(sessionId: sessionId);
    } catch (e) {
      return false;
    }
  }

  /// Fecha o PinPad (delegando para o PinPadService)
  Future<bool> closePinPad({String? sessionId}) async {
    try {
      if (!_isInitialized) {
        return false;
      }

      _pinpadService.setCurrentSession(sessionId ?? _currentSessionId);
      return await _pinpadService.closePinPad(sessionId: sessionId);
    } catch (e) {
      return false;
    }
  }

  /// Verifica se o PinPad está presente (delegando para o PinPadService)
  Future<bool> isPinPadPresent({String? sessionId}) async {
    try {
      if (!_isInitialized) {
        return false;
      }

      _pinpadService.setCurrentSession(sessionId ?? _currentSessionId);
      return await _pinpadService.isPinPadPresent(sessionId: sessionId);
    } catch (e) {
      return false;
    }
  }

  /// Define mensagem no PinPad (delegando para o PinPadService)
  Future<bool> setPinPadMessage(String message, {String? sessionId}) async {
    try {
      if (!_isInitialized) {
        return false;
      }

      _pinpadService.setCurrentSession(sessionId ?? _currentSessionId);
      return await _pinpadService.setDisplayMessage(message, sessionId: sessionId);
    } catch (e) {
      return false;
    }
  }

  /// Inicializa o PinPad (delegando para o PinPadService)
  Future<bool> initializePinPad() async {
    try {
      if (!_isInitialized) {
        return false;
      }

      _pinpadService.setCurrentSession(_currentSessionId);
      return await _pinpadService.initialize();
    } catch (e) {
      return false;
    }
  }

  /// Verifica presença do PinPad (delegando para o PinPadService)
  Future<bool> checkPinPadPresence() async {
    try {
      if (!_isInitialized) {
        return false;
      }

      _pinpadService.setCurrentSession(_currentSessionId);
      return await _pinpadService.checkPresence();
    } catch (e) {
      return false;
    }
  }

  /// Define mensagem no PinPad com validação (delegando para o PinPadService)
  Future<int> setPinPadMessageValidated(String message) async {
    try {
      if (!_isInitialized) {
        return -1;
      }

      _pinpadService.setCurrentSession(_currentSessionId);
      return await _pinpadService.setMessage(message);
    } catch (e) {
      return -1;
    }
  }

  /// Limpa mensagem do PinPad (delegando para o PinPadService)
  Future<int> clearPinPadMessage() async {
    try {
      if (!_isInitialized) {
        return -1;
      }

      _pinpadService.setCurrentSession(_currentSessionId);
      return await _pinpadService.clearMessage();
    } catch (e) {
      return -1;
    }
  }

  /// Lê cartão de forma segura (delegando para o PinPadService)
  Future<CardReadResult> readCardSecure(String message) async {
    try {
      if (!_isInitialized) {
        return CardReadResult.error('Serviço não inicializado');
      }

      _pinpadService.setCurrentSession(_currentSessionId);
      return await _pinpadService.readCardSecure(message);
    } catch (e) {
      return CardReadResult.error('Erro ao ler cartão: $e');
    }
  }

  /// Lê cartão com chip (delegando para o PinPadService)
  Future<CardReadResult> readChipCard(String message, int modality) async {
    try {
      if (!_isInitialized) {
        return CardReadResult.error('Serviço não inicializado');
      }

      _pinpadService.setCurrentSession(_currentSessionId);
      return await _pinpadService.readChipCard(message, modality);
    } catch (e) {
      return CardReadResult.error('Erro ao ler cartão com chip: $e');
    }
  }

  /// Lê senha do cliente (delegando para o PinPadService)
  Future<PasswordReadResult> readPassword(String securityKey) async {
    try {
      if (!_isInitialized) {
        return PasswordReadResult.error('Serviço não inicializado');
      }

      _pinpadService.setCurrentSession(_currentSessionId);
      return await _pinpadService.readPassword(securityKey);
    } catch (e) {
      return PasswordReadResult.error('Erro ao ler senha: $e');
    }
  }

  /// Lê confirmação do cliente (delegando para o PinPadService)
  Future<bool?> readConfirmation(String message) async {
    try {
      if (!_isInitialized) {
        return null;
      }

      _pinpadService.setCurrentSession(_currentSessionId);
      return await _pinpadService.readConfirmation(message);
    } catch (e) {
      return null;
    }
  }

  /// Remove cartão do PinPad (delegando para o PinPadService)
  Future<bool> removeCard() async {
    try {
      if (!_isInitialized) {
        return false;
      }

      _pinpadService.setCurrentSession(_currentSessionId);
      return await _pinpadService.removeCard();
    } catch (e) {
      return false;
    }
  }

  /// Cancela uma operação em andamento (durante o fluxo interativo)
  ///
  /// Este método permite ao operador cancelar uma transação que está
  /// em progresso, deletando a sessão para quebrar qualquer loop
  Future<bool> cancelOperationInProgress({String? sessionId}) async {
    try {
      if (!_isInitialized) {
        throw CliSiTefException.serviceNotInitialized(
          details: 'Serviço não foi inicializado antes de cancelar operação',
        );
      }

      final currentSession = sessionId ?? _currentSessionId;
      if (currentSession == null) {
        throw CliSiTefException.internalError(
          details: 'Nenhuma sessão ativa para cancelar',
        );
      }

      // Tentar encerrar a sessão diretamente para quebrar qualquer loop
      try {
        await _repository.continueTransaction(command: 0, sessionId: currentSession, data: '', continueCode: -1);

        // Limpar estado local independentemente do resultado
        _currentSessionId = null;

        return true;
      } catch (e) {
        // Se falhar, pelo menos limpar o estado local
        _currentSessionId = null;
        return true; // Considerar sucesso pois limpou o estado local
      }
    } catch (e) {
      // Se já é uma CliSiTefException, rethrow
      if (e is CliSiTefException) {
        rethrow;
      }

      // Converter erro genérico para CliSiTefException
      throw CliSiTefException.internalError(
        details: 'Erro ao cancelar operação: $e',
        originalError: e,
      );
    }
  }

  /// Reseta o PinPad de acordo com o tipo especificado
  ///
  /// Delega a operação para o [PinPadService] especializado.
  /// Para mais detalhes sobre os tipos de reset, veja [PinPadResetType].
  Future<bool> resetPinPad({
    PinPadResetType resetType = PinPadResetType.limited,
    String? sessionId,
  }) async {
    try {
      if (!_isInitialized) {
        throw CliSiTefException.serviceNotInitialized(
          details: 'Serviço não foi inicializado antes de resetar PinPad',
        );
      }

      // Sincronizar a sessão atual com o PinPadService
      _pinpadService.setCurrentSession(sessionId ?? _currentSessionId);

      // Delegar a operação para o PinPadService
      final result = await _pinpadService.resetPinPad(
        resetType: resetType,
        sessionId: sessionId,
      );

      // Sincronizar de volta a sessão se foi alterada
      final newSessionId = _pinpadService.currentSessionId;
      if (newSessionId != null && newSessionId != _currentSessionId) {
        _currentSessionId = newSessionId;
      }

      return result;
    } catch (e) {
      // Se já é uma CliSiTefException, rethrow
      if (e is CliSiTefException) {
        rethrow;
      }

      // Converter erro genérico para CliSiTefException
      throw CliSiTefException.internalError(
        details: 'Erro ao resetar PinPad (${resetType.displayName}): $e',
        originalError: e,
      );
    }
  }

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
