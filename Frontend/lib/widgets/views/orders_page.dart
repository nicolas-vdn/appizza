import 'package:flutter/material.dart';
import 'package:frontend/api/order_api.dart';
import 'package:frontend/classes/models/order.dart';
import 'package:frontend/classes/models/pizza.dart';
import 'package:frontend/widgets/components/loader.dart';
import 'package:frontend/widgets/utils/gradient_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<List<Order>> _orderList;

  @override
  initState() {
    super.initState();
    _orderList = OrderApi.getCollection();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _orderList,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Loader();
          default:
            if (snapshot.hasData) {
              return snapshot.data!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CardOrder(order: snapshot.data![index]);
                          }),
                    )
                  : const Center(child: Text("Aucune commande pour ce compte"));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
        }
        return const Loader();
      },
    );
  }
}

class CardOrder extends StatefulWidget {
  const CardOrder({super.key, required this.order});

  final Order order;

  @override
  State<CardOrder> createState() => _CardOrderState();
}

class _CardOrderState extends State<CardOrder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CardGradient(
        borderRadius: BorderRadius.circular(8.0),
        child: ExpansionTile(
            shape: const Border(),
            title: Text(
              'Commande n°${widget.order.id}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            children: [
              const Divider(color: Colors.white, indent: 16, endIndent: 16),
              for (MapEntry<Pizza, int> entry in widget.order.orderContent.entries) ...[
                ListTile(
                  leading: Text("${entry.value} x",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  title: Text(entry.key.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  trailing: Text("${entry.key.price} €",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
              ],
              const Divider(color: Colors.white, indent: 16, endIndent: 16),
              ListTile(
                leading: const Text("Total : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                trailing: Text("${widget.order.price} €",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
            ]),
      ),
    );
  }
}
