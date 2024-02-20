import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../classes/models/place.dart';
import '../classes/models/place_search.dart';

class PlacesService {
  static String key = "AIzaSyCeByGeg-TQvA81HK_1oS2CqpPhZ_Bx1Tc";

  static Future<Iterable<PlaceSearch>?> getAutoComplete(String search) async {
    try {
      final response = await Dio()
          .get("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&key=$key&types=(cities)");

      List jsonResults = response.data['predictions'] as List;
      return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<Place?> getPlace(String placeId) async {
    try {
      final response =
          await Dio().get("https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key");

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResult = response.data['result'] as Map<String, dynamic>;
        return Place.fromJson(jsonResult);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}
