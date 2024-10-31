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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: ValueListenableBuilder(
                  valueListenable: AgenteClisitef.pdvDigitado.transaction,
                  builder: (context, transaction, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (transaction.fildId == 102)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Pagameto realizado com sucesso!'),
                              FilledButton(
                                  onPressed: () {
                                    AgenteClisitef.pdvDigitado.continueTransaction(continueCode: 0);
                                  },
                                  child: const Text('ok'))
                            ],
                          ),
                        if (transaction.fildId == 123)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Confirmar transacao?'),
                              FilledButton(
                                  onPressed: () {
                                    AgenteClisitef.pdvDigitado.continueTransaction(continueCode: 0);
                                  },
                                  child: const Text('ok'))
                            ],
                          ),
                        Text(
                            "Comando: ${transaction.command.toString()}  \n\nevent: ${transaction.event.toString()} \n\nBuffer: ${transaction.buufer}"
                                .toUpperCase()),
                        Text(transaction.cliSiTefResp.codResult.toString().replaceAll(',', ',\n').replaceAll('}', '\n}').replaceAll('{', '{\n'))
                      ],
                    );
                  }),
            ),
            Expanded(
              child: Column(
                children: [
                  ValueListenableBuilder(
                      valueListenable: AgenteClisitef.pdvDigitado.transaction,
                      builder: (context, transaction, _) {
                        return Text(
                          (transaction.event == DataEvents.messageCashier || transaction.command == CommandEvents.getField)
                              ? transaction.buufer.toUpperCase()
                              : '',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      }),
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
          ],
        ),
      ),
    );
  }
}
