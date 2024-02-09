import 'package:flutter/material.dart';
import 'package:frontend/api/order_api.dart';
import 'package:frontend/interfaces/order.dart';
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
            child: Column(
                  children: _orderList.map((order) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: (order.orderContent.map((pizza) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      alignment: AlignmentDirectional.topCenter,
                                      children: [
                                        Positioned(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                stops: [0.1, 0.9],
                                                colors: [
                                                  Color.fromARGB(255, 204, 0, 0),
                                                  Color.fromARGB(255, 153, 0, 51),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(0.0, 2.0),
                                                  blurRadius: 6.0,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 32.0, top: 128, right: 32, bottom: 32),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            pizza.name,
                                                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                                            softWrap: true,
                                                          ),
                                                          Text(
                                                            "${pizza.amount}",
                                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                      const Card(
                                                  color: Colors.transparent,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [Text("4.3"), Icon(Icons.star)],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 32,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                        )
                                ],
                              )
                                  ]
                                );
                              });
                          })).toList()
                        );
                      },
                    );
                  }).toList(),
            )
          )
          ])
    );
  }
}