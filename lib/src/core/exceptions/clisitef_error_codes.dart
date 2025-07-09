/// Enum que representa os códigos de erro do CliSiTef
enum CliSiTefErrorCode {
  // Códigos de cancelamento específicos
  operatorCancelled(-2, 'Operador cancelou a operação'),
  userCancelled(-6, 'Usuário cancelou a operação no pinpad'),
  automationCancelled(-15, 'Sistema cancelou automaticamente a operação'),

  // Códigos de erro gerais
  serviceNotInitialized(-1, 'Serviço não inicializado'),
  invalidConfiguration(-3, 'Configuração inválida'),
  connectionError(-4, 'Erro de conexão com o servidor'),
  timeoutError(-5, 'Timeout na operação'),
  invalidData(-7, 'Dados inválidos'),
  serverError(-8, 'Erro no servidor'),
  transactionNotFound(-9, 'Transação não encontrada'),
  sessionExpired(-10, 'Sessão expirada'),
  invalidSession(-11, 'Sessão inválida'),
  operationNotAllowed(-12, 'Operação não permitida'),
  deviceNotAvailable(-13, 'Dispositivo não disponível'),
  communicationError(-14, 'Erro de comunicação'),
  internalError(-16, 'Erro interno do sistema'),
  unknownError(-99, 'Erro desconhecido');

  const CliSiTefErrorCode(this.code, this.description);

  /// Código numérico do erro
  final int code;

  /// Descrição legível do erro
  final String description;

  /// Verifica se é um código de cancelamento
  bool get isCancellation {
    return this == CliSiTefErrorCode.operatorCancelled || this == CliSiTefErrorCode.userCancelled || this == CliSiTefErrorCode.automationCancelled;
  }

  /// Obtém o enum pelo código numérico
  static CliSiTefErrorCode fromCode(int code) {
    for (final errorCode in CliSiTefErrorCode.values) {
      if (errorCode.code == code) {
        return errorCode;
      }
    }
    return CliSiTefErrorCode.unknownError;
  }

  /// Obtém o enum pelo código numérico ou retorna null se não encontrado
  static CliSiTefErrorCode? tryFromCode(int code) {
    for (final errorCode in CliSiTefErrorCode.values) {
      if (errorCode.code == code) {
        return errorCode;
      }
    }
    return null;
  }

  /// Lista de códigos de cancelamento
  static const List<CliSiTefErrorCode> cancellationCodes = [
    CliSiTefErrorCode.operatorCancelled,
    CliSiTefErrorCode.userCancelled,
    CliSiTefErrorCode.automationCancelled,
  ];

  /// Verifica se um código é de cancelamento
  static bool isCancellationCode(int code) {
    return cancellationCodes.any((errorCode) => errorCode.code == code);
  }

  @override
  String toString() {
    return 'CliSiTefErrorCode.$name(code: $code, description: "$description")';
  }
}
