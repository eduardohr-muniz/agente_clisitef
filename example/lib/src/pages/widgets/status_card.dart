import 'package:flutter/material.dart';

/// Widget responsável por exibir o status do serviço
class StatusCard extends StatelessWidget {
  final String sessionId;
  final bool hasPendingTransaction;
  final bool isTransactionFinalized;

  const StatusCard({
    super.key,
    required this.sessionId,
    required this.hasPendingTransaction,
    required this.isTransactionFinalized,
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
              'Status do Serviço',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (sessionId.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('SessionId: $sessionId'),
            ],
            if (hasPendingTransaction) ...[
              const SizedBox(height: 4),
              Text('Transação Finalizada: ${isTransactionFinalized ? "Sim" : "Não"}'),
            ],
          ],
        ),
      ),
    );
  }
}
