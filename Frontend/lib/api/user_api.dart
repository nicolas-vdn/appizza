import 'package:dio/dio.dart';

import 'api.dart';

class UserApi {
  static String url = "/user";

  static Future<Response> authenticate(String username, String password) async {
    return await api.post("$url/login", data: {'username': username, 'password': password});
  }

  static Future<Response> register(String username, String password) async {
    return await api.post("$url/register", data: {'username': username, 'password': password});
  }

  static setAuthHeader(String token) {
    api.options.headers.addAll({'authorization': "Bearer $token"});
  }

  static removeAuthHeader() {
    api.options.headers.remove('authorization');
  }
}
