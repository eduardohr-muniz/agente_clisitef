import 'dart:convert';

class ContinueTransactionResponse {
  final String sessionId;
  final String? data;
  final int fieldMinLength;
  final int fieldId;
  final int serviceStatus;
  final int clisitefStatus;
  final int commandId;
  final int fieldMaxLength;
  final String? serviceMessage;
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

  String toJson() => json.encode(toMap());

  factory ContinueTransactionResponse.fromJson(String source) => ContinueTransactionResponse.fromMap(json.decode(source));
}
