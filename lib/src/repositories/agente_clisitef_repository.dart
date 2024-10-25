import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/enums/function_id.dart';
import 'package:agente_clisitef/src/models/agente_clisitef_config.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';
import 'package:agente_clisitef/src/repositories/responses/finish_trasaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';

import 'package:agente_clisitef/src/repositories/responses/session_response.dart';
import 'package:agente_clisitef/src/services/client/i_client.dart';

class AgenteClisitefRepository implements IAgenteClisitefRepository {
  final IClient client;
  AgenteClisitefRepository({required this.client});

  AgenteClisitefConfig get config => AgenteClisitef.config;

  @override
  Future<StartTransactionResponse> startTransaction(PaymentMethod paymentMethod, double amount) async {
    Map<String, dynamic> data = {
      'trnAmount': amount.toStringAsFixed(2),
      'functionId': paymentMethod.value,
    };

    data.addAll(config.toMap());
    final request = await client.post(
      '/agente/clisitef/startTransaction',
      data: data,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );
    return StartTransactionResponse.fromMap(request.data);
  }

  @override
  Future<ContinueTransactionResponse> continueTransaction(String sessionId, String data, int continueCode) async {
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
    return ContinueTransactionResponse.fromMap(request.data);
  }

  @override
  Future<FinishTransactionResponse> finishTransaction(
      String sessionId, String taxInvoiceNumber, String taxInvoiceDate, String taxInvoiceTime, bool confirm) async {
    Map<String, dynamic> data = {
      'sessionId': sessionId,
      'taxInvoiceNumber': taxInvoiceNumber,
      'taxInvoiceDate': taxInvoiceDate,
      'taxInvoiceTime': taxInvoiceTime,
      'confirm': confirm ? 1 : 0,
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
}
