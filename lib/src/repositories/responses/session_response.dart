import 'dart:convert';

class SessionResponse {
  final int serviceStatus;
  final String sessionId;
  final int clisitefStatus;

  SessionResponse({
    required this.serviceStatus,
    required this.sessionId,
    required this.clisitefStatus,
  });

  factory SessionResponse.fromMap(Map<String, dynamic> map) {
    return SessionResponse(
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

  factory SessionResponse.fromJson(String source) => SessionResponse.fromMap(json.decode(source));
}
