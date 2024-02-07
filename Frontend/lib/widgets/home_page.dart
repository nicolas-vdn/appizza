import 'package:flutter/material.dart';
import 'package:frontend/api/pizza_api.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../interfaces/pizza.dart';
import '../providers/cart_provider.dart';
import 'components/cart_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Pizza> _pizzaList = [];

  @override
  initState() {
    super.initState();
    fetchPizza();
  }

  fetchPizza() async {
    var pizzaList = await PizzaApi.getCollection();
    setState(() {
      _pizzaList = pizzaList;
    });
  }

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
                    itemCount: _pizzaList.length,
                    itemBuilder: (context, index) {
                      final pizza = _pizzaList[index];
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
                            IconButton(onPressed: () => cart.removePizza(pizza), icon: const Icon(Icons.remove)),
                            const SizedBox(width: 15),
                            Text('${cart.quantityOf(pizza)}'),
                            const SizedBox(width: 15),
                            IconButton(onPressed: () => cart.addPizza(pizza), icon: const Icon(Icons.add)),
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
