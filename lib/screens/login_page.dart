import 'package:flutter/material.dart';
import 'package:mynotes/core/app_theme.dart';
import 'package:mynotes/data/notes_database.dart';
import 'package:mynotes/screens/notes_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _hidden = true;
  bool _creatingAccount = false;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    final username = _username.text.trim();
    try {
      final database = NotesDatabase.instance;
      final userId = _creatingAccount
          ? await database.register(
              username: username,
              password: _password.text,
            )
          : await database.authenticate(
              username: username,
              password: _password.text,
            );

      if (!mounted) return;
      if (userId == null) {
        setState(() => _error = 'Nom d’utilisateur ou mot de passe incorrect.');
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => NotesPage(userId: userId, username: username),
        ),
      );
    } on UsernameAlreadyUsedException {
      if (mounted) {
        setState(() => _error = 'Ce nom d’utilisateur est déjà utilisé.');
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Une erreur est survenue. Réessayez.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _toggleMode() {
    setState(() {
      _creatingAccount = !_creatingAccount;
      _error = null;
      _confirmation.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.lock_person_outlined,
                    color: AppColors.blue,
                    size: 56,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _creatingAccount ? 'Créer un compte' : 'Connexion',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _creatingAccount
                        ? 'Choisissez vos identifiants pour sauvegarder vos notes.'
                        : 'Connectez-vous pour accéder à vos notes',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 34),
                  TextFormField(
                    controller: _username,
                    enabled: !_submitting,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: "Nom d'utilisateur",
                    ),
                    validator: (value) {
                      final username = value?.trim() ?? '';
                      if (username.length < 3) {
                        return 'Utilisez au moins 3 caractères.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _password,
                    enabled: !_submitting,
                    obscureText: _hidden,
                    textInputAction: _creatingAccount
                        ? TextInputAction.next
                        : TextInputAction.done,
                    onFieldSubmitted: (_) {
                      if (!_creatingAccount) _submit();
                    },
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
                    validator: (value) {
                      if ((value ?? '').length < 6) {
                        return 'Utilisez au moins 6 caractères.';
                      }
                      return null;
                    },
                  ),
                  if (_creatingAccount) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _confirmation,
                      enabled: !_submitting,
                      obscureText: _hidden,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock_reset_outlined),
                        hintText: 'Confirmer le mot de passe',
                      ),
                      validator: (value) => value != _password.text
                          ? 'Les mots de passe ne correspondent pas.'
                          : null,
                    ),
                  ],
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _submitting
                          ? 'Veuillez patienter…'
                          : _creatingAccount
                          ? 'Créer mon compte'
                          : 'Se connecter',
                    ),
                  ),
                  TextButton(
                    onPressed: _submitting ? null : _toggleMode,
                    child: Text(
                      _creatingAccount
                          ? 'J’ai déjà un compte'
                          : 'Créer un compte',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
