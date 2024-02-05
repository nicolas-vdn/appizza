import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'router/index.dart';

void main() {
  usePathUrlStrategy();
  runApp(ChangeNotifierProvider(
      create: (context) => AuthProvider(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pizzapp',
      theme: ThemeData(
        brightness: Brightness.light,
        cardColor : const Color.fromARGB(255, 154, 44, 44),
        textTheme : const TextTheme(
            bodyMedium: TextStyle(color: Colors.white)
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        cardColor : Colors.black,
      ),
      themeMode: _themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
