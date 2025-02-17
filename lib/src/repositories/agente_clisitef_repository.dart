import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';
import 'package:agente_clisitef/src/repositories/responses/finish_trasaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';

import 'package:agente_clisitef/src/repositories/responses/session_response.dart';
import 'package:agente_clisitef/src/services/client/i_client.dart';
import 'package:intl/intl.dart';

class AgenteClisitefRepository implements IAgenteClisitefRepository {
  final IClient client;
  AgenteClisitefRepository({required this.client});

  AgenteClisitefConfig get config => AgenteClisitef.config;

  @override
  Future<StartTransactionResponse> startTransaction(
      {required PaymentMethod paymentMethod, double? amount, String? taxInvoiceNumber, String? sesionId, String? functionId}) async {
    Map<String, dynamic> data = {
      'trnAmount': amount?.toStringAsFixed(2) ?? '',
      'functionId': functionId ?? paymentMethod.value,
      'taxInvoiceNumber': taxInvoiceNumber ?? '',
      'taxInvoiceDate': getDateNow(),
      'taxInvoiceTime': getTimeNow(),
      'cashierOperator': config.cashierOperator,
      'tnrAdditionalParameters': config.trnAdditionalParameters,
      'tnrInitParameters': config.trnInitParameters,
    };
    if (sesionId != null) data['sessionId'] = sesionId;

    data.addAll(config.toMap());
    final request = await client.post(
      '/agente/clisitef/startTransaction',
      data: data,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );
    return StartTransactionResponse.fromMap(request.data);
  }

  @override
  Future<ContinueTransactionResponse?> continueTransaction({required String sessionId, required int continueCode, String? data}) async {
    Map<String, dynamic> params = {
      'sessionId': sessionId,
      'data': data,
      'continue': continueCode,
    };

    final request = await client.post(
      '/agente/clisitef/continueTransaction',
      data: params,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );
    if (request.data == null) return null;
    return ContinueTransactionResponse.fromMap(request.data);
  }

  @override
  Future<FinishTransactionResponse> finishTransaction(
      {required String sessionId,
      required String taxInvoiceNumber,
      required String taxInvoiceDate,
      required String taxInvoiceTime,
      required int confirm}) async {
    Map<String, dynamic> data = {
      'sessionId': sessionId,
      'taxInvoiceNumber': taxInvoiceNumber,
      'taxInvoiceDate': getDateNow(),
      'taxInvoiceTime': getTimeNow(),
      'confirm': confirm,
    };

    final request = await client.post(
      '/agente/clisitef/finishTransaction',
      data: data,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );
    return FinishTransactionResponse.fromMap(request.data);
  }

  @override
  Future<SessionResponse> createSession() async {
    final request = await client.post(
      '/agente/clisitef/session',
      data: config.toMap(),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );
    return SessionResponse.fromMap(request.data);
  }

  @override
  Future<SessionResponse> getSession() async {
    final request = await client.get('/agente/clisitef/session');
    return SessionResponse.fromMap(request.data);
  }

  @override
  Future<void> discardSession() async {
    await client.delete('/agente/clisitef/session');
  }

  String getDateNow() {
    final date = DateFormat('ddMMyyyy').format(DateTime.now());
    return date;
  }

  String getTimeNow() {
    final dateHour = DateFormat('HHmmss').format(DateTime.now());
    return dateHour;
  }
}
