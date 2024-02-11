import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/classes/enums/breakpoints.dart';
import 'package:frontend/router/desktop/desktop_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/components/cart_button.dart';
import '../widgets/components/side_drawer.dart';
import '../widgets/views/auth_page.dart';
import '../widgets/views/cart_page.dart';
import '../widgets/views/home_page.dart';
import 'mobile/mobile_scaffold.dart';

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
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > Breakpoints.tablet.size) {
              return DesktopScaffold(constraints: constraints, child: child);
            } else {
              return MobileScaffold(constraints: constraints, child: child);
            }
          }),
        );
      },
      routes: [
        GoRoute(
          name: "cart",
          path: '/cart',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CartPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      name: "authentication",
      path: '/authenticate',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: Scaffold(
          body: SafeArea(
            child: AuthPage(),
          ),
        ),
      ),
    ),
    GoRoute(
      name: "home",
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness:
                    Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
                statusBarColor: Colors.transparent),
            scrolledUnderElevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: SizedBox(
              width: 48,
              child: Image.asset("assets/images/app_pizza.png"),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: CartButton(),
              ),
            ],
          ),
          drawer: const SideDrawer(),
          body: const SafeArea(
            child: HomePage(),
          ),
        ),
      ),
    ),
  ],
);
