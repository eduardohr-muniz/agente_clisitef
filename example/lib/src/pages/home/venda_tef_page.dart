import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:flutter/material.dart';

class VendaPinpadPage extends StatefulWidget {
  final TabController tabController;
  const VendaPinpadPage({
    super.key,
    required this.tabController,
  });

  @override
  State<VendaPinpadPage> createState() => _VendaPinpadPageState();
}

class _VendaPinpadPageState extends State<VendaPinpadPage> {
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
                                    AgenteClisitef.pdvPinpad.continueTransaction(continueCode: 0);
                                  },
                                  child: const Text('ok'))
                            ],
                          ),
                        if (transaction.fildId == 123)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Confirmar transacao?'),
                              Row(
                                children: [
                                  FilledButton(
                                      onPressed: () {
                                        AgenteClisitef.pdvPinpad.continueTransaction(continueCode: -1);
                                        widget.tabController.animateTo(0);
                                      },
                                      child: const Text('cancelar')),
                                  FilledButton(
                                      onPressed: () {
                                        AgenteClisitef.pdvPinpad.continueTransaction(continueCode: 0);
                                      },
                                      child: const Text('ok')),
                                ],
                              )
                            ],
                          ),
                        Text(
                            "Comando: ${transaction.command.toString()}  \n\nevent: ${transaction.event.toString()} \n\nBuffer: ${transaction.buffer}"
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
                              ? transaction.buffer.toUpperCase()
                              : '',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      }),
                  const Text('Venda Pinpad')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
