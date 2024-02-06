import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../interfaces/pizza.dart';
import '../providers/cart_provider.dart';

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
    return Column(
      children: [
        const CartContent(),
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(right: 32, left: 32, bottom: 32),
            color: Colors.white,
            child: Center(
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
                        subtitle: Text('USD ${pizza.price}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                                onPressed: () => cart.removePizza(pizza),
                                icon: const Icon(Icons.remove)),
                            const SizedBox(width: 15),
                            Text('${cart.getQuantityOfPizza(pizza)}'),
                            const SizedBox(width: 15),
                            IconButton(
                                onPressed: () => cart.addPizza(pizza),
                                icon: const Icon(Icons.add)),
                          ],
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                  },
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}

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
              expanded: cart.list.isEmpty
                  ? const SizedBox()
                  : Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Divider(color: Colors.black),
                        ),
                        Container(
                          constraints: const BoxConstraints(
                            maxHeight: 256,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cart.list.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Center(
                                      child: Text(
                                          '${cart.list.values.toList()[index]} x'),
                                    ),
                                    Center(
                                      child: Text(
                                          cart.list.keys.toList()[index].name),
                                    ),
                                    Center(
                                      child: Text(
                                          '${cart.list.keys.toList()[index].price} €'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
