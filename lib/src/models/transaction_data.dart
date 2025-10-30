import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';
import 'package:agente_clisitef/src/core/utils/format_utils.dart';

/// Dados de uma transação CliSiTef para AgenteCliSiTef
class TransactionData {
  /// Código da função (functionId)
  final int functionId;

  /// Valor da transação (trnAmount) - formato: "0.00"
  final double trnAmount;

  /// Número do cupom fiscal (taxInvoiceNumber)
  final String taxInvoiceNumber;

  /// Data fiscal (taxInvoiceDate)
  final DateTime taxInvoiceDate;

  /// Hora fiscal (taxInvoiceTime)
  final DateTime taxInvoiceTime;

  /// Identificação do operador (cashierOperator)
  final String cashierOperator;

  /// Parâmetros adicionais (trnAdditionalParameters)
  final Map<String, String> trnAdditionalParameters;

  /// Parâmetros de inicialização (trnInitParameters)
  final Map<String, String> trnInitParameters;

  /// ID da sessão (sessionId) - opcional
  final String? sessionId;

  const TransactionData({
    required this.functionId,
    required this.trnAmount,
    required this.taxInvoiceNumber,
    required this.taxInvoiceDate,
    required this.taxInvoiceTime,
    this.cashierOperator = CliSiTefConstants.DEFAULT_OPERATOR,
    this.trnAdditionalParameters = const {},
    this.trnInitParameters = const {},
    this.sessionId,
  });

  /// Construtor para transação de pagamento
  factory TransactionData.payment({
    required int functionId,
    required double trnAmount,
    required String taxInvoiceNumber,
    required DateTime taxInvoiceDate,
    required DateTime taxInvoiceTime,
    String? cashierOperator,
    Map<String, String>? trnAdditionalParameters,
    Map<String, String>? trnInitParameters,
    String? sessionId,
  }) {
    return TransactionData(
      functionId: functionId,
      trnAmount: trnAmount,
      taxInvoiceNumber: taxInvoiceNumber,
      taxInvoiceDate: taxInvoiceDate,
      taxInvoiceTime: taxInvoiceTime,
      cashierOperator: cashierOperator ?? CliSiTefConstants.DEFAULT_OPERATOR,
      trnAdditionalParameters: trnAdditionalParameters ?? {},
      trnInitParameters: trnInitParameters ?? {},
      sessionId: sessionId,
    );
  }

  /// Construtor para transação gerencial
  factory TransactionData.administrative({
    required int functionId,
    required String taxInvoiceNumber,
    required DateTime taxInvoiceDate,
    required DateTime taxInvoiceTime,
    String? cashierOperator,
    Map<String, String>? trnAdditionalParameters,
    Map<String, String>? trnInitParameters,
    String? sessionId,
  }) {
    return TransactionData(
      functionId: functionId,
      trnAmount: 0,
      taxInvoiceNumber: taxInvoiceNumber,
      taxInvoiceDate: taxInvoiceDate,
      taxInvoiceTime: taxInvoiceTime,
      cashierOperator: cashierOperator ?? CliSiTefConstants.DEFAULT_OPERATOR,
      trnAdditionalParameters: trnAdditionalParameters ?? {},
      trnInitParameters: trnInitParameters ?? {},
      sessionId: sessionId,
    );
  }

  /// Construtor usando sessionId (para transações subsequentes)
  factory TransactionData.withSession({
    required int functionId,
    required double trnAmount,
    required String taxInvoiceNumber,
    required DateTime taxInvoiceDate,
    required DateTime taxInvoiceTime,
    required String sessionId,
    String? cashierOperator,
    Map<String, String>? trnAdditionalParameters,
    Map<String, String>? trnInitParameters,
  }) {
    return TransactionData(
      functionId: functionId,
      trnAmount: trnAmount,
      taxInvoiceNumber: taxInvoiceNumber,
      taxInvoiceDate: taxInvoiceDate,
      taxInvoiceTime: taxInvoiceTime,
      cashierOperator: cashierOperator ?? CliSiTefConstants.DEFAULT_OPERATOR,
      trnAdditionalParameters: trnAdditionalParameters ?? {},
      trnInitParameters: trnInitParameters ?? {},
      sessionId: sessionId,
    );
  }

  /// Gera os parâmetros adicionais no formato da especificação
  String get trnAdditionalParametersString {
    if (trnAdditionalParameters.isEmpty) return "";

    final params = <String>[];
    params.addAll(trnAdditionalParameters.entries.map((e) => '${e.key}=${e.value}'));
    return params.join(';');
  }

  /// Gera os parâmetros de inicialização no formato da especificação
  String get trnInitParametersString {
    if (trnInitParameters.isEmpty) return "";

    final params = <String>[];
    params.addAll(trnInitParameters.entries.map((e) => '${e.key}=${e.value}'));
    return params.join(';');
  }

