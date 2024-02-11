import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../components/cart_action.dart';
import '../components/side_drawer.dart';

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
        automaticallyImplyLeading: Provider.of<AuthProvider>(context, listen: false).isSignedIn(),
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: SizedBox(
          width: 48,
          child: Image.asset("assets/images/app_pizza.png"),
        ),
        actions: [
          Consumer<AuthProvider>(builder: (context, provider, child) {
            return provider.isSignedIn()
                ? const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: CartAction(),
                  )
                : const SizedBox();
          }),
        ],
      ),
      drawer: const SideDrawer(),
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(maxWidth: 800),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
