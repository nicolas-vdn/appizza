import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/providers/map_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import 'router/index.dart';

void main() {
  usePathUrlStrategy();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => CartProvider()),
      ChangeNotifierProvider(create: (context) => MapProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp.router(
        title: 'PizzApp',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeProvider.themeMode,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