  /// Converte para Map para requisições HTTP
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      CliSiTefConstants.PARAM_FUNCTION_ID: functionId.toString(),
      CliSiTefConstants.PARAM_TRN_AMOUNT: trnAmount.toStringAsFixed(2),
      CliSiTefConstants.PARAM_TAX_INVOICE_NUMBER: taxInvoiceNumber,
      CliSiTefConstants.PARAM_TAX_INVOICE_DATE: FormatUtils.formatDate(taxInvoiceDate),
      CliSiTefConstants.PARAM_TAX_INVOICE_TIME: FormatUtils.formatTime(taxInvoiceTime),
      CliSiTefConstants.PARAM_TRN_ADDITIONAL_PARAMETERS: trnAdditionalParametersString,
      CliSiTefConstants.PARAM_TRN_INIT_PARAMETERS: trnInitParametersString,
    };

    if (sessionId != null && sessionId!.isNotEmpty) {
      map[CliSiTefConstants.PARAM_SESSION_ID] = sessionId!;
    }

    return map;
  }

  /// Valida os dados da transação
  List<String> validate() {
    final errors = <String>[];

    // Validar função
    if (functionId < 0) {
      errors.add('functionId deve ser maior ou igual a 0');
    }

    // Validar valor (se não for transação gerencial)
    if (functionId < 110 && trnAmount == 0) {
      errors.add('trnAmount é obrigatório para transações de pagamento');
    }

    // Validar cupom fiscal
    if (taxInvoiceNumber.isEmpty) {
      errors.add('taxInvoiceNumber é obrigatório');
    }

    if (taxInvoiceNumber.length > CliSiTefConstants.MAX_CUPOM_LENGTH) {
      errors.add('taxInvoiceNumber deve ter no máximo ${CliSiTefConstants.MAX_CUPOM_LENGTH} caracteres');
    }

    // Validar operador
    if (cashierOperator.length > CliSiTefConstants.MAX_OPERATOR_LENGTH) {
      errors.add('cashierOperator deve ter no máximo ${CliSiTefConstants.MAX_OPERATOR_LENGTH} caracteres');
    }

    // Validar sessionId
    if (sessionId != null && sessionId!.isNotEmpty) {
      if (sessionId!.length > CliSiTefConstants.MAX_SESSION_ID_LENGTH) {
        errors.add('sessionId deve ter no máximo ${CliSiTefConstants.MAX_SESSION_ID_LENGTH} caracteres');
      }
    }

    return errors;
  }

  /// Verifica se os dados são válidos
  bool get isValid => validate().isEmpty;

  @override
  String toString() {
    return 'TransactionData('
        'functionId: $functionId, '
        'trnAmount: $trnAmount, '
        'taxInvoiceNumber: $taxInvoiceNumber, '
        'taxInvoiceDate: $taxInvoiceDate, '
        'taxInvoiceTime: $taxInvoiceTime, '
        'cashierOperator: $cashierOperator, '
        'trnAdditionalParameters: $trnAdditionalParametersString, '
        'trnInitParameters: $trnInitParametersString, '
        'sessionId: $sessionId'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionData &&
        other.functionId == functionId &&
        other.trnAmount == trnAmount &&
        other.taxInvoiceNumber == taxInvoiceNumber &&
        other.taxInvoiceDate == taxInvoiceDate &&
        other.taxInvoiceTime == taxInvoiceTime &&
        other.cashierOperator == cashierOperator &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    return Object.hash(
      functionId,
      trnAmount,
      taxInvoiceNumber,
      taxInvoiceDate,
      taxInvoiceTime,
      cashierOperator,
      sessionId,
    );
  }
}

/// Dados de produto para Auto-Atendimento (obsoleto na nova especificação)
class ProductData {
  final String code;
  final String description;
  final String amount;
  final int quantity;

  const ProductData({
    required this.code,
    required this.description,
    required this.amount,
    required this.quantity,
  });

  List<String> validate() {
    final errors = <String>[];

    if (code.isEmpty) {
      errors.add('Código do produto é obrigatório');
    }

    if (description.isEmpty) {
      errors.add('Descrição do produto é obrigatória');
    }

    if (amount.isEmpty) {
      errors.add('Valor do produto é obrigatório');
    } else if (!RegExp(r'^\d+,\d{2}$').hasMatch(amount)) {
      errors.add('Valor do produto deve estar no formato "0,00"');
    }

    if (quantity <= 0) {
      errors.add('Quantidade deve ser maior que 0');
    }

    return errors;
  }

  @override
  String toString() {
    return 'ProductData('
        'code: $code, '
        'description: $description, '
        'amount: $amount, '
        'quantity: $quantity'
        ')';
  }
}
