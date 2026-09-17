import 'package:flutter_test/flutter_test.dart';
import 'package:mynotes/main.dart';

void main() {
  testWidgets('MyNotes affiche son écran de lancement', (tester) async {
    await tester.pumpWidget(const MyNotesApp());
    expect(find.text('MyNotes'), findsOneWidget);
    expect(find.text('Vos idées, toujours avec vous'), findsOneWidget);
  });
}
