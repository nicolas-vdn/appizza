import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/theme_provider.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({
    super.key,
    required this.constraints,
    required this.child,
  });

  final BoxConstraints constraints;
  final Widget child;

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            SizedBox(
              width: 48,
              child: Image.asset("assets/images/pizza.png"),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 32.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LogoutButton(),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ThemeButton(),
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, AuthProvider, CartProvider>(
        builder: (context, themeProvider, authProvider, cartProvider, child) {
      return authProvider.isSignedIn()
          ? FilledButton.icon(
              label: const Text("Deconnexion"),
              style: FilledButton.styleFrom(backgroundColor: Colors.black),
              icon: const Icon(Icons.logout),
              onPressed: () async {
                cartProvider.emptyCart();
                await authProvider.logout();
                if (context.mounted) {
                  context.go("/authenticate");
                }
              },
            )
          : const SizedBox();
    });
  }
}

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return IconButton(
        icon: Icon(provider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
        color: provider.themeMode == ThemeMode.light ? Colors.deepPurple : Colors.amber,
        onPressed: () {
          provider.switchThemeMode(context);
        },
      );
    });
  }
}
