import 'package:flutter/material.dart';

import 'components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 2,
          child: Card(
            color: Theme.of(context).cardColor,
            child: const Padding(
              padding: EdgeInsets.all(32.0),
              child: AuthForm(),
            ),
          ),
        ),
      ],
    );
  }
}
