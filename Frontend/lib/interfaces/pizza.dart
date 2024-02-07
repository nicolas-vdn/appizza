import 'entity_interface.dart';

class Pizza implements EntityInterface {
  Pizza({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  factory Pizza.fromMap(Map map) {
    return Pizza(
      id: map['id'],
      name: map['name'],
      price: double.parse(map['price']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  late int id;
  late String name;
  late double price;
}
