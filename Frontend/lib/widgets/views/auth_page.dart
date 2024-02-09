import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../utils/gradient_text.dart';

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
        _register
            ? await user.register(_username, _password)
            : await user.signIn(_username, _password);

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
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(64.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WelcomeSection(register: _register),
                const SizedBox(
                  height: 48.0,
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
                        icon: _isObscured
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off)),
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
                ActionSection(
                    register: _register,
                    loading: _isLoading,
                    switchForm: _switchRegister,
                    submit: _onSubmit,
                    formKey: _formKey)
              ],
            ),
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.register ? "Bienvenue" : "Bon retour",
            style: DefaultTextStyle.of(context)
                .style
                .apply(fontSizeFactor: 2.0, fontWeightDelta: 2)),
        Text(widget.register ? "Créez un nouveau compte" : "Connectez vous pour continuer",
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
      ],
    );
  }
}

class ActionSection extends StatefulWidget {
  const ActionSection(
      {super.key,
      required this.register,
      required this.loading,
      required this.switchForm,
      required this.submit,
      required this.formKey});

  final bool register;
  final bool loading;
  final Function switchForm;
  final Function submit;
  final GlobalKey<FormState> formKey;

  @override
  State<ActionSection> createState() => _ActionSectionState();
}

class _ActionSectionState extends State<ActionSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color.fromARGB(255, 204, 0, 0),
                Color.fromARGB(255, 153, 0, 51),
              ]),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(16.0),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: () => widget.loading ? null : widget.submit(),
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
                  : const Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
              label: Text(
                widget.register ? "Inscription" : "Connexion",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                widget.register
                    ? "Vous possédez déjà un compte ?"
                    : "Vous ne possédez pas de compte ?",
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () {
                  widget.formKey.currentState?.reset();
                  widget.switchForm();
                },
                child: GradientText(
                  widget.register ? "Se connecter" : "S'inscrire",
                  gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromARGB(255, 204, 0, 0),
                        Color.fromARGB(255, 153, 0, 51),
                      ]),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
