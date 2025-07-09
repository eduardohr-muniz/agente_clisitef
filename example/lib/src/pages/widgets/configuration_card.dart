import 'package:flutter/material.dart';

/// Widget responsável por exibir e gerenciar as configurações
class ConfigurationCard extends StatelessWidget {
  final TextEditingController serverIPController;
  final TextEditingController storeIdController;
  final TextEditingController terminalIdController;

  const ConfigurationCard({
    super.key,
    required this.serverIPController,
    required this.storeIdController,
    required this.terminalIdController,
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
              'Configurações',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: serverIPController,
                    decoration: const InputDecoration(
                      labelText: 'IP do Servidor',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: storeIdController,
                    decoration: const InputDecoration(
                      labelText: 'ID da Loja',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: terminalIdController,
              decoration: const InputDecoration(
                labelText: 'ID do Terminal',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
