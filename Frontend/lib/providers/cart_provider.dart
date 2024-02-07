import 'package:flutter/material.dart';

import '../interfaces/pizza.dart';

class CartProvider extends ChangeNotifier {
  final Map<Pizza, int> _list = {};

  double _total = 0.0;

  Map<Pizza, int> get list => _list;

  double get total => double.parse(_total.toStringAsFixed(2));

  addPizza(Pizza item) {
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

  removePizza(Pizza item) {
    if (_list.keys.contains(item)) {
      _list[item]! > 1 ? _list[item] = _list[item]! - 1 : _list.remove(item);
      _total -= item.price;
    }
    notifyListeners();
  }

  quantityOf(Pizza pizza) {
    return _list[pizza] ?? 0;
  }
}
