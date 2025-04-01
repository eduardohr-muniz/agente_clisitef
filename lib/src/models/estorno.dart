import 'package:agente_clisitef/agente_clisitef.dart';

class Estorno {
  final PaymentMethod paymentMethod;
  final double amount;
  final String nsuHost;
  final DateTime data;
  Estorno({
    required this.paymentMethod,
    required this.amount,
    required this.nsuHost,
    required this.data,
  });
}
