import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _places = [
    {"name": "Paris", "x": 48.856478593796744, "y": 2.3394743644570393},
    {"name": "Reims", "x": 49.25777189138203, "y": 4.033475636155081},
    {"name": "Nantes", "x": 47.21955196479999, "y": -1.5541566482368003},
    {"name": "Lyon", "x": 45.76534612699939, "y": 4.836501386022323},
  ];

  LatLng _pickedPlace = const LatLng(48.856478593796744, 2.3394743644570393);
  String _pickedName = "Paris";

  List<Map<String, dynamic>> get places => _places;

  LatLng get pickedPlace => _pickedPlace;

  String get pickedName => _pickedName;

  void onChangedAddress(selectedPlaceName) {
    for (var place in places) {
      if (place["name"] == selectedPlaceName) {
        _pickedPlace = LatLng(place['x'], place['y']);
        _pickedName = place["name"];
      }
    }
    notifyListeners();
  }
}
