import 'package:agente_clisitef/src/enums/function_id.dart';
import 'package:agente_clisitef/src/repositories/responses/finish_trasaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/session_response.dart';

abstract class IAgenteClisitefRepository {
  Future<StartTransactionResponse> startTransaction(
      {required PaymentMethod paymentMethod, double? amount, String? taxInvoiceNumber, String? sesionId, String? functionId});

  Future<ContinueTransactionResponse?> continueTransaction({required String sessionId, required int continueCode, String? data});
  Future<FinishTransactionResponse> finishTransaction({required String sessionId, String? taxInvoiceNumber, required int confirm});
  Future<SessionResponse> createSession();
  Future<SessionResponse> getSession();
  Future<void> discardSession();
}
