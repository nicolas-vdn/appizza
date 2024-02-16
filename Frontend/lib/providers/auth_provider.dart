import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/user_api.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _username;

  String? get token => _token;
  String? get username => _username;

  bool isSignedIn() {
    return _token != null;
  }

  Future<void> register(String username, String password) async {
    await UserApi.register(username, password).then((response) async {
      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['authToken']);

        _token = response.data['authToken'];
        _username = username;
        UserApi.setAuthHeader(_token!);
      } else {
        throw Exception(response.data);
      }
    });
    notifyListeners();
  }

  Future<void> signIn(String username, String password) async {
    await UserApi.authenticate(username, password).then((response) async {
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['authToken']);

        _token = response.data['authToken'];
        _username = username;
        UserApi.setAuthHeader(_token!);
      } else {
        throw Exception(response.data);
      }
    });
    notifyListeners();
  }

  Future<void> localSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');

    if (_token != null) {
      UserApi.setAuthHeader(_token!);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    UserApi.removeAuthHeader();
    _token = null;
    _username = null;
    notifyListeners();
  }

  String? getUsername() {
    return _username;
  }
}
