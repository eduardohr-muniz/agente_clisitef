import 'package:flutter/material.dart';
import 'package:agente_clisitef/agente_clisitef.dart';

/// Widget responsável por exibir os campos mapeados da transação
class TransactionFieldsCard extends StatelessWidget {
  final CapturaTardiaTransaction pendingTransaction;

  const TransactionFieldsCard({
    super.key,
    required this.pendingTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campos Mapeados do CliSiTef',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildField('NSU TEF', pendingTransaction.fields.nsuTef),
            _buildField('NSU Host', pendingTransaction.fields.nsuHost),
            _buildField('Código Autorização', pendingTransaction.fields.codigoAutorizacao),
            _buildField('Instituição', pendingTransaction.fields.instituicao),
            _buildField('Bandeira', pendingTransaction.fields.codigoBandeiraPadrao),
            _buildField(
                'Valor', pendingTransaction.fields.valorPagamento > 0 ? 'R\$ ${pendingTransaction.fields.valorPagamento.toStringAsFixed(2)}' : ''),
            _buildField('Data/Hora', pendingTransaction.fields.dataHoraTransacao),
            _buildField('Via Cliente', pendingTransaction.fields.viaCliente),
            _buildField('Via Estabelecimento', pendingTransaction.fields.viaEstabelecimento),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text('$label: $value'),
    );
  }
}
