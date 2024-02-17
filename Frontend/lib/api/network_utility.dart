
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkUtility {
  static Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await Dio(BaseOptions(headers: headers)).getUri(uri);

      if (response.statusCode == 200) {
        return response.data.toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}