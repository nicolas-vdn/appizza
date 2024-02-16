import 'package:flutter/material.dart';

import '../../classes/models/pizza.dart';

class ListTileItem extends StatelessWidget {
  const ListTileItem({
    super.key,
    required this.item,
    required this.constant,
  });

  final MapEntry<Pizza, int> item;
  final bool constant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("${item.value} x",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: constant ? Colors.white : null,
          )),
      title: Text(item.key.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: constant ? Colors.white : null,
          )),
      trailing: Text("${(item.key.price * item.value).toStringAsFixed(2)} €",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: constant ? Colors.white : null,
          )),
      subtitle: Text("${item.key.price.toStringAsFixed(2)} €",
          style: TextStyle(
            color: constant ? Colors.white : null,
          )),
    );
  }
}
