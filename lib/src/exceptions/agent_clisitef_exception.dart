/// Exceção específica para erros do Agente CliSiTef
class AgentClisitefException implements Exception {
  final String message;
  final String? code;
  final String? category;
  final dynamic originalError;

  AgentClisitefException({
    required this.message,
    this.code,
    this.category,
    this.originalError,
  });

  @override
  String toString() {
    final buffer = StringBuffer('AgentClisitefException: $message');
    if (code != null) buffer.write(' (Código: $code)');
    if (category != null) buffer.write(' (Categoria: $category)');
    if (originalError != null) buffer.write(' (Erro original: $originalError)');
    return buffer.toString();
  }

  /// Cria uma exceção para erro de comunicação
  factory AgentClisitefException.communicationError(String message, [dynamic originalError]) {
    return AgentClisitefException(
      message: message,
      category: 'comunicacao',
      originalError: originalError,
    );
  }

  /// Cria uma exceção para erro de transação
  factory AgentClisitefException.transactionError(String message, [dynamic originalError]) {
    return AgentClisitefException(
      message: message,
      category: 'transacao',
      originalError: originalError,
    );
  }

  /// Cria uma exceção para erro de cartão
  factory AgentClisitefException.cardError(String message, [dynamic originalError]) {
    return AgentClisitefException(
      message: message,
      category: 'cartao',
      originalError: originalError,
    );
  }

  /// Cria uma exceção para erro de configuração
  factory AgentClisitefException.configurationError(String message, [dynamic originalError]) {
    return AgentClisitefException(
      message: message,
      category: 'configuracao',
      originalError: originalError,
    );
  }

  /// Cria uma exceção para erro interno do sistema
  factory AgentClisitefException.internalError(String message, [dynamic originalError]) {
    return AgentClisitefException(
      message: message,
      category: 'interno',
      originalError: originalError,
    );
  }

  /// Cria uma exceção para erro inesperado
  factory AgentClisitefException.unexpectedError(String message, [dynamic originalError]) {
    return AgentClisitefException(
      message: message,
      category: 'inesperado',
      originalError: originalError,
    );
  }
}
