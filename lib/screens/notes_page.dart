import 'package:flutter/material.dart';
import 'package:mynotes/core/app_theme.dart';
import 'package:mynotes/data/notes_database.dart';
import 'package:mynotes/models/note.dart';
import 'package:mynotes/screens/editor_page.dart';
import 'package:mynotes/widgets/app_drawer.dart';
import 'package:mynotes/widgets/empty_notes_state.dart';
import 'package:mynotes/widgets/note_card.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late Future<List<Note>> _notes;
  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => _notes = NotesDatabase.instance.getAll();

  void _refreshNotes() {
    setState(() {
      _reload();
    });
  }

  Future<void> _openEditor([Note? note]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditorPage(note: note)),
    );
    if (mounted) _refreshNotes();
  }

  Future<void> _delete(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const CircleAvatar(
          backgroundColor: Color(0xFFFFE5E5),
          child: Icon(Icons.delete_outline, color: Colors.red),
        ),
        title: const Text('Supprimer cette note ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true && note.id != null) {
      await NotesDatabase.instance.delete(note.id!);
      if (mounted) _refreshNotes();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: const Text(
        'Mes Notes',
        style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
      ),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
    ),
    drawer: const AppDrawer(),
    body: FutureBuilder<List<Note>>(
      future: _notes,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _NotesLoadError(onRetry: _refreshNotes);
        }
        final notes = snapshot.data!;
        if (notes.isEmpty) return EmptyNotesState(onAdd: _openEditor);
        return RefreshIndicator(
          onRefresh: () async {
            _refreshNotes();
            await _notes;
          },
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
            itemCount: notes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 11),
            itemBuilder: (_, index) => NoteCard(
              note: notes[index],
              onTap: () => _openEditor(notes[index]),
              onDelete: () => _delete(notes[index]),
            ),
          ),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _openEditor,
      backgroundColor: AppColors.blue,
      foregroundColor: Colors.white,
      child: const Icon(Icons.add, size: 32),
    ),
  );
}

class _NotesLoadError extends StatelessWidget {
  const _NotesLoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 42, color: Colors.red),
          const SizedBox(height: 12),
          const Text(
            'Impossible de charger vos notes.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    ),
  );
}
