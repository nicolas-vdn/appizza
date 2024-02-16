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
    if (_list.keys.contains(item)) {
      if (_list[item]! < 10) {
        _list[item] = _list[item]! + 1;
        _total += item.price;
      }
    } else {
      _list[item] = 1;
      _total += item.price;
    }
    notifyListeners();
  }

  void removePizza(Pizza item) {
    if (_list.keys.contains(item)) {
      _list[item]! > 1 ? _list[item] = _list[item]! - 1 : _list.remove(item);
      _total -= item.price;
    }
    notifyListeners();
  }

  int quantityOf(Pizza pizza) {
    return _list[pizza] ?? 0;
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
