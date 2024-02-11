import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../utils/card_gradient.dart';

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
          return Container(
            width: MediaQuery.of(context).size.width - 50,
            constraints: const BoxConstraints(maxWidth: 750),
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
