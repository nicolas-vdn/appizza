import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../library/config.dart';
import '../main.dart';
import '../providers/auth_provider.dart';
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

    if (!user.isSignedIn()) {
      await user.localSignIn();

      if (user.isSignedIn()) {
        if (state.fullPath == "/authenticate") {
          return '/';
        }
      } else {
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
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Row(
                children: [
                  const Text('Pizzapp',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  Text("v$appVersion | $appBuild",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      )),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    icon: Icon(MyApp.of(context).themeMode == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode),
                    color: MyApp.of(context).themeMode == ThemeMode.light
                        ? Colors.deepPurple
                        : Colors.amberAccent,
                    onPressed: () {
                      MyApp.of(context).changeTheme(
                          MyApp.of(context).themeMode == ThemeMode.light
                              ? ThemeMode.dark
                              : ThemeMode.light);
                    },
                  ),
                ),
              ],
            ),
            body: child,
          ),
        );
      },
      routes: [
        GoRoute(
            name: "home",
            path: '/',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state) => const NoTransitionPage(
                  child: Scaffold(
                    body: HomePage(),
                  ),
                ),
            routes: [
              GoRoute(
                name: "authentication",
                path: 'authenticate',
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: Scaffold(
                    body: AuthPage(),
                  ),
                ),
              ),
            ]),
      ],
    )
  ],
);
