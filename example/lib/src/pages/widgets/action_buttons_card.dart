import 'package:flutter/material.dart';

/// Widget responsável por exibir os botões de ação
class ActionButtonsCard extends StatelessWidget {
  final bool isLoading;
  final bool hasPendingTransaction;
  final bool isTransactionFinalized;
  final VoidCallback onStartTransaction;
  final VoidCallback onSimulateCupom;
  final VoidCallback onConfirmTransaction;
  final VoidCallback onCancelTransaction;

  const ActionButtonsCard({
    super.key,
    required this.isLoading,
    required this.hasPendingTransaction,
    required this.isTransactionFinalized,
    required this.onStartTransaction,
    required this.onSimulateCupom,
    required this.onConfirmTransaction,
    required this.onCancelTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ações',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Iniciar Transação Pendente
            ElevatedButton.icon(
              onPressed: isLoading ? null : onStartTransaction,
              icon: const Icon(Icons.play_arrow),
              label: const Text('1. Iniciar Transação Pendente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            // Simular Emissão de Cupom
            ElevatedButton.icon(
              onPressed: hasPendingTransaction && !isLoading ? onSimulateCupom : null,
              icon: const Icon(Icons.receipt),
              label: const Text('2. Simular Emissão de Cupom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            // Confirmar Transação
            ElevatedButton.icon(
              onPressed: hasPendingTransaction && !isTransactionFinalized && !isLoading ? onConfirmTransaction : null,
              icon: const Icon(Icons.check_circle),
              label: const Text('3. Confirmar Transação'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            // Cancelar Transação
            ElevatedButton.icon(
              onPressed: hasPendingTransaction && !isTransactionFinalized && !isLoading ? onCancelTransaction : null,
              icon: const Icon(Icons.cancel),
              label: const Text('4. Cancelar Transação'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
