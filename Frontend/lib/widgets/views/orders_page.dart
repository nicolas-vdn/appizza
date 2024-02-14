import 'package:flutter/material.dart';
import 'package:frontend/api/order_api.dart';
import 'package:frontend/classes/interfaces/order.dart';
import 'package:frontend/classes/interfaces/order_content.dart';
import 'package:go_router/go_router.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late List<Order> _orderList = [];

  @override
  initState() {
    super.initState();
    fetchOrder();
  }

  fetchOrder() async {
    var orderList = await OrderApi.getCollection();
    setState(() {
      _orderList = orderList;
    });
  }

  @override
  Widget build(BuildContext context) {
  return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          IconButton(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.arrow_back)),
          Expanded(
            child: ListView.builder(
                  itemCount: _orderList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OrderCard(order: _orderList[index]);
                  }
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() =>
    _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late final Order order;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
          order.isExpanded = isExpanded;
        });
        },
        children: [ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text('Commande n°${order.id}'),
            );
          }, 
          body: Column(
            children: [
              const Divider(),
              SizedBox(
                height: 200,
                child:
                ListView.builder(
                  itemCount: order.orderContent.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${order.orderContent[index].name} :'),
                          Text('${order.orderContent[index].amount}'),
                        ],
                      )
                    );
                  }),
                ),
              ), 
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total :'),
                        Text('${order.price} €'),
                      ],
                )
              ),
            ]
          ),
          isExpanded: order.isExpanded,
        )],
      ),
    );
  }
}

class Item {
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });
}