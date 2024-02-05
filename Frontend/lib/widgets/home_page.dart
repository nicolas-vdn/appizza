import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CartContent(),
        Expanded(
          child: Card(
            color: Colors.transparent,
            child: Center(
              child: Text(
                "Bonjour",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
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
            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cart.list.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Center(
                            child:
                                Text('${cart.list.values.toList()[index]} x'),
                          ),
                          Center(
                            child: Text(cart.list.keys.toList()[index].name),
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
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Divider(color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
