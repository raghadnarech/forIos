import 'package:intl/intl.dart';

class Employee {
  int? id;
  String? name;
  String? phone;
  String? number_idintity;
  String? dateTime;
  String? image;
  var salary;
  var housing_allowance;
  var transfer_allowance;
  var other;
  var total;
  Employee(
      {this.id,
      this.name,
      this.image,
      this.phone,
      this.dateTime,
      this.housing_allowance,
      this.number_idintity,
      this.other,
      this.salary,
      this.total,
      this.transfer_allowance});
  factory Employee.formJson(Map<String, dynamic> responsedata) {
    return Employee(
      id: responsedata['id'],
      name: responsedata['name'],
      phone: responsedata['phone'],
      dateTime: responsedata['expire_date'] ??
          DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      image: responsedata['image'],
      housing_allowance: responsedata['extra_for_house'] ?? 0,
      number_idintity: responsedata['num_of_card'] ?? "",
      other: responsedata['extra_for_other'] ?? 0,
      salary: responsedata['salary'] ?? 0,
      total: responsedata['total'] ?? 0,
      transfer_allowance: responsedata['extra_for_transport'] ?? 0,
    );
  }
}
