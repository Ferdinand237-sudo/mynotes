import 'package:flutter/material.dart';
import 'package:mynotes/core/app_theme.dart';
import 'package:mynotes/screens/notes_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _hidden = true;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (_username.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() => _error = 'Veuillez renseigner vos identifiants.');
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NotesPage()),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.lock_person_outlined,
                  color: AppColors.blue,
                  size: 56,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Connexion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Connectez-vous pour accéder à vos notes',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 34),
                TextField(
                  controller: _username,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: "Nom d'utilisateur",
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _password,
                  obscureText: _hidden,
                  onSubmitted: (_) => _login(),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: 'Mot de passe',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _hidden = !_hidden),
                      icon: Icon(
                        _hidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _login,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
