import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:example/src/compontens/field_actions_widget.dart';
import 'package:flutter/material.dart';

class VendaDigitadaPage extends StatefulWidget {
  final TabController tabController;
  const VendaDigitadaPage({
    super.key,
    required this.tabController,
  });

  @override
  State<VendaDigitadaPage> createState() => _VendaDigitadaPageState();
}

class _VendaDigitadaPageState extends State<VendaDigitadaPage> {
  String magneticoDigitado = '';
  String numeroCarato = '';
  String vencimento = '';
  String codigoSeguranca = '';
  String avista = '';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            FieldActionsWidget(
                label: 'Magnetico: 1 | Digitado: 2',
                onContinue: () {
                  AgenteClisitef.pdvDigitado.continueTransaction(continueCode: 0, data: magneticoDigitado);
                },
                onCancel: () {},
                onChange: (value) {
                  magneticoDigitado = value;
                }),
            FieldActionsWidget(
                label: 'Forneca o numero do cartao',
                onContinue: () {
                  AgenteClisitef.pdvDigitado.continueTransaction(continueCode: 0, data: numeroCarato);
                },
                onCancel: () {},
                onChange: (value) {
                  numeroCarato = value;
                }),
            FieldActionsWidget(
                label: 'Venciomento (MMAA)',
                onContinue: () {
                  AgenteClisitef.pdvDigitado.continueTransaction(continueCode: 0, data: vencimento);
                },
                onCancel: () {},
                onChange: (value) {
                  vencimento = value;
                }),
            FieldActionsWidget(
                label: 'Codigo seguranca (3 Digitos)',
                onContinue: () {
                  AgenteClisitef.pdvDigitado.continueTransaction(continueCode: 0, data: codigoSeguranca);
                },
                onCancel: () {},
                onChange: (value) {
                  codigoSeguranca = value;
                }),
            FieldActionsWidget(
                label: '1. A vista',
                onContinue: () {
                  AgenteClisitef.pdvDigitado.continueTransaction(continueCode: 0, data: avista);
                },
                onCancel: () {},
                onChange: (value) {
                  avista = value;
                }),
          ],
        ),
      ),
    );
  }
}
