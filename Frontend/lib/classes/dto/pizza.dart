import 'entity_interface.dart';

class Pizza implements EntityInterface {
  Pizza({
    required this.id,
    required this.name,
    required this.price,
    required this.note,
    required this.url,
  });

  @override
  factory Pizza.fromMap(Map map) {
    return Pizza(id: map['id'], name: map['name'], price: double.parse(map['price']), note: double.parse(map['note']), url: map['image_url']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,
    };
  }

  late int id;
  late String name;
  late double price;
  late double note;
  late String url;
}
