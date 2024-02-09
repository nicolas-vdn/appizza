import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class CartAction extends StatelessWidget {
  const CartAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, child) {
      return OutlinedButton.icon(
        onPressed: () => cart.list.isNotEmpty ? context.go('/cart') : null,
        icon: const Icon(Icons.shopping_cart_checkout),
        label: Text("${cart.totalQuantity()}"),
      );
    });
  }
}
