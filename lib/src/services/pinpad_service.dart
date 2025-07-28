import 'dart:async';
import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';
import 'package:agente_clisitef/src/core/exceptions/clisitef_exception.dart';
import 'package:agente_clisitef/src/repositories/clisitef_repository.dart';
import 'package:agente_clisitef/src/models/clisitef_config.dart';
import 'package:agente_clisitef/src/core/services/message_manager.dart';

/// Resultado da leitura de cartão
class CardReadResult {
  final bool isSuccess;
  final String? cardData;
  final String? errorMessage;

  const CardReadResult({
    required this.isSuccess,
    this.cardData,
    this.errorMessage,
  });

  factory CardReadResult.success(String cardData) {
    return CardReadResult(
      isSuccess: true,
      cardData: cardData,
    );
  }

  factory CardReadResult.error(String errorMessage) {
    return CardReadResult(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}

/// Resultado da leitura de senha
class PasswordReadResult {
  final bool isSuccess;
  final String? password;
  final String? errorMessage;

  const PasswordReadResult({
    required this.isSuccess,
    this.password,
    this.errorMessage,
  });

  factory PasswordReadResult.success(String password) {
    return PasswordReadResult(
      isSuccess: true,
      password: password,
    );
  }

  factory PasswordReadResult.error(String errorMessage) {
    return PasswordReadResult(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}

/// Serviço dedicado às operações de PinPad
///
/// Este serviço centraliza todas as operações relacionadas ao PinPad,
/// incluindo diferentes tipos de reset e verificações de estado.
class PinPadService {
  final CliSiTefRepository _repository;
  final CliSiTefConfig _config;
  final AgenteClisitefMessageManager _messageManager = AgenteClisitefMessageManager.instance;

  String? _currentSessionId;
  bool _isInitialized = false;
  bool _isPinPadPresent = false;
  String _currentMessage = '';

  PinPadService({
    required CliSiTefRepository repository,
    required CliSiTefConfig config,
  })  : _repository = repository,
        _config = config;

  /// Define a sessão atual para operações
  void setCurrentSession(String? sessionId) {
    _currentSessionId = sessionId;
  }

  /// Inicializa o serviço PinPad
  Future<bool> initialize() async {
    try {
      _messageManager.messageCashier.value = 'Inicializando PinPad...';

      if (!_repository.isInitialized) {
        _messageManager.processError(errorMessage: 'Repositório não inicializado');
        return false;
      }

      // Verificar presença do PinPad
      _isPinPadPresent = await _repository.checkPinPadPresence();

      if (_isPinPadPresent) {
        _messageManager.messageCashier.value = '✅ PinPad detectado';

        // Definir mensagem padrão
        await setMessage('Aguardando cartão...');

        _isInitialized = true;
        _messageManager.messageCashier.value = '✅ PinPad inicializado com sucesso';
        return true;
      } else {
        _messageManager.processError(errorMessage: 'PinPad não detectado');
        return false;
      }
    } catch (e) {
      _messageManager.processError(errorMessage: 'Erro ao inicializar PinPad: $e');
      return false;
    }
  }

  /// Verifica a presença do PinPad
  Future<bool> checkPresence() async {
    try {
      if (!_repository.isInitialized) {
        return false;
      }

      _isPinPadPresent = await _repository.checkPinPadPresence();
      return _isPinPadPresent;
    } catch (e) {
      return false;
    }
  }

  /// Define mensagem permanente no PinPad
  Future<int> setMessage(String message) async {
    try {
      if (!_repository.isInitialized) {
        _messageManager.processError(errorMessage: 'Repositório não inicializado');
        return -1;
      }

      if (message.length > 40) {
        _messageManager.processError(errorMessage: 'Mensagem muito longa para o PinPad');
        return -1;
      }

      _messageManager.messageOperator.value = message;
      final result = await _repository.setPinPadMessage(message);

      if (result == 0) {
        _currentMessage = message;
        _messageManager.messageCashier.value = '✅ Mensagem definida no PinPad';
      } else {
        _messageManager.processError(errorMessage: 'Erro ao definir mensagem: $result');
      }

      return result;
    } catch (e) {
      _messageManager.processError(errorMessage: 'Erro ao definir mensagem: $e');
      return -1;
    }
  }

  /// Limpa a mensagem do PinPad
  Future<int> clearMessage() async {
    return await setMessage('');
  }

  /// Lê cartão de forma segura
  Future<CardReadResult> readCardSecure(String message) async {
    try {
      if (!_repository.isInitialized) {
        return CardReadResult.error('Repositório não inicializado');
      }

      // Definir mensagem no PinPad
      await setMessage(message);

      // Aguardar inserção do cartão
      final cardData = await _waitForCardInsertion();

      if (cardData != null) {
        return CardReadResult.success(cardData);
      } else {
        return CardReadResult.error('Dados do cartão não encontrados');
      }
    } catch (e) {
      return CardReadResult.error('Erro interno: $e');
    }
  }

  /// Lê cartão com chip
  Future<CardReadResult> readChipCard(String message, int modality) async {
    try {
      if (!_repository.isInitialized) {
        return CardReadResult.error('Repositório não inicializado');
      }

      // Definir mensagem no PinPad
      await setMessage(message);

      // Aguardar inserção do cartão com chip
      final cardData = await _waitForChipCardInsertion(modality);

      if (cardData != null) {
        return CardReadResult.success(cardData);
      } else {
        return CardReadResult.error('Dados do cartão com chip não encontrados');
      }
    } catch (e) {
      return CardReadResult.error('Erro interno: $e');
    }
  }

  /// Lê senha do cliente
  Future<PasswordReadResult> readPassword(String securityKey) async {
    try {
      if (!_repository.isInitialized) {
        return PasswordReadResult.error('Repositório não inicializado');
      }

      // Definir mensagem no PinPad
      await setMessage('Digite sua senha');

      // Aguardar digitação da senha
      final password = await _waitForPasswordInput(securityKey);

      if (password != null) {
        return PasswordReadResult.success(password);
      } else {
        return PasswordReadResult.error('Senha não encontrada');
      }
    } catch (e) {
      return PasswordReadResult.error('Erro interno: $e');
    }
  }

  /// Lê confirmação do cliente no PinPad
  Future<bool?> readConfirmation(String message) async {
    try {
      if (!_repository.isInitialized) {
        return null;
      }

      // Definir mensagem no PinPad
      await setMessage(message);

      // Aguardar confirmação
      final confirmation = await _waitForConfirmation();

      return confirmation;
    } catch (e) {
      return null;
    }
  }

  /// Remove cartão inserido no PinPad
  Future<bool> removeCard() async {
    try {
      if (!_repository.isInitialized) {
        return false;
      }

      // Definir mensagem no PinPad
      await setMessage('Remova o cartão');

      // Aguardar remoção do cartão
      final removed = await _waitForCardRemoval();

      if (removed) {
        await setMessage('Aguardando cartão...');
      }

      return removed;
    } catch (e) {
      return false;
    }
  }

  /// Reseta o PinPad de acordo com o tipo especificado
  ///
  /// Diferentes tipos de reset estão disponíveis através do enum [PinPadResetType]:
  /// - [PinPadResetType.basic]: Reset padrão (fecha, remove cartão, reabre)
  /// - [PinPadResetType.complete]: Reset completo (básico + limpa sessão)
  /// - [PinPadResetType.communication]: Apenas comunicação (fecha/reabre)
  /// - [PinPadResetType.state]: Limpa estados e transações pendentes
  /// - [PinPadResetType.emergency]: Reset forçado ignorando erros
  /// - [PinPadResetType.soft]: Reset suave (remove cartão + mensagem)
  /// - [PinPadResetType.limited]: Apenas operações funcionais no servidor
  Future<bool> resetPinPad({
    PinPadResetType resetType = PinPadResetType.limited,
    String? sessionId,
  }) async {
    try {
      switch (resetType) {
        case PinPadResetType.basic:
          return await _performBasicReset(sessionId);
        case PinPadResetType.complete:
          return await _performCompleteReset(sessionId);
        case PinPadResetType.communication:
          return await _performCommunicationReset(sessionId);
        case PinPadResetType.state:
          return await _performStateReset(sessionId);
        case PinPadResetType.emergency:
          return await _performEmergencyReset(sessionId);
        case PinPadResetType.soft:
          return await _performSoftReset(sessionId);
        case PinPadResetType.limited:
          return await _performLimitedReset(sessionId);
      }
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

  /// Reset básico: fecha comunicação, remove cartão e reabre
  Future<bool> _performBasicReset(String? sessionId) async {
    final activeSessionId = await _ensureActiveSession(sessionId);
    if (activeSessionId == null) return false;

    bool resetSuccess = false;

    try {
      // 1. Fechar comunicação
      await _closePinPadSafely(activeSessionId);

      // 2. Remover cartão
      await _removeCardSafely(activeSessionId);

      // 3. Reabrir comunicação
      resetSuccess = await _openPinPadWithRetry(activeSessionId);

      // 4. Definir mensagem padrão
      if (resetSuccess) {
        await _setDefaultMessage(activeSessionId);
      }

      return resetSuccess;
    } catch (e) {
      return false;
    }
  }

  /// Reset completo: básico + limpa sessão
  Future<bool> _performCompleteReset(String? sessionId) async {
    try {
      // Executar reset básico primeiro
      final basicSuccess = await _performBasicReset(sessionId);

      // Limpar sessão atual e criar nova
      try {
        await _repository.deleteSession();
      } catch (e) {
        // Ignorar erro de delete
      }

      _currentSessionId = null;
      await _createSession();

      return basicSuccess && _currentSessionId != null;
    } catch (e) {
      return false;
    }
  }

  /// Reset de comunicação: apenas fecha e reabre
  Future<bool> _performCommunicationReset(String? sessionId) async {
    final activeSessionId = await _ensureActiveSession(sessionId);
    if (activeSessionId == null) return false;

    try {
      // Fechar comunicação
      await _closePinPadSafely(activeSessionId);

      // Aguardar um pouco
      await Future.delayed(const Duration(milliseconds: 300));

      // Reabrir comunicação
      return await _openPinPadWithRetry(activeSessionId);
    } catch (e) {
      return false;
    }
  }

  /// Reset de estado: limpa transações e estados pendentes
  Future<bool> _performStateReset(String? sessionId) async {
    try {
      // Cancelar qualquer transação em andamento
      try {
        await _cancelOperationInProgress(sessionId: sessionId);
      } catch (e) {
        // Ignorar erro
      }

      // Limpar estado local
      _currentSessionId = null;

      // Criar nova sessão
      await _createSession();

      return _currentSessionId != null;
    } catch (e) {
      return false;
    }
  }

  /// Reset de emergência: força reset ignorando erros
  Future<bool> _performEmergencyReset(String? sessionId) async {
    bool anySuccess = false;

    try {
      // Tentar todas as operações, ignorando erros
      final activeSessionId = sessionId ?? _currentSessionId;

      if (activeSessionId != null) {
        // Tentar fechar comunicação
        try {
          await _repository.closePinPad(sessionId: activeSessionId);
          anySuccess = true;
        } catch (e) {
          // Ignorar
        }

        // Tentar remover cartão
        try {
          await _repository.removePinPadCard(sessionId: activeSessionId);
          anySuccess = true;
        } catch (e) {
          // Ignorar
        }

        // Tentar cancelar transação
        try {
          await _repository.continueTransaction(
            command: 0,
            sessionId: activeSessionId,
            data: '',
            continueCode: -1,
          );
          anySuccess = true;
        } catch (e) {
          // Ignorar
        }
      }

      // Forçar limpeza de estado
      _currentSessionId = null;

      // Tentar criar nova sessão
      try {
        await _createSession();
        if (_currentSessionId != null) {
          anySuccess = true;

          // Tentar abrir PinPad na nova sessão
          try {
            await _repository.openPinPad(sessionId: _currentSessionId!);
          } catch (e) {
            // Ignorar
          }
        }
      } catch (e) {
        // Ignorar
      }

      return anySuccess;
    } catch (e) {
      return anySuccess;
    }
  }

  /// Reset suave: apenas remove cartão e define mensagem
  Future<bool> _performSoftReset(String? sessionId) async {
    final activeSessionId = await _ensureActiveSession(sessionId);
    if (activeSessionId == null) return false;

    try {
      bool success = false;

      // Remover cartão
      try {
        final removeResponse = await _repository.removePinPadCard(sessionId: activeSessionId);
        if (removeResponse.isServiceSuccess) {
          success = true;
        }
      } catch (e) {
        // Tentar continuar mesmo com erro
      }

      // Definir mensagem padrão
      try {
        await _repository.setPinPadDisplayMessage(
          sessionId: activeSessionId,
          displayMessage: 'AGUARDANDO...',
        );
        success = true;
      } catch (e) {
        // Ignorar erro de mensagem
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  /// Reset limitado: apenas operações que funcionam no servidor atual
  Future<bool> _performLimitedReset(String? sessionId) async {
    bool anySuccess = false;

    try {
      // Operação 1: Tentar cancelar qualquer operação em andamento
      try {
        final currentSession = sessionId ?? _currentSessionId;
        if (currentSession != null) {
          await _repository.continueTransaction(
            command: 0,
            sessionId: currentSession,
            data: '',
            continueCode: -1,
          );
          anySuccess = true;
        }
      } catch (e) {
        // Ignorar erro - pode não ter operação para cancelar
      }

      // Operação 2: Limpar estado local
      _currentSessionId = null;

      // Operação 3: Criar nova sessão (operação básica que sempre funciona)
      try {
        await _createSession();
        if (_currentSessionId != null) {
          anySuccess = true;

          // Operação 4: Tentar fechar PinPad na nova sessão (se falhar, ignore)
          try {
            await _repository.closePinPad(sessionId: _currentSessionId!);
          } catch (e) {
            // Ignorar - pode não estar aberto
          }

          // Operação 5: Definir mensagem padrão (operação simples)
          try {
            await _repository.setPinPadDisplayMessage(
              sessionId: _currentSessionId!,
              displayMessage: 'PRONTO',
            );
            anySuccess = true;
          } catch (e) {
            // Ignorar - nem todos os servidores implementam
          }
        }
      } catch (e) {
        // Se falhar em criar sessão, pelo menos limpou o estado
      }

      return anySuccess;
    } catch (e) {
      return anySuccess;
    }
  }

  /// Abre o PinPad
  Future<bool> openPinPad({String? sessionId}) async {
    try {
      final activeSessionId = sessionId ?? _currentSessionId;
      if (activeSessionId == null) return false;

      final response = await _repository.openPinPad(sessionId: activeSessionId);
      return response.isServiceSuccess;
    } catch (e) {
      return false;
    }
  }

  /// Fecha o PinPad
  Future<bool> closePinPad({String? sessionId}) async {
    try {
      final activeSessionId = sessionId ?? _currentSessionId;
      if (activeSessionId == null) return false;

      final response = await _repository.closePinPad(sessionId: activeSessionId);
      return response.isServiceSuccess;
    } catch (e) {
      return false;
    }
  }

  /// Verifica se o PinPad está presente
  Future<bool> isPinPadPresent({String? sessionId}) async {
    try {
      final activeSessionId = sessionId ?? _currentSessionId;
      if (activeSessionId == null) return false;

      final response = await _repository.isPinPadPresent(sessionId: activeSessionId);
      return response.isServiceSuccess;
    } catch (e) {
      return false;
    }
  }

  /// Define mensagem no PinPad
  Future<bool> setDisplayMessage(String message, {String? sessionId}) async {
    try {
      final activeSessionId = sessionId ?? _currentSessionId;
      if (activeSessionId == null) return false;

      final response = await _repository.setPinPadDisplayMessage(
        sessionId: activeSessionId,
        displayMessage: message,
      );
      return response.isServiceSuccess;
    } catch (e) {
      return false;
    }
  }

  /// Cancela uma operação em andamento
  Future<bool> _cancelOperationInProgress({String? sessionId}) async {
    try {
      final currentSession = sessionId ?? _currentSessionId;
      if (currentSession == null) return false;

      await _repository.continueTransaction(
        command: 0,
        sessionId: currentSession,
        data: '',
        continueCode: -1,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Métodos auxiliares para reset

  Future<String?> _ensureActiveSession(String? sessionId) async {
    final currentSession = sessionId ?? _currentSessionId;
    if (currentSession == null) {
      try {
        await _createSession();
        return _currentSessionId;
      } catch (e) {
        return null;
      }
    }
    return currentSession;
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

  Future<void> _closePinPadSafely(String sessionId) async {
    try {
      await _repository.closePinPad(sessionId: sessionId);
    } catch (e) {
      // Ignorar erros de fechamento
    }
  }

  Future<void> _removeCardSafely(String sessionId) async {
    try {
      // Primeiro verificar se o endpoint está disponível
      final isAvailable = await _repository.isRemoveCardEndpointAvailable();
      if (!isAvailable) {
        // Endpoint não disponível, pular remoção
        return;
      }

      await _repository.removePinPadCard(sessionId: sessionId);
    } catch (e) {
      // Ignorar erros de remoção - endpoint pode não estar implementado
    }
  }

  Future<bool> _openPinPadWithRetry(String sessionId) async {
    try {
      final openResponse = await _repository.openPinPad(sessionId: sessionId);
      if (openResponse.isServiceSuccess) {
        return true;
      }
    } catch (e) {
      // Tentar novamente após pausa
      await Future.delayed(const Duration(milliseconds: 500));

      try {
        final retryResponse = await _repository.openPinPad(sessionId: sessionId);
        return retryResponse.isServiceSuccess;
      } catch (retryError) {
        return false;
      }
    }
    return false;
  }

  Future<void> _setDefaultMessage(String sessionId) async {
    try {
      await _repository.setPinPadDisplayMessage(
        sessionId: sessionId,
        displayMessage: 'AGUARDANDO...',
      );
    } catch (e) {
      // Ignorar erro de mensagem
    }
  }

  /// Obtém a sessão atual
  String? get currentSessionId => _currentSessionId;

  /// Verifica se há uma sessão ativa
  bool get hasActiveSession => _currentSessionId != null;

  /// Verifica se o serviço está inicializado
  bool get isInitialized => _isInitialized;

  /// Verifica se o PinPad está presente (estado interno)
  bool get pinPadDetected => _isPinPadPresent;

  /// Obtém a mensagem atual do PinPad
  String get currentMessage => _currentMessage;

  /// Obtém o MessageManager
  AgenteClisitefMessageManager get messageManager => _messageManager;

  // Métodos auxiliares para aguardar eventos do PinPad
  Future<String?> _waitForCardInsertion() async {
    // TODO: Implementar aguardo de inserção de cartão
    return null;
  }

  Future<String?> _waitForChipCardInsertion(int modality) async {
    // TODO: Implementar aguardo de inserção de cartão com chip
    return null;
  }

  Future<String?> _waitForPasswordInput(String securityKey) async {
    // TODO: Implementar aguardo de digitação de senha
    return null;
  }

  Future<bool?> _waitForConfirmation() async {
    // TODO: Implementar aguardo de confirmação
    return null;
  }

  Future<bool> _waitForCardRemoval() async {
    // TODO: Implementar aguardo de remoção de cartão
    return false;
  }
}
