import 'package:flutter/material.dart';

class CTextFormField extends StatelessWidget {
  final String labelText;
  final void Function(String)? onChanged;
  final String? initialValue;

  const CTextFormField({super.key, required this.labelText, this.onChanged, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        onChanged: onChanged,
        initialValue: initialValue,
        decoration: InputDecoration(labelText: labelText, filled: true),
      ),
    );
  }
}
