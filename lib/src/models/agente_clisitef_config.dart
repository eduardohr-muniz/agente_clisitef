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

  /// CUPOM FISCAL
  final String taxInvoiceNumber;

  /// DATA FISCAL
  final String taxInvoiceDate;

  /// HORA FISCAL
  final String taxInvoiceTime;

  /// OPERADOR
  final String cashierOperator;

  final bool enableLogs;
  AgenteClisitefConfig({
    this.trnAdditionalParameters = '',
    this.trnInitParameters = '',
    this.sitefIp = ' 127.0.0.1',
    this.storeId = '00000000',
    this.terminalId = 'REST0001',
    this.taxInvoiceNumber = '1234',
    this.taxInvoiceDate = '20180611',
    this.taxInvoiceTime = '170000',
    this.cashierOperator = 'CAIXA',
    this.agenteIp = 'https://127.0.0.1',
    this.enableLogs = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'trnAdditionalParameters': trnAdditionalParameters,
      'trnInitParameters': trnInitParameters,
      'sitefIp': sitefIp,
      'storeId': storeId,
      'terminalId': terminalId,
      'taxInvoiceNumber': taxInvoiceNumber,
      'taxInvoiceDate': taxInvoiceDate,
      'taxInvoiceTime': taxInvoiceTime,
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
      taxInvoiceNumber: map['taxInvoiceNumber'] ?? '',
      taxInvoiceDate: map['taxInvoiceDate'] ?? '',
      taxInvoiceTime: map['taxInvoiceTime'] ?? '',
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
      taxInvoiceNumber: taxInvoiceNumber ?? this.taxInvoiceNumber,
      taxInvoiceDate: taxInvoiceDate ?? this.taxInvoiceDate,
      taxInvoiceTime: taxInvoiceTime ?? this.taxInvoiceTime,
      cashierOperator: cashierOperator ?? this.cashierOperator,
      agenteIp: agenteIp ?? this.agenteIp,
    );
  }
}
