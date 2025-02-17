import 'package:example/src/compontens/c_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agente_clisitef/agente_clisitef.dart';

class VendaPage extends StatefulWidget {
  final SharedPreferences preferences;
  final TabController tabController;
  const VendaPage({
    super.key,
    required this.preferences,
    required this.tabController,
  });

  @override
  State<VendaPage> createState() => _VendaPageState();
}

class _VendaPageState extends State<VendaPage> {
  AgenteClisitefConfig config = AgenteClisitefConfig();

  double amount = 0;
  @override
  void initState() {
    final result = widget.preferences.getString(config.runtimeType.toString());
    if (result != null) config = AgenteClisitefConfig.fromJson(result);
    super.initState();
  }

  void _savePreferences() {
    widget.preferences.setString(config.runtimeType.toString(), config.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CTextFormField(
                labelText: 'Parametros de configuracao',
                initialValue: config.trnAdditionalParameters,
                onChanged: (value) {
                  config = config.copyWith(trnAdditionalParameters: value);
                  _savePreferences();
                }),
            const SizedBox(height: 40),
            CTextFormField(
                labelText: 'Parâmetros inicia',
                initialValue: config.trnInitParameters,
                onChanged: (value) {
                  config = config.copyWith(trnInitParameters: value);
                  _savePreferences();
                }),
            CTextFormField(
                labelText: 'IP Sitef',
                initialValue: config.sitefIp,
                onChanged: (value) {
                  config = config.copyWith(sitefIp: value);
                  _savePreferences();
                }),
            CTextFormField(
                labelText: 'IP Agente',
                initialValue: config.agenteIp,
                onChanged: (value) {
                  config = config.copyWith(agenteIp: value);
                  _savePreferences();
                }),
            CTextFormField(
                labelText: 'Empresa',
                initialValue: config.storeId,
                onChanged: (value) {
                  config = config.copyWith(storeId: value);
                  _savePreferences();
                }),
            CTextFormField(
                labelText: 'Terminal',
                initialValue: config.terminalId,
                onChanged: (value) {
                  config = config.copyWith(terminalId: value);
                  _savePreferences();
                }),
            CTextFormField(
                labelText: 'Digite o valor da transaçao',
                initialValue: amount.toString(),
                onChanged: (value) {
                  amount = double.tryParse(value) ?? 0;
                  _savePreferences();
                }),
            CTextFormField(
                labelText: 'Cupom fiscal',
                initialValue: '',
                onChanged: (value) {
                  config = config.copyWith(taxInvoiceNumber: value);
                  _savePreferences();
                }),
            CTextFormField(
                labelText: 'Data fiscal',
                initialValue: '',
                onChanged: (value) {
                  config = config.copyWith(taxInvoiceDate: value);
                  _savePreferences();
                }),
            CTextFormField(
                labelText: 'Hora fiscal',
                initialValue: '',
                onChanged: (value) {
                  config = config.copyWith(taxInvoiceTime: value);
                  _savePreferences();
                }),
            CTextFormField(
                labelText: 'Operador',
                initialValue: config.cashierOperator,
                onChanged: (value) {
                  config = config.copyWith(cashierOperator: value);
                  _savePreferences();
                }),
            FilledButton(
                onPressed: () {
                  AgenteClisitef.initialize(config);
                  AgenteClisitef.pdvDigitado.startTransaction(paymentMethod: PaymentMethod.credito, amount: amount);
                  widget.tabController.animateTo(1);
                },
                child: const Text('INICIAR VENDA DIGITADA')),
            const SizedBox(height: 12),
            FilledButton(
                onPressed: () {
                  AgenteClisitef.initialize(config);
                  AgenteClisitef.pdvPinpad.startTransaction(
                    paymentMethod: PaymentMethod.credito,
                    amount: amount,
                    taxInvoiceNumber: '',
                  );
                  widget.tabController.animateTo(2);
                },
                child: const Text('INICIAR VENDA PINPAD')),
            const SizedBox(height: 12),
            // FilledButton(onPressed: () {}, child: const Text('FINALIZAR ESTORNANDO')),
          ],
        ),
      ),
    );
  }
}
