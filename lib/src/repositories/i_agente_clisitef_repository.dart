import 'package:agente_clisitef/src/enums/function_id.dart';
import 'package:agente_clisitef/src/repositories/responses/finish_trasaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/session_response.dart';

/// Interface que define os métodos de integração com o backend TEF.
abstract class IAgenteClisitefRepository {
  /// Inicia uma transação TEF.
  Future<StartTransactionResponse> startTransaction({
    required PaymentMethod paymentMethod,
    double? amount,
    String? taxInvoiceNumber,
    String? sesionId,
    String? functionId,
  });

  /// Continua uma transação em andamento.
  Future<ContinueTransactionResponse?> continueTransaction({
    required String sessionId,
    required int continueCode,
    String? data,
  });

  /// Finaliza uma transação.
  Future<FinishTransactionResponse> finishTransaction({
    required String sessionId,
    String? taxInvoiceNumber,
    required int confirm,
  });

  /// Cria uma nova sessão TEF.
  Future<SessionResponse> createSession();

  /// Obtém a sessão atual.
  Future<SessionResponse> getSession();

  /// Descarta a sessão atual.
  Future<void> discardSession();
}
