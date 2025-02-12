import 'package:agente_clisitef/agente_clisitef.dart';

class CancelarTransacaoDto {
  final PaymentMethod paymentMethod;
  final double amount;
  final String nsuHost;
  final DateTime data;
  CancelarTransacaoDto({
    required this.paymentMethod,
    required this.amount,
    required this.nsuHost,
    required this.data,
  });
}
