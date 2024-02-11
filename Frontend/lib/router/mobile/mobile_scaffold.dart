import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({
    super.key,
    required this.constraints,
    required this.child,
  });

  final BoxConstraints constraints;
  final Widget child;

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
            statusBarColor: Colors.transparent),
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go("/"),
        ),
        title: SizedBox(
          width: 48,
          child: Image.asset("assets/images/app_pizza.png"),
        ),
      ),
      body: SafeArea(
        child: widget.child,
      ),
    );
  }
}
