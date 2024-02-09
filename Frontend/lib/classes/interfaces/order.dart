import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/interfaces/order_content.dart';

import 'entity_interface.dart';

class Order implements EntityInterface {
  Order({
    required this.id,
    required this.orderContent,
    required this.price
  });

  @override
    factory Order.fromMap(Map map) {
      List<OrderContent> test(List<dynamic> listDynamic) {
        List<OrderContent> list = [];
        listDynamic.forEach((jsonMap) => list.add(OrderContent(id: jsonMap['id'], name: jsonMap['name'], amount: jsonMap['amount'])));

        return list;
      }

      return Order(
          id: map['id'],
          orderContent: test(map['order_content']),
          price: double.parse(map['price'])
      );
    }

  // @override
  // factory Order.fromMap(Map map) {
  //   map['order_content'].forEach((e) => {
  //     print(map['order_content'].toString().runtimeType),
  //     print(json.decode(map['order_content'].toString()))
  //   });
  //   return Order(
  //       id: 7,
  //       orderContent: map['order_content'].map((e) => OrderContent.fromMap(map)).toList(),
  //       price: double.parse(map['price'])
  //   );
  // }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_content': orderContent,
      'price': price,
    };
  }

  late int id;
  late List<OrderContent> orderContent;
  late double price;
}
