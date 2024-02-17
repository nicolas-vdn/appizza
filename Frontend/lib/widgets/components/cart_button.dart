import 'package:flutter/material.dart';
import 'package:frontend/classes/enums/breakpoints.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import 'list_tile_cart.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, child) {
      return Row(
        children: [
          Text("${cart.totalQuantity()}"),
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: cart.totalQuantity() > 0
                  ? const Icon(Icons.shopping_cart_checkout, key: ValueKey('filled'))
                  : const Icon(Icons.shopping_cart_outlined, key: ValueKey('empty')),
            ),
            enableFeedback: cart.totalQuantity() > 0,
            onPressed: () {
              cart.totalQuantity() > 0 ? buildShowModalBottomSheet(context) : null;
            },
          ),
        ],
      );
    });
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: Breakpoints.mobileS.size),
                child: Consumer<CartProvider>(builder: (context, cart, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: cart.list.length,
                    itemBuilder: (context, index) {
                      return ListTileCart(
                        item: cart.list.entries.toList()[index],
                        constant: false,
                      );
                    },
                  );
                }),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 204, 0, 0),
                    Color.fromARGB(255, 153, 0, 51),
                  ]),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    context.goNamed("cart");
                  },
                  icon: const Icon(
                    Icons.checklist,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Continuer",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
