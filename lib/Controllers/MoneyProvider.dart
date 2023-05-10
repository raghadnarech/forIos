import 'package:flutter/material.dart';
import 'package:qr_app/Models/Money.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qr_app/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneyProvider with ChangeNotifier {
  Money? money;
  List<Money> listmoney = [];
  bool isloadingmoney = false;
  bool isloadinggiveMoney = false;

  Future getMyMoney() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    isloadingmoney = true;
    notifyListeners();

    http.Response? response;
    try {
      response = await http.get(
        Uri.parse('$url/get-my-money'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      isloadingmoney = false;
      notifyListeners();
    }
    print(response!.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      listmoney = [];

      List<dynamic> data = jsonDecode(response.body);

      print(data);
      for (var i = 0; i < data.length; i++) {
        money = Money.fromJson(data[i]);
        listmoney.add(money!);
        print(listmoney.length);
      }

      isloadingmoney = false;
      notifyListeners();
    } else {
      isloadingmoney = false;
      notifyListeners();
    }
  }

  Future<bool> giveMoneyforUser(
      {String? userId,
      String? amount,
      String? amount_status,
      String? reason,
      String? date}) async {
    isloadinggiveMoney = true;
    notifyListeners();
    http.Response response;

    try {
      response = await http.post(Uri.parse('$url/give-money'), headers: {
        'Accept': 'application/json'
      }, body: {
        'user_id': userId,
        'amount': amount,
        'amount_status': amount_status,
        'reason': reason,
        'date': date,
      });
    } catch (e) {
      print(e);
      isloadinggiveMoney = false;
      notifyListeners();
      return false;
    }
    print(response.body);
    if (response.statusCode == 200) {
      isloadinggiveMoney = false;
      notifyListeners();
      return true;
    } else {
      isloadinggiveMoney = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> giveMoneyforUserAdvance({
    String? userId,
    String? amount,
    String? amount_status,
    String? date,
  }) async {
    isloadinggiveMoney = true;
    notifyListeners();
    http.Response response;

    try {
      response = await http.post(Uri.parse('$url/give-money'), headers: {
        'Accept': 'application/json'
      }, body: {
        'user_id': userId,
        'amount': amount,
        'amount_status': amount_status,
        'date': date,
      });
    } catch (e) {
      print(e);
      isloadinggiveMoney = false;
      notifyListeners();
      return false;
    }
    print(response.body);
    if (response.statusCode == 200) {
      isloadinggiveMoney = false;
      notifyListeners();
      return true;
    } else {
      isloadinggiveMoney = false;
      notifyListeners();
      return false;
    }
  }
}
