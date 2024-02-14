import 'entity_interface.dart';

class OrderContent implements EntityInterface {
  OrderContent({
    required this.id,
    required this.name,
    required this.amount
  });

  @override
  factory OrderContent.fromMap(Map map) {
    return OrderContent(
      id: 9,
      name: map['name'],
      amount: map['price']
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
    };
  }

  late int id;
  late String name;
  late int amount;
}
