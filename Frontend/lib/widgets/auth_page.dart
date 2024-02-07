import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'classes/GradientText.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  late String _username;
  late String _password;
  bool _register = false;
  bool _isLoading = false;
  bool _isObscured = true;

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _formKey.currentState!.save();

      AuthProvider user = Provider.of<AuthProvider>(context, listen: false);
      try {
        _register ? await user.register(_username, _password) : await user.signIn(_username, _password);

        if (context.mounted && user.isSignedIn()) {
          context.go('/');
        } else {
          setState(() => _isLoading = false);
        }
      } catch (e) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _switchRegister() {
    setState(() {
      _register = !_register;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeSection(register: _register),
            const SizedBox(
              height: 64.0,
            ),
            TextFormField(
              onSaved: (String? value) {
                _username = value!;
              },
              decoration: const InputDecoration(
                hintText: 'Nom d\'utilisateur',
                icon: Icon(Icons.person),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              obscureText: _isObscured,
              onSaved: (String? value) {
                _password = value!;
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    icon: _isObscured ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
                hintText: 'Mot de passe',
                icon: const Icon(Icons.lock),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            ActionSection(register: _register, loading: _isLoading, switchForm: _switchRegister, submit: _onSubmit)
          ],
        ),
      ),
    );
  }
}

class WelcomeSection extends StatefulWidget {
  const WelcomeSection({super.key, required this.register});

  final bool register;

  @override
  State<WelcomeSection> createState() => _WelcomeSectionState();
}

class _WelcomeSectionState extends State<WelcomeSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.register ? "Bienvenue" : "Bon retour",
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0, fontWeightDelta: 2)),
          Text(widget.register ? "Connectez vous pour continuer" : "Créez un nouveau compte",
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
        ],
      ),
    );
  }
}

class ActionSection extends StatefulWidget {
  const ActionSection(
      {super.key, required this.register, required this.loading, required this.switchForm, required this.submit});

  final bool register;
  final bool loading;
  final Function switchForm;
  final Function submit;

  @override
  State<ActionSection> createState() => _ActionSectionState();
}

class _ActionSectionState extends State<ActionSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: <Color>[
                          Color.fromARGB(255, 204, 0, 0),
                          Color.fromARGB(255, 153, 0, 51),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () => widget.loading ? null : widget.submit(),
                  label: Text(widget.register ? "Inscription" : "Connexion"),
                  icon: widget.loading
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.login),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.register ? "Vous possédez déjà un compte ?" : "Vous ne possédez pas de compte ?"),
              TextButton(
                onPressed: () => widget.switchForm(),
                child: GradientText(
                  widget.register ? "Se connecter" : "S'inscrire",
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 204, 0, 0),
                    Color.fromARGB(255, 153, 0, 51),
                  ]),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
