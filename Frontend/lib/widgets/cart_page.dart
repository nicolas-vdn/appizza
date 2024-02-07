import 'package:flutter/material.dart';
import 'package:frontend/widgets/components/cart_content.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.arrow_back)),
        const CartContent(),
      ],
    );
  }
}
