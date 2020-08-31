import 'dart:async';
import 'dart:convert';

import 'package:corona_mobile_app/screens/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../constants/constants.dart' as Constants;

import "package:corona_mobile_app/main.dart";

class Auth with ChangeNotifier {
  User _user;
  Timer _tokenExpirationTimer;

  String get token {
    return _user?.token;
  }

  Auth() {
    autoLogin();
  }

  Future<void> login(String username, String password) async {
    const baseUrl = Constants.baseUrl;

    final body = jsonEncode({
      "username": username,
      "password": password,
    });
    final response = await http.post(Uri.https(baseUrl, "api/login"),
        body: body, headers: {"Content-Type": "application/json"});

    if (response.statusCode >= 400) {
      throw ("Invalid credentials");
    }

    _user = User.fromJson(jsonDecode(response.body));
    _user.expiresIn += DateTime.now().millisecondsSinceEpoch;

    autoLogout();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        "user",
        jsonEncode({
          "token": _user.token,
          "username": _user.username,
          "expiresIn": _user.expiresIn,
        }));
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("user")) return;

    final user = User.fromJson(jsonDecode(prefs.getString("user")));
    if (user == null ||
        user.expiresIn < DateTime.now().millisecondsSinceEpoch) {
      return;
    }

    _user = user;
    notifyListeners();
    autoLogout();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove("user");
    _user = null;
    _tokenExpirationTimer?.cancel();

    await globalNavigatorKey.currentState
        .pushReplacementNamed(LoginScreen.routeName);

    notifyListeners();
  }

  void autoLogout() {
    _tokenExpirationTimer = Timer(
        Duration(
            milliseconds:
                _user.expiresIn - DateTime.now().millisecondsSinceEpoch),
        logout);
  }
}
