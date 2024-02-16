import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/order_api.dart';
import 'package:frontend/api/pizza_api.dart';
import 'package:frontend/classes/models/order.dart';

import '../classes/models/pizza.dart';

class CartProvider extends ChangeNotifier {
  final Map<Pizza, int> _list = {};

  double _total = 0.0;

  Map<Pizza, int> get list => _list;

  double get total => double.parse(_total.toStringAsFixed(2));

  void addPizza(Pizza item) {
    Pizza? pizza = getPizzaById(item.id);
    if (pizza != null) {
      if (_list[pizza]! < 10) {
        _list[pizza] = _list[pizza]! + 1;
        _total += pizza.price;
      }
    } else {
      _list[item] = 1;
      _total += item.price;
    }
    notifyListeners();
  }

  void removePizza(Pizza item) {
    Pizza? pizza = getPizzaById(item.id);
    if (pizza != null) {
      _list[pizza]! > 1 ? _list[pizza] = _list[pizza]! - 1 : _list.remove(pizza);
      _total -= pizza.price;
    }
    notifyListeners();
  }

  int quantityOf(Pizza pizza) {
    return _list[getPizzaById(pizza.id)] ?? 0;
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

  Pizza? getPizzaById(int id) {
    Pizza? element;
    _list.forEach((key, value) {
      if (key.id == id) {
        element = key;
      }
    });

    return element;
  }
}
