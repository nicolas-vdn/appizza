import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _places = [
    {"name": "Paris", "LatLng": const LatLng(48.856478593796744, 2.3394743644570393)},
    {"name": "Reims", "LatLng": const LatLng(49.25777189138203, 4.033475636155081)},
    {"name": "Nantes", "LatLng": const LatLng(47.21955196479999, -1.5541566482368003)},
    {"name": "Lyon", "LatLng": const LatLng(45.76534612699939, 4.836501386022323)},
  ];

  Map<String, dynamic> _pickedPlace = {"name": "Paris", "LatLng": const LatLng(48.856478593796744, 2.3394743644570393)};

  List<Map<String, dynamic>> get places => _places;

  Map<String, dynamic> get pickedPlace => _pickedPlace;

  void onChangedAddress(selectedPlaceName) {
    for (var place in _places) {
      if (place["name"] == selectedPlaceName) {
        _pickedPlace = place;
      }
    }
    notifyListeners();
  }
}
