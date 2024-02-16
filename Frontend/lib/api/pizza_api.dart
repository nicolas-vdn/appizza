import 'package:dio/dio.dart';

import '../classes/models/pizza.dart';
import 'api.dart';

class PizzaApi {
  static String url = "/pizza";

  static Future<List<Pizza>> getCollection() async {
    Response response = await api.get(url);

    _jsonToDto(response);

    return response.data;
  }

  static void _jsonToDto(Response<dynamic> response) {
    List<Pizza> collection = [];
    for (Map<String, dynamic> entity in response.data) {
      collection.add(Pizza.fromMap(entity));
    }
    response.data = collection;
  }
}
