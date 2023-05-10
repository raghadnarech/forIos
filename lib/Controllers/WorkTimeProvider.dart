import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_app/Models/WorkTime.dart';
import 'package:qr_app/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WorkTimeProvider with ChangeNotifier {
  bool loadinglist = false;

  WorkTime? workTime;
  List<WorkTime> listworktime = [];
  Future<void> getMytime() async {
    loadinglist = true;
    notifyListeners();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse('$url/my-time'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      loadinglist = false;
      notifyListeners();
    }
    if (response!.statusCode == 200) {
      print(response.body);
      listworktime.clear();
      var data = jsonDecode(response.body);

      for (var i = 0; i < data.length; i++) {
        workTime = WorkTime.fromJson(data[i]);
        listworktime.add(workTime!);
        notifyListeners();
      }
      loadinglist = false;
      notifyListeners();
    } else {
      loadinglist = false;
      notifyListeners();
    }
  }
}
