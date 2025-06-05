import 'dart:convert';

/// Modelo que representa a resposta de continuação de transação do backend TEF.
class ContinueTransactionResponse {
  /// ID da sessão em andamento.
  final String sessionId;

  /// Dados retornados pelo backend (opcional).
  final String? data;

  /// Tamanho mínimo do campo de entrada.
  final int fieldMinLength;

  /// ID do campo atual.
  final int fieldId;

  /// Status do serviço (0 = sucesso).
  final int serviceStatus;

  /// Status do CliSiTef (0 = sucesso).
  final int clisitefStatus;

  /// ID do comando atual.
  final int commandId;

  /// Tamanho máximo do campo de entrada.
  final int fieldMaxLength;

  /// Mensagem de serviço (opcional).
  final String? serviceMessage;

  /// Cria uma instância de resposta de continuação de transação.
  ContinueTransactionResponse({
    required this.sessionId,
    this.data,
    required this.fieldMinLength,
    required this.fieldId,
    required this.serviceStatus,
    required this.clisitefStatus,
    required this.commandId,
    required this.fieldMaxLength,
    this.serviceMessage,
  });

  /// Converte a resposta para um mapa.
  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'data': data,
      'fieldMinLength': fieldMinLength,
      'fieldId': fieldId,
      'serviceStatus': serviceStatus,
      'clisitefStatus': clisitefStatus,
      'commandId': commandId,
      'fieldMaxLength': fieldMaxLength,
      'serviceMessage': serviceMessage,
    };
  }

  /// Cria uma instância a partir de um mapa.
  factory ContinueTransactionResponse.fromMap(Map<String, dynamic> map) {
    return ContinueTransactionResponse(
      sessionId: map['sessionId'] ?? '',
      data: map['data'],
      fieldMinLength: map['fieldMinLength']?.toInt() ?? 0,
      fieldId: map['fieldId']?.toInt() ?? 0,
      serviceStatus: map['serviceStatus']?.toInt() ?? 0,
      clisitefStatus: map['clisitefStatus']?.toInt() ?? 0,
      commandId: map['commandId']?.toInt() ?? 0,
      fieldMaxLength: map['fieldMaxLength']?.toInt() ?? 0,
      serviceMessage: map['serviceMessage'],
    );
  }

  /// Converte a resposta para JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância a partir de uma string JSON.
  factory ContinueTransactionResponse.fromJson(String source) => ContinueTransactionResponse.fromMap(json.decode(source));
}
