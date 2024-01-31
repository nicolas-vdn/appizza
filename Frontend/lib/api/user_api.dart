import 'package:dio/dio.dart';
import 'api.dart';

class UserApi {
  static Future<Response> authenticate(String username, String password) async {
    return await api.post('/login_check', data: {'username': username, 'password': password});
  }

  static setAuthHeader(String token) {
    api.options.headers.addAll({'authorization-header': token});
  }
}
