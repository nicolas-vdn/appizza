import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {
  final List<Object> _places = [
    {"name": "Paris", "x": 48.856478593796744, "y": 2.3394743644570393},
    {"name": "Valenciennes", "x": 50.325010503819925, "y": 3.540289112212073},
    {"name": "Nantes", "x": 47.21955196479999, "y": -1.5541566482368003},
    {"name": "Lyon", "x": 45.76534612699939, "y": 4.836501386022323},
  ];

  LatLng _pickedPlace = LatLng(48.856478593796744, 2.3394743644570393);


  List<Object> get places => _places;
  LatLng get pickedPlace => _pickedPlace;

  void onChangedAddress(place){
    _pickedPlace = LatLng(place['x'], place['y']);
    notifyListeners();
  }
}
