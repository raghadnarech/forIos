import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/Models/Employee.dart';
import 'package:qr_app/Models/Money.dart';
import 'package:qr_app/Models/ProfileUser.dart';
import 'package:qr_app/Models/Task.dart';
import 'package:qr_app/Models/WorkTime.dart';
import 'package:qr_app/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeProvider with ChangeNotifier {
  Employee? employee;
  Task? task;
  List<Task> listtask = [];
  List<Money> listmoney = [];
  List<WorkTime> listworkTime = [];
  WorkTime? workTime;
  Money? money;
  ProfileUser? profileUser;
  List<Employee> listemployee = [];
  bool isloadingscan = false;
  bool isloadingadd = false;
  bool loadinglist = false;
  bool loaddelete = false;
  bool loadinguserprofile = false;
  bool loadingedit = false;
  bool loadDownloadExcel = false;
  bool isin = false;
  bool isout = false;
  Future<bool> addEmployee(
      {String? name,
      String? phone,
      String? password,
      var housing_allowance,
      var transfer_allowance,
      var other,
      var salary,
      String? dateTime,
      var total,
      String? number_idintity,
      File? image}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    isloadingadd = true;
    notifyListeners();
    print(housing_allowance);
    print(transfer_allowance);
    print(other);
    dynamic response;
    try {
      var request =
          await http.MultipartRequest('POST', Uri.parse('$url/add-emp'));
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      request.fields.addAll({
        'name': name.toString(),
        'phone': phone.toString(),
        'password': password.toString(),
        'salary': salary,
        'num_of_card': number_idintity.toString(),
        'extra_for_house': housing_allowance,
        'total': total,
        'extra_for_transport': transfer_allowance,
        'expire_date': dateTime.toString(),
        'extra_for_other': other,
      });
      request.files
          .add(await http.MultipartFile.fromPath('image', image!.path));
      response = await request.send();
      if (response.statusCode == 200) {
        isloadingadd = false;
        notifyListeners();
        await getAllUsers();
        return true;
      } else {
        isloadingadd = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isloadingadd = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> EditUser({
    String? name,
    String? phone,
    int? userid,
    var housing_allowance,
    var transfer_allowance,
    var other,
    var salary,
    String? dateTime,
    var total,
    String? number_idintity,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    loadingedit = true;
    notifyListeners();
    http.Response response;
    try {
      response = await http.post(Uri.parse('$url/edit-emp/$userid'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }, body: {
        'name': name.toString(),
        'phone': phone.toString(),
        'salary': salary,
        'num_of_card': number_idintity,
        'extra_for_house': housing_allowance,
        'total': total,
        'extra_for_transport': transfer_allowance,
        'expire_date': dateTime,
        'extra_for_other': other,
      });
    } catch (e) {
      loadingedit = false;
      notifyListeners();
      return false;
    }
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      loadingedit = false;
      notifyListeners();
      return true;
    } else {
      loadingedit = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser({int? userid}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    loaddelete = true;
    notifyListeners();
    http.Response response;
    try {
      response =
          await http.post(Uri.parse('$url/delete-emp/$userid'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
    } catch (e) {
      loaddelete = false;
      notifyListeners();
      return false;
    }
    print(response.statusCode);

    if (response.statusCode == 200) {
      loaddelete = false;
      notifyListeners();
      return true;
    } else {
      loaddelete = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getExcelWorktime({int? userid, String? name}) async {
    await [Permission.storage].request();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    loadDownloadExcel = true;
    notifyListeners();
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('$url/emp-export/$userid'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      loadDownloadExcel = false;
      notifyListeners();
      return false;
    }
    if (response.statusCode == 200) {
      Directory? directory;
      directory = Directory('/storage/emulated/0/Download');
      print(directory);
      print(name);
      final excel = File('${directory.path}/$name.xlsx');
      excel.writeAsBytesSync(response.bodyBytes, mode: FileMode.write);
      loadDownloadExcel = false;
      notifyListeners();
      return true;
    }
    loadDownloadExcel = false;
    notifyListeners();
    return false;
  }

  Future getAllUsers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    loadinglist = true;
    notifyListeners();

    http.Response? response;
    try {
      response = await http.get(
        Uri.parse('$url/get-emp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      loadinglist = false;
      notifyListeners();
    }
    if (response!.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      listemployee.clear();

      print(data);
      for (var i = 0; i < data.length; i++) {
        employee = Employee.formJson(data[i]);
        listemployee.add(employee!);
        notifyListeners();
      }
      loadinglist = false;
      notifyListeners();
    } else {
      loadinglist = false;
      notifyListeners();
    }
  }

  Future getUserProfile(int? user_id) async {
    listtask = [];
    listmoney = [];
    listworkTime = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    loadinguserprofile = true;
    notifyListeners();
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse('$url/user-profile/$user_id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      loadinguserprofile = false;
      notifyListeners();
    }
    print(response!.body);
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      List<dynamic> listtaskjson = data["data"][0]['user_task'];
      // add id task for all tasks returned in userprofile Api
      List<Map> list = [];

      print(listtaskjson);
      for (var i = 0; i < listtaskjson.length; i++) {
        if (listtaskjson[i]['status'] == "repeated") {
          for (var j in listtaskjson[i]['multi']) {
            list.add(j);
          }
        }
        task = await Task.formJson(listtaskjson[i], list);
        listtask.add(task!);
        notifyListeners();
      }
      print(data);
      List<dynamic> listmoneyjson = data["data"][0]['user_money'];
      for (var i = 0; i < listmoneyjson.length; i++) {
        money = await Money.fromJson(listmoneyjson[i]);
        listmoney.add(money!);
        notifyListeners();
      }
      List<dynamic> listworktimejson = data["data"][0]['user_reg'];
      for (var i = 0; i < listworktimejson.length; i++) {
        workTime = await WorkTime.fromJson(listworktimejson[i]);
        listworkTime.add(workTime!);
        notifyListeners();
      }
      profileUser = await ProfileUser.fromJson(
          responsedata: data["data"][0],
          money: listmoney,
          task: listtask,
          workTime: listworkTime);
      loadinguserprofile = false;
      notifyListeners();
    } else {
      loadinguserprofile = false;
      notifyListeners();
    }
  }

  Future<bool> takeEnterTime(Barcode barcode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    await [Permission.camera].request();
    isloadingscan = true;
    http.Response response;
    try {
      response = await http.post(Uri.parse('$url/take-time'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }, body: {
        'date': barcode.rawValue,
        'status': "in"
      });
    } catch (e) {
      isloadingscan = false;
      notifyListeners();
      return false;
    }
    print(response.body);
    if (response.statusCode == 200) {
      isin = true;
      notifyListeners();
      isloadingscan = false;
      notifyListeners();
      return true;
    } else {
      isloadingscan = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> takeOutTime(Barcode barcode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    await [Permission.camera].request();
    isloadingscan = true;
    http.Response response;
    try {
      response = await http.post(Uri.parse('$url/take-time'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }, body: {
        'date': barcode.rawValue,
        'status': "out"
      });
    } catch (e) {
      isloadingscan = false;
      notifyListeners();
      return false;
    }
    print(response.body);
    if (response.statusCode == 200) {
      isout = true;
      notifyListeners();
      isloadingscan = false;
      notifyListeners();
      return true;
    } else {
      isloadingscan = false;
      notifyListeners();
      return false;
    }
  }
}
