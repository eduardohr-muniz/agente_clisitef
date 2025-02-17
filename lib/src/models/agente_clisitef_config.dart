import 'dart:convert';

class AgenteClisitefConfig {
  /// PARAMETROS DE CONFIGURACAO
  final String trnAdditionalParameters;

  /// PARAMETROS INICIAIS
  final String trnInitParameters;

  ///IP
  final String sitefIp;

  final String agenteIp;

  ///EMPRESA
  final String storeId;

  /// TERMINAL
  final String terminalId;

  /// OPERADOR
  final String cashierOperator;

  final bool enableLogs;

  final bool saveLogsInDirectory;

  final int? clearLogsInDays;
  AgenteClisitefConfig({
    this.trnAdditionalParameters = '',
    this.trnInitParameters = '',
    this.sitefIp = ' 127.0.0.1',
    this.storeId = '00000000',
    this.terminalId = 'REST0001',
    this.cashierOperator = 'CAIXA',
    this.agenteIp = 'https://127.0.0.1',
    this.enableLogs = false,
    this.saveLogsInDirectory = false,
    this.clearLogsInDays = 2,
  });

  Map<String, dynamic> toMap() {
    return {
      'trnAdditionalParameters': trnAdditionalParameters,
      'trnInitParameters': trnInitParameters,
      'sitefIp': sitefIp,
      'storeId': storeId,
      'terminalId': terminalId,
      'cashierOperator': cashierOperator,
    };
  }

  factory AgenteClisitefConfig.fromMap(Map<String, dynamic> map) {
    return AgenteClisitefConfig(
      trnAdditionalParameters: map['trnAdditionalParameters'] ?? '',
      trnInitParameters: map['trnInitParameters'] ?? '',
      sitefIp: map['sitefIp'] ?? '',
      storeId: map['storeId'] ?? '',
      terminalId: map['terminalId'] ?? '',
      cashierOperator: map['cashierOperator'] ?? '',
      agenteIp: map['agenteIp'] ?? 'https://127.0.0.1',
    );
  }

  String toJson() => json.encode(toMap());

  factory AgenteClisitefConfig.fromJson(String source) => AgenteClisitefConfig.fromMap(json.decode(source));

  AgenteClisitefConfig copyWith({
    String? trnAdditionalParameters,
    String? trnInitParameters,
    String? sitefIp,
    String? storeId,
    String? terminalId,
    String? taxInvoiceNumber,
    String? taxInvoiceDate,
    String? taxInvoiceTime,
    String? cashierOperator,
    String? agenteIp,
  }) {
    return AgenteClisitefConfig(
      trnAdditionalParameters: trnAdditionalParameters ?? this.trnAdditionalParameters,
      trnInitParameters: trnInitParameters ?? this.trnInitParameters,
      sitefIp: sitefIp ?? this.sitefIp,
      storeId: storeId ?? this.storeId,
      terminalId: terminalId ?? this.terminalId,
      cashierOperator: cashierOperator ?? this.cashierOperator,
      agenteIp: agenteIp ?? this.agenteIp,
    );
  }
}
