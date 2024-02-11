import 'package:flutter/material.dart';
import 'package:frontend/widgets/components/cart_content.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

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
              cart.totalQuantity() > 0
                  ? showModalBottomSheet(
                      context: context,
                      builder: (context) => Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CartContent(),
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
                                    context.go("/cart");
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
                    )
                  : null;
            },
          ),
        ],
      );
    });
  }
}
