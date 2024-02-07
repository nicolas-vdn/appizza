import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        color: const Color.fromARGB(255, 153, 0, 51),
        child: Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Container(
              // height: 200,
              width: MediaQuery.of(context).size.width - 50,
              child: ExpandablePanel(
                header: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Total : ${cart.total} €',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        label: const Text(
                          'Valider',
                          style: TextStyle(
                            color: Color.fromARGB(255, 204, 0, 0),
                          ),
                        ),
                        onPressed: () => context.go('/cart'),
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Color.fromARGB(255, 204, 0, 0),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(width: 3.0, color: Color.fromARGB(255, 204, 0, 0)),
                          padding: const EdgeInsets.all(8.0),
                        ),
                      )
                    ],
                  ),
                ),
                collapsed: const SizedBox(),
                expanded: cart.list.isEmpty ? const SizedBox() : const ExpandedRecap(),
              ),
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
                              '${cart.list.values.toList()[index]} x',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              cart.list.keys.toList()[index].name,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '${cart.list.keys.toList()[index].price} €',
                              style: const TextStyle(fontSize: 18),
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
