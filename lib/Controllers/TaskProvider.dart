import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_app/Models/Task.dart';
import 'package:qr_app/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider with ChangeNotifier {
  Task? task;
  bool loadinglist = false;
  bool loadingfinish = false;
  bool loadingdelete = false;
  bool loadinggivetask = false;
  bool loadingedittask = false;
  List<Task> listTasks = [];

  Future getMyTask() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    print(token);
    loadinglist = true;
    notifyListeners();
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('$url/get-my-tasks'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      loadinglist = false;
      notifyListeners();
      return false;
    }
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      listTasks.clear();
      List<Map> list = [];

      print(data);
      for (var i = 0; i < data.length; i++) {
        task = Task.formJson(data[i], list);
        listTasks.add(task!);
      }

      loadinglist = false;
      notifyListeners();
      return true;
    } else {
      loadinglist = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> taskfinished(
      {int? taskid, String? repeated, File? image}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    loadingfinish = true;
    notifyListeners();

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response;
    if (repeated == "repeated") {
      try {
        var request =
            http.MultipartRequest('POST', Uri.parse('$url/task-image/$taskid'));
        request.headers.addAll(headers);

        request.files
            .add(await http.MultipartFile.fromPath('image', image!.path));
        response = await request.send();
        if (response!.statusCode == 200) {
          loadingfinish = false;
          notifyListeners();
          return true;
        } else {
          loadingfinish = false;
          notifyListeners();
          return false;
        }
      } catch (e) {
        loadingfinish = false;
        notifyListeners();
        return false;
      }
    } else {
      try {
        print(taskid);
        var request = http.MultipartRequest(
            'POST', Uri.parse('$url/task-finished/$taskid'));
        request.headers.addAll(headers);

        request.files
            .add(await http.MultipartFile.fromPath('image', image!.path));
        response = await request.send();
        if (response!.statusCode == 200) {
          loadingfinish = false;
          notifyListeners();
          return true;
        } else {
          loadingfinish = false;
          notifyListeners();
          return false;
        }
      } catch (e) {
        // print(e);
        loadingfinish = false;
        notifyListeners();
        return false;
      }
    }
  }

  Future<bool> deleteTask(int taskid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    loadingdelete = true;
    notifyListeners();
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('$url/task-delete/$taskid'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print(e);
      loadingdelete = false;
      notifyListeners();
      return false;
    }
    print(response.body);
    if (response.statusCode == 200) {
      loadingdelete = false;
      notifyListeners();
      return true;
    } else {
      loadingdelete = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> givetaskforuser(
      {String? userid, String? task, bool? repeated}) async {
    loadinggivetask = true;
    notifyListeners();
    http.Response response;
    try {
      if (repeated!) {
        response = await http.post(Uri.parse('$url/give-task'),
            headers: {'Accept': 'application/json'},
            body: {'user_id': userid, 'task': task, 'status': "repeated"});
      } else {
        response = await http.post(Uri.parse('$url/give-task'),
            headers: {'Accept': 'application/json'},
            body: {'user_id': userid, 'task': task, 'status': "not finished"});
      }
    } catch (e) {
      loadinggivetask = false;
      notifyListeners();
      return false;
    }
    if (response.statusCode == 200) {
      loadinggivetask = false;
      notifyListeners();
      return true;
    } else {
      loadinggivetask = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> edit_task(
      {String? userid, String? task, int? taskid, bool? repeated}) async {
    loadingedittask = true;
    notifyListeners();
    print(userid);
    print(task);
    print(taskid);
    print(repeated);
    http.Response response;
    try {
      if (repeated!) {
        response = await http.post(Uri.parse('$url/task-update/$taskid'),
            headers: {'Accept': 'application/json'},
            body: {'user_id': userid, 'task': task, 'status': "repeated"});
      } else {
        response = await http.post(Uri.parse('$url/task-update/$taskid'),
            headers: {'Accept': 'application/json'},
            body: {'user_id': userid, 'task': task, 'status': "not repeated"});
      }
    } catch (e) {
      loadingedittask = false;
      notifyListeners();
      print(e);
      return false;
    }
    print(response.body);

    if (response.statusCode == 200) {
      loadingedittask = false;
      notifyListeners();
      return true;
    } else {
      loadingedittask = false;
      notifyListeners();
      return false;
    }
  }
}
