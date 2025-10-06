import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/core/utils/format_utils.dart';

class CancelationData extends TransactionData {
  final DateTime dateTime;
  final String docNumber;
  CancelationData({
    required super.functionId,
    required super.trnAmount,
    required super.taxInvoiceNumber,
    required super.taxInvoiceDate,
    required super.taxInvoiceTime,
    required this.dateTime,
    required this.docNumber,
    super.cashierOperator = CliSiTefConstants.DEFAULT_OPERATOR,
    super.trnAdditionalParameters = const {},
    super.trnInitParameters = const {},
    super.sessionId,
  });

  CancelationData copyWith({
    DateTime? dateTime,
    String? docNumber,
    int? functionId,
    double? trnAmount,
    String? taxInvoiceNumber,
    DateTime? taxInvoiceDate,
    DateTime? taxInvoiceTime,
    String? cashierOperator,
    Map<String, String>? trnAdditionalParameters,
    Map<String, String>? trnInitParameters,
    String? sessionId,
  }) {
    return CancelationData(
      functionId: functionId ?? this.functionId,
      trnAmount: trnAmount ?? this.trnAmount,
      taxInvoiceNumber: taxInvoiceNumber ?? this.taxInvoiceNumber,
      taxInvoiceDate: taxInvoiceDate ?? this.taxInvoiceDate,
      taxInvoiceTime: taxInvoiceTime ?? this.taxInvoiceTime,
      cashierOperator: cashierOperator ?? this.cashierOperator,
      trnAdditionalParameters: trnAdditionalParameters ?? this.trnAdditionalParameters,
      trnInitParameters: trnInitParameters ?? this.trnInitParameters,
      sessionId: sessionId ?? this.sessionId,
      dateTime: dateTime ?? this.dateTime,
      docNumber: docNumber ?? this.docNumber,
    );
  }

  String get formatedDate => FormatUtils.formatDate(dateTime);
}
