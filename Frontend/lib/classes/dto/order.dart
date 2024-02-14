import 'package:frontend/classes/dto/order_content.dart';

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
      for (var jsonMap in listDynamic) {
        list.add(OrderContent(id: jsonMap['id'], name: jsonMap['name'], amount: jsonMap['amount']));
      }

      return list;
    }

    return Order(
        id: map['id'],
        orderContent: test(map['order_content']),
        price: double.parse(map['price'])
    );
  }

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
  late bool isExpanded = false;
}
