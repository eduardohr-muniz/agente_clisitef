// import 'package:example/src/compontens/c_text_form_field.dart';
// import 'package:flutter/material.dart';

// class FieldActionsWidget extends StatelessWidget {
//   final String label;
//   final void Function() onContinue;
//   final void Function() onCancel;
//   final void Function(String value) onChange;

//   const FieldActionsWidget({
//     super.key,
//     required this.label,
//     required this.onContinue,
//     required this.onCancel,
//     required this.onChange,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         CTextFormField(labelText: label, onChanged: onChange),
//         Row(
//           children: [
//             TextButton(onPressed: onCancel, child: const Text('Cancelar')),
//             const SizedBox(width: 20),
//             FilledButton(onPressed: onContinue, child: const Text('Continuar')),
//           ],
//         ),
//       ],
//     );
//   }
// }
