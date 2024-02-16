import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/order_api.dart';
import 'package:frontend/classes/models/order.dart';

import '../classes/models/pizza.dart';

class CartProvider extends ChangeNotifier {
  final Map<Pizza, int> _list = {};

  double _total = 0.0;

  Map<Pizza, int> get list => _list;

  double get total => double.parse(_total.toStringAsFixed(2));

  void addPizza(Pizza item) {
    try {
      Pizza pizza = _list.keys.singleWhere((element) => element.id == item.id);

      if (_list[pizza]! < 10) {
        _list[pizza] = _list[pizza]! + 1;
        _total += pizza.price;
      }
    } catch (e) {
      _list[item] = 1;
      _total += item.price;
    }
    notifyListeners();
  }

  void removePizza(int id) {
    try {
      Pizza? pizza = _list.keys.singleWhere((element) => element.id == id);
      _list[pizza]! > 1 ? _list[pizza] = _list[pizza]! - 1 : _list.remove(pizza);
      _total -= pizza.price;
    } catch (e) {
      //Ignore
    }
    notifyListeners();
  }

  int quantityOf(int id) {
    try {
      Pizza pizza = _list.keys.singleWhere((element) => element.id == id);
      return _list[pizza]!;
    } catch (e) {
      return 0;
    }
  }

  int totalQuantity() {
    int total = 0;
    _list.forEach((key, value) => total += value);
    return total;
  }

  void emptyCart() {
    _list.clear();
    _total = 0;
    notifyListeners();
  }

  Future<bool> createOrder() async {
    Order order = Order(orderContent: _list, price: _total);
    Response response = await OrderApi.postOrder(order);

    if (response.statusCode == 201) {
      emptyCart();
      return true;
    } else {
      throw Exception(response.data);
    }
  }
}
