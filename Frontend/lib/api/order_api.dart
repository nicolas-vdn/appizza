import 'package:dio/dio.dart';
import 'package:frontend/classes/models/order.dart';

import 'api.dart';

class OrderApi {
  static String url = "/order";

  static Future<List<Order>> getCollection() async {
    var response = await api.get(url);

    _jsonToDto(response);

    return response.data;
  }

  static void _jsonToDto(Response<dynamic> response) {
    List<Order> collection = [];
    for (var entity in response.data) {
      collection.add(Order.fromMap(entity));
    }
    response.data = collection;
  }

  static Future<Response> launchOrder(Order order) async {
    var content = [];

    order.orderContent.forEach((key, value) {
      content.add({...key.toMap(), 'amount': value});
    });

    var newOrder = {
      'order_content': content,
      'price': order.price.toStringAsFixed(2),
    };

    return await api.post(url, data: {'order': newOrder});
  }
}
