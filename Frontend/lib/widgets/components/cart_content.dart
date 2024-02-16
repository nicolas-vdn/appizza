import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../utils/gradient_card.dart';

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
            child: ExpansionTile(
              shape: const Border(),
              title: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${cart.total.toStringAsFixed(2)} €',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              children: [
                const Divider(color: Colors.white, indent: 16, endIndent: 16),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cart.list.length,
                  itemBuilder: (context, index) {
                    final item = cart.list.entries.toList()[index];

                    return ListTile(
                      leading: Text("${item.value} x",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                      title: Center(
                        child: Text(item.key.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
                      trailing: Text("${item.key.price} €",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
