
import 'dart:convert';

import 'package:frontend/classes/models/auto_complete_prediction.dart';

class PlaceAutoCompleteResponse {
  final String? status;
  final List<AutoCompletePrediction>? predictions;

  PlaceAutoCompleteResponse({this.status, this.predictions});

  factory PlaceAutoCompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutoCompleteResponse(
      status: json['status'] as String?,
      predictions: json['predictions'] != null
        ? json['predictions']
          .map<AutoCompletePrediction>(
            (json) => AutoCompletePrediction.fromJson(json))
          .toList()
        : null,
    );
  }

  static PlaceAutoCompleteResponse parseAutoCompleteResult(
    String responseBody) {
      final parsed = jsonDecode(responseBody).cast<String, dynamic>();

      return PlaceAutoCompleteResponse.fromJson(parsed);
    }
}