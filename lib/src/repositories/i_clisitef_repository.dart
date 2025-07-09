/// Interface do repositório CliSiTef
abstract class ICliSiTefRepository {
  /// Configura o CliSiTef interativo
  Future<int> configureInteractive({
    required String siTefIP,
    required String storeId,
    required String terminalId,
    String reserved = '0',
    Map<String, String> additionalParameters = const {},
  });

  /// Inicia uma função SiTef interativa
  Future<int> startInteractiveFunction({
    required int functionCode,
    required String amount,
    required String fiscalCupon,
    required String fiscalDate,
    required String fiscalTime,
    required String operator,
    Map<String, String>? additionalParameters,
  });

  /// Continua uma função SiTef interativa
  Future<ContinueTransactionResponse> continueInteractiveFunction({
    required String data,
    required int continueValue,
  });

  /// Finaliza uma função SiTef interativa
  Future<int> finishInteractiveFunction({
    required bool confirmTransaction,
  });

  /// Cria uma sessão
  Future<String?> createSession();

  /// Cancela uma transação
  Future<int> cancelTransaction({
    required String sessionId,
  });

  /// Inicia uma pré-autorização
  Future<int> startPreAuthorization({
    required String amount,
    required String fiscalCupon,
    required String fiscalDate,
    required String fiscalTime,
    required String operator,
    Map<String, String>? additionalParameters,
  });

  /// Cancela uma pré-autorização
  Future<int> cancelPreAuthorization({
    required String preAuthId,
  });
}

/// Resposta de continuação de transação
class ContinueTransactionResponse {
  final int serviceStatus;
  final int commandId;
  final int fieldType;
  final int minSize;
  final int maxSize;
  final String buffer;
  final int bufferSize;

  const ContinueTransactionResponse({
    required this.serviceStatus,
    required this.commandId,
    required this.fieldType,
    required this.minSize,
    required this.maxSize,
    required this.buffer,
    required this.bufferSize,
  });
}
