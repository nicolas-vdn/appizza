import 'package:dio/dio.dart';

import '../library/config.dart';

final api = Dio(
  BaseOptions(
    baseUrl: apiUrl,
  ),
);
