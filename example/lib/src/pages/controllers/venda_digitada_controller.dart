import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:flutter/material.dart';

class VendaDigitadaController extends ChangeNotifier {
  final agente = AgenteClisitef.pdvDigitado.transaction;
  void initialize() {
    agente.addListener(() {});
  }
}
