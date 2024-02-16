import 'package:flutter/material.dart';
import 'package:frontend/widgets/utils/gradient_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/theme_provider.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BuildHeader(),
          BuildMenu(),
        ],
      ),
    );
  }
}

class BuildMenu extends StatelessWidget {
  const BuildMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        runSpacing: 8,
        children: [
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historique'),
            onTap: () {
              if (context.mounted) {
                Navigator.pop(context);
                context.goNamed("orders");
              }
            },
          ),
          const Divider(),
          Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
            return ListTile(
              leading: Icon(
                themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
                color: themeProvider.themeMode == ThemeMode.light ? Colors.deepPurple : Colors.amber,
              ),
              title: const Text('Theme'),
              onTap: () => themeProvider.switchThemeMode(context),
            );
          }),
          Consumer2<AuthProvider, CartProvider>(builder: (context, authProvider, cartProvider, child) {
            return ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                cartProvider.emptyCart();
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.pop(context);
                  context.goNamed("authentication");
                }
              },
            );
          }),
        ],
      ),
    );
  }
}

class BuildHeader extends StatelessWidget {
  const BuildHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return CardGradient(
          child: Padding(
            padding: EdgeInsets.only(top: 16 + MediaQuery.of(context).padding.top, bottom: 16),
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp'),
                ),
                const SizedBox(height: 8.0),
                Text(auth.username ?? 'Compte', style: const TextStyle(fontSize: 20, color: Colors.white))
              ],
            ),
          ),
        );
      },
    );
  }
}
