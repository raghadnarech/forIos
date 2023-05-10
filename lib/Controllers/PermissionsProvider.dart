import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_app/Models/Permissions.dart';
import 'package:qr_app/Models/UserPermmision.dart';
import 'package:qr_app/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PermissionsProvider with ChangeNotifier {
  Permission permission = Permission();
  PermissionUser permissionUser = PermissionUser();
  List<Permission> listpermmision = [];
  List<PermissionUser> listpermmisionuser = [];
  List<Permission> listwaitpermmision = [];
  List<Permission> listdenpermmision = [];
  List<Permission> listaccpermmision = [];
  int countwait = 0;
  bool loadingsendSatisf = false;
  bool loadingsendPersonal = false;
  bool loadinggetPermissin = false;
  bool loadingacc_rej = false;
  bool loadinggetper = false;
  Future getAllPermmision() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    loadinggetPermissin = true;
    notifyListeners();
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse('$url/get-permissions'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      loadinggetPermissin = false;
      notifyListeners();
    }
    if (response!.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      countwait = 0;
      listpermmision.clear();
      listwaitpermmision.clear();
      listaccpermmision.clear();
      listdenpermmision.clear();

      print(data);
      for (var i = 0; i < data.length; i++) {
        permission = Permission.fromJson(data[i]);
        if (permission.status == 0) {
          listwaitpermmision.add(permission);
          countwait++;
          notifyListeners();
        } else if (permission.status == 1) {
          listaccpermmision.add(permission);
          notifyListeners();
        } else {
          listdenpermmision.add(permission);
          notifyListeners();
        }
        listpermmision.add(permission);
        notifyListeners();
      }
      listaccpermmision = listaccpermmision.reversed.toList();
      notifyListeners();

      listwaitpermmision = listwaitpermmision.reversed.toList();
      notifyListeners();

      listdenpermmision = listdenpermmision.reversed.toList();
      notifyListeners();

      listpermmision = listpermmision.reversed.toList();
      notifyListeners();

      loadinggetPermissin = false;
      notifyListeners();
    } else {
      loadinggetPermissin = false;
      notifyListeners();
    }
  }

  Future<bool> accrejper({int? status, int? idper, String? hours}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    loadingacc_rej = true;
    notifyListeners();
    http.Response response;
    try {
      response = await http.post(Uri.parse('$url/acc-rej/$idper'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }, body: {
        'status': status.toString(),
        'hours': hours.toString()
      });
      print(response.body);
    } catch (e) {
      print(e);

      loadingacc_rej = false;
      notifyListeners();
      return false;
    }

    if (response.statusCode == 200) {
      print(response.body);
      loadingacc_rej = false;
      notifyListeners();
      getAllPermmision();
      return true;
    } else {
      print(response.body);

      loadingacc_rej = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> accrejsat({int? status, int? idper, String? days}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    loadingacc_rej = true;
    notifyListeners();
    http.Response response;
    try {
      response = await http.post(Uri.parse('$url/acc-rej/$idper'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }, body: {
        'status': status.toString(),
        'days': days.toString()
      });
      print(response.body);
    } catch (e) {
      print(e);

      loadingacc_rej = false;
      notifyListeners();
      return false;
    }

    if (response.statusCode == 200) {
      print(response.body);
      loadingacc_rej = false;
      notifyListeners();
      getAllPermmision();
      return true;
    } else {
      print(response.body);

      loadingacc_rej = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getMyPer() async {
    loadinggetper = true;
    notifyListeners();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse('$url/get-my-permissions'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
    } catch (e) {
      print(response!.body);
      loadinggetper = false;
      notifyListeners();
    }
    if (response.statusCode == 200) {
      print(response.body);
      listpermmisionuser.clear();
      var data = jsonDecode(response.body);

      for (var i = 0; i < data.length; i++) {
        permissionUser = PermissionUser.fromJson(data[i]);
        listpermmisionuser.add(permissionUser);
        notifyListeners();
      }
      listpermmisionuser = listpermmisionuser.reversed.toList();
      notifyListeners();
      loadinggetper = false;
      notifyListeners();
    } else {
      print(response.body);

      loadinggetper = false;
      notifyListeners();
    }
  }

  Future<bool> SatisfactoryPermissionSent({File? image, String? days}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    loadingsendSatisf = true;
    notifyListeners();
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$url/send-per'));
      request.headers.addAll(headers);
      request.fields.addAll({'kind': 'satisfactory', 'days': days!});
      request.files
          .add(await http.MultipartFile.fromPath('image', image!.path));
      var response = await request.send();
      // response.stream.transform(utf8.decoder).listen((value) {
      //   print(value);
      // });
      // print(response.reasonPhrase);
      // print(response.statusCode);
      // return false;
      if (response.statusCode == 200) {
        loadingsendSatisf = false;
        notifyListeners();
        getMyPer();
        return true;
      } else {
        loadingsendSatisf = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      loadingsendSatisf = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> PersonalPermissionSent(
      {String? date, String? hours, String? reason}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    loadingsendPersonal = true;
    notifyListeners();
    http.Response response;
    try {
      response = await http.post(Uri.parse('$url/send-per'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }, body: {
        'kind': 'personal',
        'date': date,
        'hours': hours,
        'reason': reason
      });
    } catch (e) {
      loadingsendPersonal = false;
      notifyListeners();
      return false;
    }
    if (response.statusCode == 200) {
      loadingsendPersonal = false;
      notifyListeners();
      getMyPer();

      return true;
    } else {
      loadingsendPersonal = false;
      notifyListeners();
      return false;
    }
  }
}
