import 'package:flutter_test/flutter_test.dart';
import 'package:mynotes/data/notes_database.dart';
import 'package:mynotes/models/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('accounts authenticate and only read their own notes', () async {
    SharedPreferences.setMockInitialValues({});

    final database = NotesDatabase.instance;
    final firstUserId = await database.register(
      username: 'alice',
      password: 'motdepasse',
    );
    final secondUserId = await database.register(
      username: 'bob',
      password: 'motdepasse',
    );
    final note = Note(
      title: 'Test note',
      content: 'Contenu de test',
      createdAt: DateTime(2026, 9, 17, 12, 30),
    );

    await database.save(note, userId: firstUserId);
    final notes = await database.getAll(userId: firstUserId);

    expect(notes.length, 1);
    expect(notes.first.title, 'Test note');
    expect(notes.first.content, 'Contenu de test');
    expect(await database.getAll(userId: secondUserId), isEmpty);
    expect(
      await database.authenticate(username: 'ALICE', password: 'motdepasse'),
      firstUserId,
    );
    expect(
      await database.authenticate(username: 'alice', password: 'incorrect'),
      isNull,
    );
  });
}
