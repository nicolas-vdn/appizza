import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import 'card_gradient.dart';

class CartContent extends StatelessWidget {
  const CartContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CardGradient(
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return SizedBox(
            width: MediaQuery.of(context).size.width > 800 ? 750 : MediaQuery.of(context).size.width - 50,
            child: ExpandablePanel(
              header: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${cart.total} €',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (GoRouter.of(context).routeInformationProvider.value.uri.toString() == "/" &&
                        cart.list.isNotEmpty) ...[
                      OutlinedButton.icon(
                        label: const Text(
                          'Valider',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => context.go('/cart'),
                        icon: const Icon(
                          Icons.shopping_cart_checkout,
                          color: Colors.white,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(width: 3.0, color: Colors.white),
                          padding: const EdgeInsets.all(16.0),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              collapsed: const SizedBox(),
              expanded: cart.list.isEmpty ? const SizedBox() : const ExpandedRecap(),
            ),
          );
        },
      ),
    );
  }
}

class ExpandedRecap extends StatelessWidget {
  const ExpandedRecap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(color: Colors.white),
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.20,
          ),
          child: Consumer<CartProvider>(
            builder: (context, cart, child) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: cart.list.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              '${cart.list.values.toList()[index]} x',
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              cart.list.keys.toList()[index].name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '${cart.list.keys.toList()[index].price} €',
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
