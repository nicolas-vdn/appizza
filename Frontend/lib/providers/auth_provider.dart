import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/user_api.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  final bool _error = false;

  String? get token => _token;

  bool get error => _error;

  bool isSignedIn() {
    return _token != null ? true : false;
  }

  Future<void> signIn(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1), () {
      _token = "token";
    });

    notifyListeners();

    /*await UserApi.authenticate(username, password).then((response) async {
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('refresh_token', response.data['refresh_token']);
        await prefs.setString('token', response.data['token']);

        _token = response.data['token'];
        UserApi.setAuthHeader(_token!);
      } else {
        throw Exception(response.data);
      }
    });*/
  }

  Future<void> localSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');

    if (_token != null) {
      UserApi.setAuthHeader(_token!);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('refresh_token');
    await prefs.remove('token');
    _token = null;
  }
}
