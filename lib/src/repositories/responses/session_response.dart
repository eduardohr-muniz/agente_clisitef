import 'dart:convert';

/// Modelo que representa a resposta de criação/obtenção de sessão do backend TEF.
class SessionResponse {
  /// Status do serviço (0 = sucesso).
  final int serviceStatus;

  /// ID da sessão criada/obtida.
  final String sessionId;

  /// Status do CliSiTef (0 = sucesso).
  final int clisitefStatus;

  /// Cria uma instância de resposta de sessão.
  SessionResponse({
    required this.serviceStatus,
    required this.sessionId,
    required this.clisitefStatus,
  });

  /// Cria uma instância a partir de um mapa.
  factory SessionResponse.fromMap(Map<String, dynamic> map) {
    return SessionResponse(
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
  factory SessionResponse.fromJson(String source) => SessionResponse.fromMap(json.decode(source));
}
