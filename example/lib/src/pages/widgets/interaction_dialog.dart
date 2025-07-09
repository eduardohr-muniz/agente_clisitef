import 'package:flutter/material.dart';
import 'package:agente_clisitef/agente_clisitef.dart';

/// Widget responsável por exibir diálogos de interação com o usuário
class InteractionDialog extends StatelessWidget {
  final TransactionResponse response;
  final Function(String) onContinue;

  const InteractionDialog({
    super.key,
    required this.response,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final dialogConfig = _getDialogConfig();

    return AlertDialog(
      title: Text(dialogConfig.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(dialogConfig.message),
          if (dialogConfig.showOptions) ...[
            const SizedBox(height: 16),
            const Text('1: Pix\n2: Pix Troco'),
          ],
        ],
      ),
      actions: _buildActions(context, dialogConfig),
    );
  }

  /// Configuração do diálogo baseada no comando
  _DialogConfig _getDialogConfig() {
    switch (response.command) {
      case 21: // Menu
        return _DialogConfig(
          title: 'Selecione uma Opção',
          message: response.buffer ?? 'Escolha uma opção:',
          showOptions: true,
          actionType: _ActionType.menu,
        );
      case 20: // Confirmação
        return _DialogConfig(
          title: 'Confirmação',
          message: response.buffer ?? 'Confirma a operação?',
          showOptions: false,
          actionType: _ActionType.confirmation,
        );
      default:
        return _DialogConfig(
          title: 'Entrada Necessária',
          message: response.buffer ?? 'Digite os dados solicitados:',
          showOptions: false,
          actionType: _ActionType.input,
        );
    }
  }

  /// Constrói as ações do diálogo
  List<Widget> _buildActions(BuildContext context, _DialogConfig config) {
    switch (config.actionType) {
      case _ActionType.confirmation:
        return [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onContinue('0'); // Não
            },
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onContinue('1'); // Sim
            },
            child: const Text('Sim'),
          ),
        ];

      case _ActionType.menu:
        return [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onContinue('1'); // Pix
            },
            child: const Text('Pix'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onContinue('2'); // Pix Troco
            },
            child: const Text('Pix Troco'),
          ),
        ];

      case _ActionType.input:
        return [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onContinue(''); // Dados vazios
            },
            child: const Text('OK'),
          ),
        ];
    }
  }
}

/// Configuração do diálogo
class _DialogConfig {
  final String title;
  final String message;
  final bool showOptions;
  final _ActionType actionType;

  _DialogConfig({
    required this.title,
    required this.message,
    required this.showOptions,
    required this.actionType,
  });
}

/// Tipos de ação do diálogo
enum _ActionType {
  confirmation,
  menu,
  input,
}
