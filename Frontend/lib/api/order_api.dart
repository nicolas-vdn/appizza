import 'package:dio/dio.dart';
import 'package:frontend/classes/models/order.dart';

import '../classes/models/pizza.dart';
import 'api.dart';

class OrderApi {
  static String url = "/order";

  static Future<List<Order>> getCollection() async {
    Response response = await api.get(url);

    _jsonToDto(response);

    return response.data;
  }

  static void _jsonToDto(Response<dynamic> response) {
    List<Order> collection = [];
    for (Map<String, dynamic> entity in response.data) {
      collection.add(Order.fromMap(entity));
    }
    response.data = collection;
  }

  static Future<Response> postOrder(Order order) async {
    List<Map<String, dynamic>> content = [];

    order.orderContent.forEach((Pizza key, int value) {
      content.add({...key.toMap(), 'amount': value});
    });

    Map<String, dynamic> orderDto = {
      'order_content': content,
      'price': order.price.toStringAsFixed(2),
    };

    return await api.post(url, data: {'order': orderDto});
  }
}
