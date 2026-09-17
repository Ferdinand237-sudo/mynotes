import 'package:flutter/material.dart';
import 'package:mynotes/core/app_theme.dart';

class EmptyNotesState extends StatelessWidget {
  const EmptyNotesState({super.key, required this.onAdd});
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.note_add_outlined,
            size: 94,
            color: Color(0xFFC8DBF3),
          ),
          const SizedBox(height: 20),
          const Text(
            'Aucune note pour le moment',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Commencez par ajouter une nouvelle note !',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter une note'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.blue),
          ),
        ],
      ),
    ),
  );
}
