import 'package:agente_clisitef/src/models/payment_status.dart';

/// Classe responsável por gerenciar o estado de uma transação TEF.
/// Mantém o status atual e o flag de finalização.
class TransactionState {
  PaymentStatus _status = PaymentStatus.unknow;
  bool _isFinish = false;

  /// Retorna o status atual da transação.
  PaymentStatus get status => _status;

  /// Indica se a transação foi finalizada.
  bool get isFinish => _isFinish;

  /// Atualiza o status da transação.
  void updateStatus(PaymentStatus status) {
    _status = status;
  }

  /// Marca a transação como finalizada.
  void setIsFinish() {
    _isFinish = true;
  }

  /// Reseta o estado para valores iniciais.
  void reset() {
    _status = PaymentStatus.unknow;
    _isFinish = false;
  }
}
