import 'package:frontend/classes/models/pizza.dart';

import 'entity_interface.dart';

class Order implements EntityInterface {
  Order({this.id, required this.orderContent, required this.price});

  @override
  factory Order.fromMap(Map map) {
    Map<Pizza, int> mapOrder(List<dynamic> listDynamic) {
      Map<Pizza, int> list = {};
      for (var jsonMap in listDynamic) {
        list[Pizza(
            id: jsonMap['id'],
            name: jsonMap['name'],
            price: double.parse(jsonMap['price']),
            note: double.parse(jsonMap['note']),
            url: jsonMap['image_url'])] = jsonMap['amount'];
      }
      return list;
    }

    return Order(id: map['id'], orderContent: mapOrder(map['order_content']), price: double.parse(map['price']));
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_content': orderContent,
      'price': price,
    };
  }

  late int? id;
  late Map<Pizza, int> orderContent;
  late double price;
}
