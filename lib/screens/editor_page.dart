import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mynotes/core/app_theme.dart';
import 'package:mynotes/data/notes_database.dart';
import 'package:mynotes/models/note.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, this.note, required this.userId});
  final Note? note;
  final int userId;
  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late final _title = TextEditingController(text: widget.note?.title);
  late final _content = TextEditingController(text: widget.note?.content);
  final _form = GlobalKey<FormState>();
  bool _saving = false;
  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      await NotesDatabase.instance
          .save(
            Note(
              id: widget.note?.id,
              title: _title.text.trim(),
              content: _content.text.trim(),
              createdAt: widget.note?.createdAt ?? DateTime.now(),
            ),
            userId: widget.userId,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Enregistrement de note trop long');
            },
          );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d’enregistrer la note. Réessayez.'),
        ),
      );
      debugPrint('Erreur lors de l’enregistrement de la note: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.note == null ? 'Nouvelle note' : 'Modifier la note',
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      centerTitle: true,
    ),
    body: SafeArea(
      child: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.note_outlined),
                  hintText: 'Titre de la note',
                ),
                validator: _requiredTitle,
              ),
              const SizedBox(height: 14),
              Expanded(
                child: TextFormField(
                  controller: _content,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 180),
                      child: Icon(Icons.subject),
                    ),
                    hintText: 'Écrivez votre note ici...',
                    alignLabelWithHint: true,
                  ),
                  validator: _requiredContent,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  if (widget.note != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Annuler'),
                      ),
                    ),
                  if (widget.note != null) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: Text(
                        _saving ? 'Enregistrement...' : 'Enregistrer',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  String? _requiredTitle(String? value) =>
      value == null || value.trim().isEmpty ? 'Le titre est requis' : null;
  String? _requiredContent(String? value) =>
      value == null || value.trim().isEmpty ? 'Le contenu est requis' : null;
}
