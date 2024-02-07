import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  late String _username;
  late String _password;
  bool _isLoading = false;
  bool _isObscured = true;

  Future<void> _onSubmit(bool register) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _formKey.currentState!.save();

      AuthProvider user = Provider.of<AuthProvider>(context, listen: false);
      try {
        register
            ? await user.signIn(_username, _password)
            : await user.register(_username, _password);

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Text('Connexion',
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 2.0)),
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
          Column(
            children: [
              SizedBox(
                width: 200,
                child: FilledButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Theme.of(context).colorScheme.surfaceTint),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                  ),
                  onPressed: () => _isLoading ? null : _onSubmit(false),
                  icon: _isLoading
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
                  label: const Text('Login'),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 200,
                child: FilledButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Theme.of(context).colorScheme.primary),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                  ),
                  onPressed: () => _onSubmit(true),
                  icon: const Icon(Icons.login),
                  label: const Text('Register'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
