import 'dart:convert';

class StartTransactionResponse {
  final String sessionId;
  final int serviceStatus;
  final int clisitefStatus;
  StartTransactionResponse({
    required this.sessionId,
    required this.serviceStatus,
    required this.clisitefStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'serviceStatus': serviceStatus,
      'clisitefStatus': clisitefStatus,
    };
  }

  factory StartTransactionResponse.fromMap(Map<String, dynamic> map) {
    return StartTransactionResponse(
      sessionId: map['sessionId'] ?? '',
      serviceStatus: map['serviceStatus']?.toInt() ?? 0,
      clisitefStatus: map['clisitefStatus']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory StartTransactionResponse.fromJson(String source) => StartTransactionResponse.fromMap(json.decode(source));
}
