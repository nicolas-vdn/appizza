import 'package:flutter/material.dart';
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
    var user = Provider.of<AuthProvider>(context, listen: false);

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
              scrolledUnderElevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 48,
                  child: Image.asset("assets/images/pizza.png"),
                ),
              ),
              title: const Text('PizzApp'),
              actions: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ThemeButton(),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LogoutButton(),
                ),
              ],
            ),
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
          ],
        ),
      ],
    )
  ],
);

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, AuthProvider, CartProvider>(
        builder: (context, themeProvider, authProvider, cartProvider, child) {
      return authProvider.isSignedIn()
          ? IconButton(
              icon: const Icon(Icons.logout),
              color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.amber,
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
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return IconButton(
        icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
        color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.amber,
        onPressed: () {
          themeProvider.switchThemeMode(context);
        },
      );
    });
  }
}
