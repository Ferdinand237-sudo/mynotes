import 'package:flutter/material.dart';
import 'package:mynotes/core/app_theme.dart';
import 'package:mynotes/models/note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFFE3F0FF),
      Color(0xFFE4F8E9),
      Color(0xFFF0E8FF),
      Color(0xFFFFF0D4),
    ];
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFECF0F6)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors[(note.id ?? 0) % colors.length],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      note.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _dateText(note.createdAt),
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (action) =>
                    action == 'delete' ? onDelete() : onTap(),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Modifier')),
                  PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dateText(DateTime date) {
    const months = [
      'jan.',
      'févr.',
      'mars',
      'avr.',
      'mai',
      'juin',
      'juil.',
      'août',
      'sept.',
      'oct.',
      'nov.',
      'déc.',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
