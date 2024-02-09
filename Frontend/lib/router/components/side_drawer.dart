import 'package:flutter/material.dart';
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
    return Drawer(
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 64.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp'),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.navigate_next),
                  title: const Text('Historique'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
                    color: themeProvider.themeMode == ThemeMode.light ? Colors.deepPurple : Colors.amber,
                  ),
                  title: const Text('Theme'),
                  onTap: () => themeProvider.switchThemeMode(context),
                ),
                Consumer2<AuthProvider, CartProvider>(builder: (context, authProvider, cartProvider, child) {
                  return ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      cartProvider.emptyCart();
                      await authProvider.logout();
                      if (context.mounted) {
                        context.go("/authenticate");
                        Navigator.pop(context);
                      }
                    },
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }
}
