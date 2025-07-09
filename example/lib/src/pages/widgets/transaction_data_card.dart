import 'package:flutter/material.dart';

/// Widget responsável por exibir e gerenciar os dados da transação
class TransactionDataCard extends StatelessWidget {
  final String selectedTransactionType;
  final TextEditingController amountController;
  final TextEditingController cupomFiscalController;
  final TextEditingController operatorController;
  final ValueChanged<String> onTransactionTypeChanged;

  const TransactionDataCard({
    super.key,
    required this.selectedTransactionType,
    required this.amountController,
    required this.cupomFiscalController,
    required this.operatorController,
    required this.onTransactionTypeChanged,
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
              'Dados da Transação',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTransactionType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'PIX', child: Text('PIX')),
                      DropdownMenuItem(value: 'CREDITO', child: Text('Crédito')),
                      DropdownMenuItem(value: 'DEBITO', child: Text('Débito')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        onTransactionTypeChanged(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: 'Valor (R\$)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cupomFiscalController,
                    decoration: const InputDecoration(
                      labelText: 'Cupom Fiscal',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: operatorController,
                    decoration: const InputDecoration(
                      labelText: 'Operador',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
