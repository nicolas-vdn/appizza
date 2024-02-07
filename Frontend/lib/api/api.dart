import 'package:dio/dio.dart';

import '../library/config.dart';

final api = Dio(
  BaseOptions(baseUrl: apiUrl, headers: {'Content-Type': 'application/json'}),
)..interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        return handler.next(error);
      },
    ),
  );
