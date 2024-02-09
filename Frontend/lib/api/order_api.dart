import 'package:dio/dio.dart';
import 'package:frontend/interfaces/order.dart';

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
}
