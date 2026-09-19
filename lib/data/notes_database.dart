import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mynotes/models/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsernameAlreadyUsedException implements Exception {}

/// Local storage used by both Android and Chrome.
///
/// On Android it uses SharedPreferences; in Chrome it uses the browser's local
/// storage. This keeps the account and note flow identical on both targets.
class NotesDatabase {
  NotesDatabase._();

  static final instance = NotesDatabase._();
  static const _usersKey = 'mynotes.users';
  static const _notesKey = 'mynotes.notes';

  Future<SharedPreferences> get _preferences => SharedPreferences.getInstance();

  String _passwordHash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  Future<List<Map<String, dynamic>>> _readItems(String key) async {
    final rawValue = (await _preferences).getString(key);
    if (rawValue == null || rawValue.isEmpty) return [];

    try {
      return (jsonDecode(rawValue) as List).cast<Map<String, dynamic>>();
    } on FormatException {
      return [];
    }
  }

  Future<void> _writeItems(String key, List<Map<String, dynamic>> items) async {
    final saved = await (await _preferences).setString(key, jsonEncode(items));
    if (!saved) throw StateError('Le stockage local est indisponible.');
  }

  int _nextId(List<Map<String, dynamic>> items) =>
      items.fold<int>(
        0,
        (highest, item) => (item['id'] as num? ?? 0).toInt() > highest
            ? (item['id'] as num).toInt()
            : highest,
      ) +
      1;

  Future<int> register({
    required String username,
    required String password,
  }) async {
    final cleanUsername = username.trim();
    final users = await _readItems(_usersKey);
    final usernameTaken = users.any(
      (user) =>
          (user['username'] as String).toLowerCase() ==
          cleanUsername.toLowerCase(),
    );
    if (usernameTaken) throw UsernameAlreadyUsedException();

    final userId = _nextId(users);
    users.add({
      'id': userId,
      'username': cleanUsername,
      'passwordHash': _passwordHash(password),
    });
    await _writeItems(_usersKey, users);
    return userId;
  }

  Future<int?> authenticate({
    required String username,
    required String password,
  }) async {
    final cleanUsername = username.trim().toLowerCase();
    final hash = _passwordHash(password);
    final users = await _readItems(_usersKey);
    for (final user in users) {
      if ((user['username'] as String).toLowerCase() == cleanUsername &&
          user['passwordHash'] == hash) {
        return (user['id'] as num).toInt();
      }
    }
    return null;
  }

  Future<List<Note>> getAll({required int userId}) async {
    final notes = await _readItems(_notesKey);
    final userNotes =
        notes
            .where((item) => (item['userId'] as num?)?.toInt() == userId)
            .map(
              (item) => Note(
                id: (item['id'] as num).toInt(),
                title: item['title'] as String,
                content: item['content'] as String,
                createdAt: DateTime.parse(item['createdAt'] as String),
              ),
            )
            .toList()
          ..sort(
            (first, second) => second.createdAt.compareTo(first.createdAt),
          );
    return userNotes;
  }

  Future<int> save(Note note, {required int userId}) async {
    final notes = await _readItems(_notesKey);
    final noteId = note.id ?? _nextId(notes);
    final values = {
      'id': noteId,
      'userId': userId,
      'title': note.title,
      'content': note.content,
      'createdAt': note.createdAt.toIso8601String(),
    };
    final existingIndex = notes.indexWhere(
      (item) =>
          (item['id'] as num?)?.toInt() == noteId &&
          (item['userId'] as num?)?.toInt() == userId,
    );

    if (existingIndex == -1) {
      if (note.id != null) throw StateError('Cette note est introuvable.');
      notes.add(values);
    } else {
      notes[existingIndex] = values;
    }
    await _writeItems(_notesKey, notes);
    return noteId;
  }

  Future<void> delete(int id, {required int userId}) async {
    final notes = await _readItems(_notesKey);
    notes.removeWhere(
      (item) =>
          (item['id'] as num?)?.toInt() == id &&
          (item['userId'] as num?)?.toInt() == userId,
    );
    await _writeItems(_notesKey, notes);
  }
}
