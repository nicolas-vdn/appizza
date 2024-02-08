abstract interface class EntityInterface {
  EntityInterface();

  EntityInterface.fromMap(Map map);

  Map<String, dynamic> toMap();
}
