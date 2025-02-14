import 'package:agente_clisitef/src/enums/function_id.dart';
import 'package:agente_clisitef/src/repositories/responses/finish_trasaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/session_response.dart';

abstract class IAgenteClisitefRepository {
  Future<StartTransactionResponse> startTransaction({required PaymentMethod paymentMethod, required double amount});
  Future<StartTransactionResponse> startTransactionFunctions({required String sessionId, required int functionId});
  Future<ContinueTransactionResponse?> continueTransaction({required String sessionId, required int continueCode, String? data});
  Future<FinishTransactionResponse> finishTransaction(
      {required String sessionId,
      required String taxInvoiceNumber,
      required String taxInvoiceDate,
      required String taxInvoiceTime,
      required int confirm});
  Future<SessionResponse> createSession();
  Future<SessionResponse> getSession();
  Future<void> discardSession();
}
