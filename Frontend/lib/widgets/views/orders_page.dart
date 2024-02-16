import 'package:flutter/material.dart';
import 'package:frontend/api/order_api.dart';
import 'package:frontend/classes/dto/order.dart';
import 'package:frontend/widgets/components/loader.dart';
import 'package:frontend/widgets/utils/gradient_card.dart';
import 'package:go_router/go_router.dart';

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
    return FutureBuilder<List<Order>>(
      future: _orderList,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Loader();
          default:
            if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: snapshot.data!.isNotEmpty 
                      ? [Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return OrderCard(order: snapshot.data![index]);
                          },
                          shrinkWrap: true,
                        )
                      )]                        
                      : [const Text("Aucune commande n'existe pour ce compte")]
                  )
                );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
        }
        return const Loader();
      },
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
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 50),
      child: CardGradient(
        width: MediaQuery.of(context).size.width,
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
            order.isExpanded = isExpanded;
          });
          },
          children: [ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  'Commande n°${order.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
            backgroundColor: const Color.fromARGB(255, 204, 0, 0),
            body: Column(
              children: [
                const Divider(),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 50,
                    maxHeight: 200
                  ),
                  child:
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: order.orderContent.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${order.orderContent.keys.toList()[index].name} :',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${order.orderContent.values.toList()[index]}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
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
                          const Text(
                            'Total :',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${order.price.toStringAsFixed(2)} €',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                  )
                ),
              ]
            ),
            isExpanded: order.isExpanded,
          )],
        ),
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