import 'package:mynotes/models/note.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  NotesDatabase._();

  static final instance = NotesDatabase._();
  static const _databaseName = 'mynotes.db';
  static const _tableName = 'notes';

  Database? _database;
  Future<Database>? _openingDatabase;

  Future<Database> get _db {
    final database = _database;
    if (database != null) return Future.value(database);
    return _openingDatabase ??= _openDatabase();
  }

  Future<Database> _openDatabase() async {
    try {
      final databasePath = path.join(await getDatabasesPath(), _databaseName);
      final database = await openDatabase(
        databasePath,
        version: 1,
        onCreate: (db, _) => _createSchema(db),
        onOpen: _createSchema,
      );
      _database = database;
      return database;
    } finally {
      _openingDatabase = null;
    }
  }

  Future<void> _createSchema(Database db) => db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

  Future<List<Note>> getAll() async {
    final rows = await (await _db).query(
      _tableName,
      orderBy: 'created_at DESC, id DESC',
    );
    return rows.map(Note.fromMap).toList();
  }

  /// Inserts or updates a note without deleting the user's history on error.
  Future<int> save(Note note) async {
    final values = note.toMap()..remove('id');
    final database = await _db;

    if (note.id == null) {
      return database.insert(_tableName, values);
    }

    return database.update(
      _tableName,
      values,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> delete(int id) async {
    await (await _db).delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
