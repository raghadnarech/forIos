import 'package:qr_app/Models/Money.dart';
import 'package:qr_app/Models/Task.dart';
import 'package:qr_app/Models/WorkTime.dart';

class ProfileUser {
  String? name;
  String? phone;
  String? image;
  List<Task>? task;
  List<Money>? money;
  List<WorkTime>? workTime;

  ProfileUser(
      {this.money,
      this.name,
      this.image,
      this.phone,
      this.task,
      this.workTime});
  factory ProfileUser.fromJson(
      {Map<String, dynamic>? responsedata,
      List<Money>? money,
      List<Task>? task,
      List<WorkTime>? workTime}) {
    return ProfileUser(
        name: responsedata!['user_name'],
        phone: responsedata['user_phone'],
        image: responsedata['user_image'],
        money: money,
        task: task,
        workTime: workTime);
  }
}
