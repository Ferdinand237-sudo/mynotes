class Note {
  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'created_at': createdAt.toIso8601String(),
  };

  factory Note.fromMap(Map<String, Object?> map) => Note(
    id: map['id'] as int,
    title: map['title'] as String,
    content: map['content'] as String,
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
