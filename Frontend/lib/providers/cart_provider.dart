import 'package:flutter/material.dart';

import '../interfaces/pizza.dart';

class CartProvider extends ChangeNotifier {
  final Map<Pizza, int> _list = {
  };

  double _total = 0.0;

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

  getQuantityOfPizza(Pizza givenPizza){
    if (_list.containsKey(givenPizza)) {
      return _list[givenPizza]!;
    } else {
      return 0;
    }
  }

}
