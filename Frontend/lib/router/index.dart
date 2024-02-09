import 'package:flutter/material.dart';
import 'package:frontend/widgets/orders_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/views/auth_page.dart';
import '../widgets/views/cart_page.dart';
import '../widgets/views/home_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Router configuration
final router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) async {
    AuthProvider user = Provider.of<AuthProvider>(context, listen: false);

    if (!user.isSignedIn()) {
      await user.localSignIn();
    }
    if (user.isSignedIn()) {
      if (state.fullPath == "/authenticate") {
        return '/';
      }
    } else {
      return '/authenticate';
    }
    return null;
  },
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading:
                  Provider.of<AuthProvider>(context, listen: false).isSignedIn(),
              scrolledUnderElevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: SizedBox(
                width: 48,
                child: Image.asset("assets/images/pizza.png"),
              ),
              actions: [
                Consumer<AuthProvider>(builder: (context, provider, child) {
                  return provider.isSignedIn()
                      ? const SizedBox()
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ThemeButton(),
                        );
                }),
              ],
            ),
            drawer: const LeftDrawer(),
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(maxWidth: 800),
                child: child,
              ),
            ),
          ),
        );
      },
      routes: [
        GoRoute(
          name: "authentication",
          path: '/authenticate',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AuthPage(),
          ),
        ),
        GoRoute(
          name: "home",
          path: '/',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
          routes: [
            GoRoute(
              name: "cart",
              path: 'cart',
              parentNavigatorKey: _shellNavigatorKey,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CartPage(),
              ),
            ),
            GoRoute(
              name: "orders",
              path: 'orders',
              parentNavigatorKey: _shellNavigatorKey,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: Scaffold(
                  body: OrderPage(),
                ))
            )
          ],
        ),
      ],
    )
  ],
);

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
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
                  backgroundImage: NetworkImage(
                      'https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp'),
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
                    color: themeProvider.themeMode == ThemeMode.light
                        ? Colors.deepPurple
                        : Colors.amber,
                  ),
                  title: const Text('Theme'),
                  onTap: () => themeProvider.switchThemeMode(context),
                ),
                Consumer2<AuthProvider, CartProvider>(
                    builder: (context, authProvider, cartProvider, child) {
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

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return IconButton(
        icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
        color: themeProvider.themeMode == ThemeMode.light ? Colors.deepPurple : Colors.amber,
        onPressed: () {
          themeProvider.switchThemeMode(context);
        },
      );
    });
  }
}
