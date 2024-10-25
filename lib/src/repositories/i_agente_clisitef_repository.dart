import 'package:agente_clisitef/src/enums/function_id.dart';
import 'package:agente_clisitef/src/repositories/responses/finish_trasaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/session_response.dart';

abstract class IAgenteClisitefRepository {
  Future<StartTransactionResponse> startTransaction(PaymentMethod paymentMethod, double amount);
  Future<ContinueTransactionResponse> continueTransaction(String sessionId, String data, int continueCode);
  Future<FinishTransactionResponse> finishTransaction(
      String sessionId, String taxInvoiceNumber, String taxInvoiceDate, String taxInvoiceTime, bool confirm);
  Future<SessionResponse> createSession();
  Future<SessionResponse> getSession();
  Future<void> discardSession();
}
