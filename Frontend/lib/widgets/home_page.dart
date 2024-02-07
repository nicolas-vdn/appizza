import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../interfaces/pizza.dart';
import '../providers/cart_provider.dart';
import 'components/cart_content.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Pizza> pizzaList = [
    Pizza(id: 1, name: "Reine", price: 10.50),
    Pizza(id: 2, name: "4 Fromages", price: 12.30),
    Pizza(id: 3, name: "Bolognaise", price: 9.80),
    Pizza(id: 4, name: "Raclette", price: 14.00),
    Pizza(id: 5, name: "oui", price: 16.32),
    Pizza(id: 6, name: "non", price: 17.00),
    Pizza(id: 7, name: "ah", price: 12.68),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CartContent(),
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(right: 32, left: 32, bottom: 32),
              color: Colors.white,
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return ListView.separated(
                    itemCount: pizzaList.length,
                    itemBuilder: (context, index) {
                      final pizza = pizzaList[index];
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        title: Text(pizza.name),
                        subtitle: Text('${pizza.price} €'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                                onPressed: () => cart.removePizza(pizza),
                                icon: const Icon(Icons.remove)),
                            const SizedBox(width: 15),
                            Text('${cart.quantityOf(pizza)}'),
                            const SizedBox(width: 15),
                            IconButton(
                                onPressed: () => cart.addPizza(pizza),
                                icon: const Icon(Icons.add)),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                  );
                },
              ),
            ),
          ),
          OutlinedButton.icon(
            label: const Text('Valider la commande'),
            onPressed: () => context.go('/cart'),
            icon: const Icon(Icons.shopping_cart_checkout),
          ),
        ],
      ),
    );
  }
}
