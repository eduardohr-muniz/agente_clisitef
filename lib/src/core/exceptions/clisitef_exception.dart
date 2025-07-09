import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';
import 'clisitef_error_codes.dart';

/// Exceção customizada para erros do CliSiTef
class CliSiTefException implements Exception {
  final CliSiTefErrorCode errorCode;
  final String message;
  final String? details;
  final dynamic originalError;

  const CliSiTefException({
    required this.errorCode,
    required this.message,
    this.details,
    this.originalError,
  });

  /// Cria uma exceção de cancelamento pelo operador
  factory CliSiTefException.operatorCancelled({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.operatorCancelled,
      message: CliSiTefErrorCode.operatorCancelled.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de cancelamento pelo usuário
  factory CliSiTefException.userCancelled({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.userCancelled,
      message: CliSiTefErrorCode.userCancelled.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de cancelamento pela automação
  factory CliSiTefException.automationCancelled({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.automationCancelled,
      message: CliSiTefErrorCode.automationCancelled.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de serviço não inicializado
  factory CliSiTefException.serviceNotInitialized({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.serviceNotInitialized,
      message: CliSiTefErrorCode.serviceNotInitialized.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de configuração inválida
  factory CliSiTefException.invalidConfiguration({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.invalidConfiguration,
      message: CliSiTefErrorCode.invalidConfiguration.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de erro de conexão
  factory CliSiTefException.connectionError({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.connectionError,
      message: CliSiTefErrorCode.connectionError.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de timeout
  factory CliSiTefException.timeoutError({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.timeoutError,
      message: CliSiTefErrorCode.timeoutError.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de dados inválidos
  factory CliSiTefException.invalidData({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.invalidData,
      message: CliSiTefErrorCode.invalidData.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de erro no servidor
  factory CliSiTefException.serverError({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.serverError,
      message: CliSiTefErrorCode.serverError.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de transação não encontrada
  factory CliSiTefException.transactionNotFound({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.transactionNotFound,
      message: CliSiTefErrorCode.transactionNotFound.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de sessão expirada
  factory CliSiTefException.sessionExpired({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.sessionExpired,
      message: CliSiTefErrorCode.sessionExpired.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de sessão inválida
  factory CliSiTefException.invalidSession({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.invalidSession,
      message: CliSiTefErrorCode.invalidSession.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de operação não permitida
  factory CliSiTefException.operationNotAllowed({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.operationNotAllowed,
      message: CliSiTefErrorCode.operationNotAllowed.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de dispositivo não disponível
  factory CliSiTefException.deviceNotAvailable({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.deviceNotAvailable,
      message: CliSiTefErrorCode.deviceNotAvailable.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de erro de comunicação
  factory CliSiTefException.communicationError({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.communicationError,
      message: CliSiTefErrorCode.communicationError.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção de erro interno
  factory CliSiTefException.internalError({
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: CliSiTefErrorCode.internalError,
      message: CliSiTefErrorCode.internalError.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção a partir de um código de erro
  factory CliSiTefException.fromCode(
    int code, {
    String? customMessage,
    String? details,
    dynamic originalError,
  }) {
    final errorCode = CliSiTefErrorCode.fromCode(code);
    return CliSiTefException(
      errorCode: errorCode,
      message: customMessage ?? errorCode.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Cria uma exceção a partir de um enum de erro
  factory CliSiTefException.fromErrorCode(
    CliSiTefErrorCode errorCode, {
    String? customMessage,
    String? details,
    dynamic originalError,
  }) {
    return CliSiTefException(
      errorCode: errorCode,
      message: customMessage ?? errorCode.description,
      details: details,
      originalError: originalError,
    );
  }

  /// Verifica se é um cancelamento
  bool get isCancellation => errorCode.isCancellation;

  /// Verifica se é cancelamento pelo operador
  bool get isOperatorCancellation => errorCode == CliSiTefErrorCode.operatorCancelled;

  /// Verifica se é cancelamento pelo usuário
  bool get isUserCancellation => errorCode == CliSiTefErrorCode.userCancelled;

  /// Verifica se é cancelamento pela automação
  bool get isAutomationCancellation => errorCode == CliSiTefErrorCode.automationCancelled;

  /// Obtém o código numérico do erro
  int get code => errorCode.code;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('CliSiTefException(');
    buffer.write('errorCode: $errorCode, ');
    buffer.write('message: "$message"');

    if (details != null) {
      buffer.write(', details: "$details"');
    }

    if (originalError != null) {
      buffer.write(', originalError: $originalError');
    }

    buffer.write(')');
    return buffer.toString();
  }
}
