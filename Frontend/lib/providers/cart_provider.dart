import 'package:flutter/material.dart';

import '../interfaces/pizza.dart';

class CartProvider extends ChangeNotifier {
  final Map<Pizza, int> _list = {
    Pizza(id: 1, name: "Reine", price: 10.0): 1,
    Pizza(id: 2, name: "4 fromages", price: 11.50): 1,
  };

  double _total = 21.50;

  Map<Pizza, int> get list => _list;

  double get total => _total;

  addPizza(Pizza item) {
    _list[item] = _list.keys.contains(item) ? _list[item]! + 1 : 1;
    _total += item.price;
  }

  removePizza(Pizza item) {
    if (_list.keys.contains(item)) {
      _list[item]! > 1 ? _list[item] = _list[item]! - 1 : _list.remove(item);
      _total -= item.price;
    }
  }
}
