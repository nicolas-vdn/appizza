import 'package:flutter/material.dart';
import 'package:frontend/api/order_api.dart';
import 'package:frontend/classes/models/order.dart';
import 'package:frontend/widgets/components/loader.dart';
import 'package:frontend/widgets/utils/gradient_card.dart';
import 'package:intl/intl.dart';

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
                            return CardOrder(
                              order: snapshot.data![index],
                              isLast: index == snapshot.data!.length - 1,
                            );
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
  const CardOrder({super.key, required this.order, required this.isLast});

  final Order order;
  final bool isLast;

  @override
  State<CardOrder> createState() => _CardOrderState();
}

class _CardOrderState extends State<CardOrder> {
  late String formattedDate;

  @override
  void initState() {
    formattedDate = DateFormat.yMMMMd('fr_FR').add_Hm().format(widget.order.date!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CardGradient(
        borderRadius: BorderRadius.circular(8.0),
        child: ExpansionTile(
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            shape: const Border(),
            title: Text(
              'Commande n°${widget.order.id}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'Le ${formattedDate.substring(0, 15)} à ${formattedDate.substring(16, 21)}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            children: [
              const Divider(color: Colors.white, indent: 16, endIndent: 16),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.order.orderContent.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = widget.order.orderContent.entries.toList()[index];

                    return ListTile(
                      leading: Text("${item.value} x",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                      title: Text(item.key.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                      trailing: Text("${item.key.price} €",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    );
                  },
                ),
              ),
              const Divider(color: Colors.white, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.flatware, color: Colors.white),
                title: widget.isLast && DateTime.now().difference(widget.order.date!).inDays == 0
                    ? const Text("Bon appétit !", style: TextStyle(color: Colors.white))
                    : const Text("C'était bon ?", style: TextStyle(color: Colors.white)),
                trailing: Text("Total : ${widget.order.price} €",
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
