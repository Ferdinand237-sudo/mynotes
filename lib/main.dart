import 'package:flutter/material.dart';
import 'package:mynotes/core/app_theme.dart';
import 'package:mynotes/data/database_platform.dart';
import 'package:mynotes/screens/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDatabaseForPlatform();
  runApp(const MyNotesApp());
}

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MyNotes',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const SplashPage(),
  );
}
