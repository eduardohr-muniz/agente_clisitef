/// Classe responsável por mapear e tratar erros do CliSiTef
class ErrorMapper {
  static const Map<String, String> _errorCodes = {
    'ERRO-1': 'Erro interno do sistema',
    'ERRO-2': 'Erro de comunicação',
    'ERRO-3': 'Erro de transação',
    'ERRO-4': 'Erro de cartão',
    'ERRO-5': 'Erro de configuração',
    'ERRO-6': 'Erro de operadora',
  };

  static const Map<String, Map<String, String>> _errorMessages = {
    'cartao': {
      'CARTAO INVALIDO': 'Cartão inválido',
      'CARTAO BLOQUEADO': 'Cartão bloqueado',
      'CARTAO VENCIDO': 'Cartão vencido',
      'CARTAO NAO PERMITIDO': 'Cartão não permitido',
    },
    'transacao': {
      'TRANSACAO NAO AUTORIZADA': 'Transação não autorizada',
      'TRANSACAO CANCELADA': 'Transação cancelada',
      'TRANSACAO RECUSADA': 'Transação recusada',
      'TRANSACAO INVALIDA': 'Transação inválida',
    },
    'conexao': {
      'ERRO DE COMUNICACAO': 'Erro de comunicação',
      'SEM CONEXAO': 'Sem conexão',
      'TIMEOUT': 'Tempo limite excedido',
      'DISPOSITIVO NAO ENCONTRADO': 'Dispositivo não encontrado',
    },
    'configuracao': {
      'CONFIGURACAO INVALIDA': 'Configuração inválida',
      'PARAMETROS INVALIDOS': 'Parâmetros inválidos',
      'ARQUIVO NAO ENCONTRADO': 'Arquivo não encontrado',
      'PERMISSAO NEGADA': 'Permissão negada',
    },
    'generico': {
      'ERRO': 'Erro genérico',
      'FALHA': 'Falha no sistema',
      'INVALIDO': 'Operação inválida',
      'NAO AUTORIZADO': 'Operação não autorizada',
    },
  };

  static const Map<int, String> _statusMessages = {
    0: 'Operação realizada com sucesso',
    1: 'Erro de comunicação',
    2: 'Erro de timeout',
    3: 'Erro de transação',
    4: 'Erro de cartão',
    5: 'Erro de configuração',
    6: 'Erro de parâmetros',
    7: 'Erro de cartão bloqueado',
    8: 'Erro de cartão vencido',
    9: 'Erro de operadora',
  };

  /// Obtém uma mensagem de erro amigável baseada na mensagem recebida
  static String getErrorMessage(String message) {
    // Verifica se a mensagem contém um código de erro conhecido
    for (var code in _errorCodes.keys) {
      if (message.contains(code)) {
        return _errorCodes[code] ?? 'Erro desconhecido';
      }
    }

    // Verifica se a mensagem contém um erro conhecido
    for (var category in _errorMessages.keys) {
      for (var error in _errorMessages[category]!.keys) {
        if (message.toUpperCase().contains(error)) {
          return _errorMessages[category]![error]!;
        }
      }
    }

    return 'Ocorreu um erro. Por favor, tente novamente.';
  }

  /// Obtém uma mensagem amigável para um código de status
  static String getStatusMessage(int statusCode) {
    return _statusMessages[statusCode] ?? 'Status desconhecido';
  }

  /// Verifica se a mensagem contém um erro conhecido
  static bool hasKnownError(String message) {
    // Verifica códigos de erro
    for (var code in _errorCodes.keys) {
      if (message.contains(code)) {
        return true;
      }
    }

    // Verifica mensagens de erro
    for (var category in _errorMessages.keys) {
      for (var error in _errorMessages[category]!.keys) {
        if (message.toUpperCase().contains(error)) {
          return true;
        }
      }
    }

    return false;
  }

  /// Identifica a categoria do erro baseado na mensagem
  static String getErrorCategory(String message) {
    for (var category in _errorMessages.keys) {
      for (var error in _errorMessages[category]!.keys) {
        if (message.toUpperCase().contains(error)) {
          return category;
        }
      }
    }
    return 'generico';
  }

  /// Verifica se um status indica erro
  static bool isErrorStatus(int statusCode) {
    return statusCode != 0;
  }

  /// Obtém o tipo de erro baseado no status
  static String getErrorType(int statusCode) {
    if (statusCode >= 1 && statusCode <= 2) return 'conexao';
    if (statusCode >= 3 && statusCode <= 4) return 'transacao';
    if (statusCode >= 5 && statusCode <= 6) return 'configuracao';
    if (statusCode >= 7 && statusCode <= 9) return 'cartao';
    return 'generico';
  }

  /// Obtém o código de erro da mensagem
  static String? getErrorCode(String message) {
    for (var code in _errorCodes.keys) {
      if (message.contains(code)) {
        return code;
      }
    }
    return null;
  }

  /// Verifica se é um erro interno do sistema
  static bool isInternalError(String message) {
    final internalErrorPatterns = [
      'ERRO INTERNO',
      'ERRO DE SISTEMA',
      'ERRO DE PROCESSAMENTO',
      'ERRO DE MEMÓRIA',
      'ERRO DE ARQUIVO',
      'ERRO DE PERMISSÃO',
      'ERRO DE DISPOSITIVO',
      'ERRO DE TIMEOUT',
    ];

    return internalErrorPatterns.any((pattern) => message.toUpperCase().contains(pattern));
  }

  /// Obtém uma mensagem de erro interno amigável
  static String getInternalErrorMessage(String message) {
    if (isInternalError(message)) {
      return 'Ocorreu um erro interno no sistema. Por favor, tente novamente mais tarde.';
    }
    return getErrorMessage(message);
  }
}
