import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mynotes/core/app_theme.dart';
import 'package:mynotes/screens/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x332478F2),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.note_alt_outlined,
              size: 55,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'MyNotes',
            style: TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vos idées, toujours avec vous',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 82),
          const SizedBox(
            width: 92,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ],
      ),
    ),
  );
}
