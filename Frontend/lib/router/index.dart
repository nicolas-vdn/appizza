import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/auth_page.dart';
import '../widgets/home_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

const List<Widget> icons = <Widget>[
  Icon(Icons.light_mode),
  Icon(Icons.dark_mode),
];

// Router configuration
final router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) async {
    var user = Provider.of<AuthProvider>(context, listen: false);

    if (user.isSignedIn()) {
      if (state.fullPath == "/authenticate") {
        return '/';
      }
    } else {
      await user.localSignIn();

      if (!user.isSignedIn()) {
        return '/authenticate';
      }
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
              toolbarHeight: 128,
              backgroundColor: Colors.transparent,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 96,
                    child: Image.asset('pizza.png'),
                  ),
                  const SizedBox(width: 64),
                  const Text('PizzApp'),
                ],
              ),
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
            body: child,
          ),
        );
      },
      routes: [
        GoRoute(
          name: "authentication",
          path: '/authenticate',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: Scaffold(
              body: AuthPage(),
            ),
          ),
        ),
        GoRoute(
          name: "home",
          path: '/',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) => NoTransitionPage(
            child: ChangeNotifierProvider(
              create: (context) => CartProvider(),
              builder: (context, child) {
                return Scaffold(
                  body: HomePage(),
                );
              },
            ),
          ),
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
    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return provider.isSignedIn()
          ? IconButton(
              icon: const Icon(Icons.logout),
              color: MyApp.of(context).themeMode == ThemeMode.light
                  ? Colors.black
                  : Colors.amber,
              onPressed: () async {
                await provider.logout();
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
    return IconButton(
      icon: Icon(MyApp.of(context).themeMode == ThemeMode.light
          ? Icons.dark_mode
          : Icons.light_mode),
      color: MyApp.of(context).themeMode == ThemeMode.light
          ? Colors.black
          : Colors.amber,
      onPressed: () {
        MyApp.of(context).changeTheme(
            MyApp.of(context).themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light);
      },
    );
  }
}
