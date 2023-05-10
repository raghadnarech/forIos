import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/Models/User.dart';
import 'package:http/http.dart' as http;
import 'package:qr_app/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? user;
  bool lodinglogin = false;

  Future<int> login({String? phone, String? password, String? uuid}) async {
    lodinglogin = true;
    notifyListeners();

    http.Response response;
    try {
      response = await http.post(
        Uri.parse('$url/user-login'),
        headers: {'Accept': 'application/json'},
        body: {'phone': phone, 'password': password, 'uuid': uuid},
      );
    } catch (e) {
      lodinglogin = false;
      notifyListeners();
      return 500;
    }
    print(response.body);
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      user = User.fromJson(data);
      saveUser(user!);
      lodinglogin = false;
      notifyListeners();
      return 200;
    } else if (response.body == "\"phone or password incorrect\"") {
      lodinglogin = false;
      notifyListeners();
      return 400;
    } else if (response.body == "\"this is not your device\"") {
      lodinglogin = false;
      notifyListeners();
      return 422;
    } else {
      lodinglogin = false;
      notifyListeners();
      return 500;
    }
  }

  Future<void> logout() async {
    removeuser();
  }

  saveUser(User usershared) async {
    SharedPreferences? preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', usershared.token!);
    await preferences.setBool('role', usershared.role!);
  }

  removeuser() async {
    SharedPreferences? preferences = await SharedPreferences.getInstance();
    await preferences.remove('token');
    await preferences.remove('role');
    await preferences.remove("isLogged");
    user = User();
    debugPrint("Logout Successfuly");
  }
}
