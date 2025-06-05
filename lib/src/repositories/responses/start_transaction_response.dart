import 'dart:convert';

/// Modelo que representa a resposta de início de transação do backend TEF.
class StartTransactionResponse {
  /// ID da sessão criada.
  final String sessionId;

  /// Status do serviço (0 = sucesso).
  final int serviceStatus;

  /// Status do CliSiTef (0 = sucesso).
  final int clisitefStatus;

  /// Cria uma instância de resposta de início de transação.
  StartTransactionResponse({
    required this.sessionId,
    required this.serviceStatus,
    required this.clisitefStatus,
  });

  /// Converte a resposta para um mapa.
  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'serviceStatus': serviceStatus,
      'clisitefStatus': clisitefStatus,
    };
  }

  /// Cria uma instância a partir de um mapa.
  factory StartTransactionResponse.fromMap(Map<String, dynamic> map) {
    return StartTransactionResponse(
      sessionId: map['sessionId'] ?? '',
      serviceStatus: map['serviceStatus']?.toInt() ?? 0,
      clisitefStatus: map['clisitefStatus']?.toInt() ?? 0,
    );
  }

  /// Converte a resposta para JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância a partir de uma string JSON.
  factory StartTransactionResponse.fromJson(String source) => StartTransactionResponse.fromMap(json.decode(source));

  @override
  String toString() => 'StartTransactionResponse(sessionId: $sessionId, serviceStatus: $serviceStatus, clisitefStatus: $clisitefStatus)';
}
