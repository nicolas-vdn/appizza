import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class CartAction extends StatelessWidget {
  const CartAction({super.key});

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
            onPressed: () => cart.totalQuantity() > 0 ? context.go('/cart') : null,
          ),
        ],
      );
    });
  }
}
