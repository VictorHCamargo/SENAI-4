import 'package:flutter/material.dart';

Future<bool> confirmarExclusao(BuildContext context, String nome) async {
  final confirmou = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.warning_amber_rounded),
      title: const Text('Excluir local?'),
      content: Text(
        'O local "$nome" sera excluido. Essa acao nao podera ser desfeita.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Excluir'),
        ),
      ],
    ),
  );

  return confirmou ?? false;
}
