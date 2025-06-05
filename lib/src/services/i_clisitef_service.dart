import 'package:agente_clisitef/src/enums/function_id.dart';
import 'package:agente_clisitef/src/enums/tipo_transacao.dart';
import 'package:agente_clisitef/src/models/payment_status.dart';
import 'package:agente_clisitef/src/models/refund.dart';

/// Interface que define os métodos de serviço do CliSiTef.
abstract class IClisitefService {
  /// Inicia uma transação TEF.
  Future<void> startTransaction({
    required double amount,
    required FunctionId functionId,
    required TipoTransacao tipoTransacao,
    required Function(PaymentStatus) updatePaymentStatus,
  });

  /// Continua uma transação em andamento.
  Future<void> continueTransactionFlow(
    String sessionId,
    Function(String) onErrorToBack,
    Function(String) onErrorToFront,
    Function(String) onSuccess,
    Function(String) onFinish,
  );

  /// Finaliza uma transação.
  Future<void> finishTransactionFlow(
    String sessionId,
    Function(String) onErrorToBack,
    Function(String) onErrorToFront,
    Function(String) onSuccess,
  );

  /// Cancela uma transação.
  Future<void> cancelTransaction({
    required Refund refund,
    required Function(PaymentStatus) updatePaymentStatus,
  });
}
