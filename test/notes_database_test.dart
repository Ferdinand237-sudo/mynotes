import 'package:flutter_test/flutter_test.dart';
import 'package:mynotes/data/notes_database.dart';
import 'package:mynotes/models/note.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('save and read a note persists in sqlite', () async {
    final dbPath = path.join(await getDatabasesPath(), 'mynotes.db');
    await deleteDatabase(dbPath);

    final note = Note(
      title: 'Test note',
      content: 'Contenu de test',
      createdAt: DateTime(2026, 9, 17, 12, 30),
    );

    await NotesDatabase.instance.save(note);
    final notes = await NotesDatabase.instance.getAll();

    expect(notes.length, 1);
    expect(notes.first.title, 'Test note');
    expect(notes.first.content, 'Contenu de test');
  });
}
