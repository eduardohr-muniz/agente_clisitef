// ignore_for_file: deprecated_member_use

import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:flutter/material.dart';

/// Widget que exibe as mensagens do MessageManager de forma reativa
class MessageDisplayWidget extends StatelessWidget {
  const MessageDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.message,
                  color: Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mensagens do Sistema',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Mensagem do Caixa (Operador)
            _buildMessageSection(
              context,
              title: 'Mensagem do Caixa',
              icon: Icons.person,
              color: Colors.green,
              messageNotifier: AgenteClisitefMessageManager.instance.messageCashier,
            ),

            const SizedBox(height: 12),

            // Mensagem do Operador (PinPad)
            _buildMessageSection(
              context,
              title: 'Mensagem do Operador',
              icon: Icons.credit_card,
              color: Colors.orange,
              messageNotifier: AgenteClisitefMessageManager.instance.messageOperator,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required ValueNotifier<String> messageNotifier,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<String>(
          valueListenable: messageNotifier,
          builder: (context, message, child) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isNotEmpty ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: message.isNotEmpty ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Text(
                message.isNotEmpty ? message : 'Aguardando mensagem...',
                style: TextStyle(
                  color: message.isNotEmpty ? Colors.black87 : Colors.grey,
                  fontSize: 14,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
