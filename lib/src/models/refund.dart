import 'package:agente_clisitef/src/enums/function_id.dart';

/// Modelo que representa um estorno/cancelamento de transação.
/// Contém os dados necessários para identificar e processar o estorno.
class Refund {
  /// Valor a ser estornado.
  final double amount;

  /// Data da transação original.
  final DateTime date;

  /// NSU (Número Sequencial Único) da transação no host.
  final String nsuHost;

  /// Método de pagamento da transação original.
  final FunctionId paymentMethod;

  /// Cria uma instância de estorno.
  Refund({
    required this.amount,
    required this.date,
    required this.nsuHost,
    required this.paymentMethod,
  });
}
