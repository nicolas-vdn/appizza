import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class CartContent extends StatelessWidget {
  const CartContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Theme.of(context).cardColor,
        child: Consumer<CartProvider>(
          builder: (context, cart, child) {
            return ExpandablePanel(
              header: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Center(
                      child: Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Center(
                      child: Text(''),
                    ),
                    Center(
                      child: Text('${cart.total} €'),
                    ),
                  ],
                ),
              ),
              collapsed: const SizedBox(),
              expanded:
                  cart.list.isEmpty ? const SizedBox() : const ExpandedRecap(),
            );
          },
        ),
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
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(color: Colors.black),
        ),
        Container(
          constraints: const BoxConstraints(
            maxHeight: 256,
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
                                  '${cart.list.values.toList()[index]} x')),
                        ),
                        Expanded(
                          child: Center(
                              child: Text(cart.list.keys.toList()[index].name)),
                        ),
                        Expanded(
                          child: Center(
                              child: Text(
                                  '${cart.list.keys.toList()[index].price} €')),
                        ),
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
