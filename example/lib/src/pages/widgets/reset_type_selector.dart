import 'package:flutter/material.dart';
import 'package:agente_clisitef/agente_clisitef.dart';

/// Widget para seleção do tipo de reset do PinPad
class ResetTypeSelector extends StatefulWidget {
  final PinPadResetType selectedType;
  final Function(PinPadResetType) onTypeChanged;
  final VoidCallback onResetPressed;
  final bool enabled;

  const ResetTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onResetPressed,
    this.enabled = true,
  });

  @override
  State<ResetTypeSelector> createState() => _ResetTypeSelectorState();
}

class _ResetTypeSelectorState extends State<ResetTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  'Reset do PinPad',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Dropdown para selecionar tipo de reset
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: DropdownButton<PinPadResetType>(
                value: widget.selectedType,
                isExpanded: true,
                underline: const SizedBox(),
                items: PinPadResetType.values.map((resetType) {
                  return DropdownMenuItem<PinPadResetType>(
                    value: resetType,
                    child: Row(
                      children: [
                        Text(
                          resetType.icon,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                resetType.displayName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                resetType.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: widget.enabled
                    ? (PinPadResetType? value) {
                        if (value != null) {
                          widget.onTypeChanged(value);
                        }
                      }
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Botão de reset
            ElevatedButton.icon(
              onPressed: widget.enabled ? widget.onResetPressed : null,
              icon: Text(
                widget.selectedType.icon,
                style: const TextStyle(fontSize: 16),
              ),
              label: Text('EXECUTAR ${widget.selectedType.displayName.toUpperCase()}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getColorForResetType(widget.selectedType),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 8),

            // Descrição detalhada do tipo selecionado
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.selectedType.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForResetType(PinPadResetType resetType) {
    switch (resetType) {
      case PinPadResetType.basic:
        return Colors.purple;
      case PinPadResetType.complete:
        return Colors.orange;
      case PinPadResetType.communication:
        return Colors.blue;
      case PinPadResetType.state:
        return Colors.teal;
      case PinPadResetType.emergency:
        return Colors.red;
      case PinPadResetType.soft:
        return Colors.green;
      case PinPadResetType.limited:
        return Colors.amber;
    }
  }
}
