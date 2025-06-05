import 'dart:convert';

/// Modelo que representa a resposta de finalização de transação do backend TEF.
class FinishTransactionResponse {
  /// Status do serviço (0 = sucesso).
  final int serviceStatus;

  /// ID da sessão finalizada.
  final String sessionId;

  /// Status do CliSiTef (0 = sucesso).
  final int clisitefStatus;

  /// Cria uma instância de resposta de finalização de transação.
  FinishTransactionResponse({
    required this.serviceStatus,
    required this.sessionId,
    required this.clisitefStatus,
  });

  /// Cria uma instância a partir de um mapa.
  factory FinishTransactionResponse.fromMap(Map<String, dynamic> map) {
    return FinishTransactionResponse(
      serviceStatus: map['serviceStatus']?.toInt() ?? 0,
      sessionId: map['sessionId'] ?? '',
      clisitefStatus: map['clisitefStatus']?.toInt() ?? 0,
    );
  }

  /// Converte a resposta para um mapa.
  Map<String, dynamic> toMap() {
    return {
      'serviceStatus': serviceStatus,
      'sessionId': sessionId,
      'clisitefStatus': clisitefStatus,
    };
  }

  /// Converte a resposta para JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância a partir de uma string JSON.
  factory FinishTransactionResponse.fromJson(String source) => FinishTransactionResponse.fromMap(json.decode(source));
}
