import 'dart:convert';

class FinishTransactionResponse {
  final int serviceStatus;
  final String sessionId;
  final int clisitefStatus;

  FinishTransactionResponse({
    required this.serviceStatus,
    required this.sessionId,
    required this.clisitefStatus,
  });

  factory FinishTransactionResponse.fromMap(Map<String, dynamic> map) {
    return FinishTransactionResponse(
      serviceStatus: map['serviceStatus']?.toInt() ?? 0,
      sessionId: map['sessionId'] ?? '',
      clisitefStatus: map['clisitefStatus']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceStatus': serviceStatus,
      'sessionId': sessionId,
      'clisitefStatus': clisitefStatus,
    };
  }

  String toJson() => json.encode(toMap());

  factory FinishTransactionResponse.fromJson(String source) => FinishTransactionResponse.fromMap(json.decode(source));
}
