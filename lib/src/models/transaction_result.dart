import 'package:agente_clisitef/src/models/transaction_response.dart';

/// Resultado de uma transação
class TransactionResult {
  /// Indica se a transação foi bem-sucedida
  final bool isSuccess;

  /// Código de retorno
  final int statusCode;

  /// Mensagem de retorno
  final String message;

  /// Dados da resposta
  final TransactionResponse? response;

  /// Dados adicionais
  final Map<String, dynamic> additionalData;

  const TransactionResult({
    required this.isSuccess,
    required this.statusCode,
    required this.message,
    this.response,
    this.additionalData = const {},
  });

  /// Construtor para sucesso
  factory TransactionResult.success({
    required int statusCode,
    String? message,
    TransactionResponse? response,
    Map<String, dynamic>? additionalData,
  }) {
    return TransactionResult(
      isSuccess: true,
      statusCode: statusCode,
      message: message ?? 'Transação executada com sucesso',
      response: response,
      additionalData: additionalData ?? {},
    );
  }

  /// Construtor para erro
  factory TransactionResult.error({
    required int statusCode,
    required String message,
    TransactionResponse? response,
    Map<String, dynamic>? additionalData,
  }) {
    return TransactionResult(
      isSuccess: false,
      statusCode: statusCode,
      message: message,
      response: response,
      additionalData: additionalData ?? {},
    );
  }

  /// Construtor a partir de uma resposta
  factory TransactionResult.fromResponse(TransactionResponse response) {
    final isSuccess = response.isServiceSuccess && (response.isTransactionSuccess || response.shouldContinue);

    return TransactionResult(
      isSuccess: isSuccess,
      statusCode: response.clisitefStatus,
      message: response.errorMessage,
      response: response,
    );
  }

  @override
  String toString() {
    return 'TransactionResult('
        'isSuccess: $isSuccess, '
        'statusCode: $statusCode, '
        'message: $message, '
        'response: $response'
        ')';
  }
}
