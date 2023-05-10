import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Views/Admin/HomePageAdmin.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/TextInput.dart';
import 'package:qr_app/constant/colors.dart';

class EditUserProfile extends StatefulWidget {
  EditUserProfile(
      {this.userid,
      this.name,
      this.phone,
      this.dateTime,
      this.housing_allowance,
      this.number_idintity,
      this.other,
      this.salary,
      this.total,
      this.transfer_allowance});
  int? userid;
  String? name;
  String? phone;
  String? number_idintity;
  String? dateTime;
  var salary;
  var housing_allowance;
  var transfer_allowance;
  var other;
  var total;

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

final dateController = TextEditingController();
final namecontroller = TextEditingController();
final phonecontroller = TextEditingController();
final salaryController = TextEditingController();
final housing_allowanceController = TextEditingController();
final number_idintityController = TextEditingController();
final otherController = TextEditingController();
final totalController = TextEditingController();
final transfer_allowanceController = TextEditingController();

class _EditUserProfileState extends State<EditUserProfile> {
  var total;
  var salary;
  var housing_allowance;
  var other;
  var transfer_allowance;
  sumtotal() {
    salary = num.tryParse(salaryController.text)?.toDouble() ?? 0;
    housing_allowance =
        num.tryParse(housing_allowanceController.text)?.toDouble() ?? 0;
    transfer_allowance =
        num.tryParse(transfer_allowanceController.text)?.toDouble() ?? 0;
    other = num.tryParse(otherController.text)?.toDouble() ?? 0;
    total = salary + housing_allowance + transfer_allowance + other;
    setState(() {
      totalController.text = total.toString();
    });
  }

  @override
  void initState() {
    sumtotal();
    namecontroller.text = widget.name!;
    phonecontroller.text = widget.phone!;
    salaryController.text = widget.salary!.toString();
    dateController.text = widget.dateTime!.toString();
    housing_allowanceController.text = widget.housing_allowance!.toString();
    number_idintityController.text = widget.number_idintity!.toString();
    otherController.text = widget.other!.toString();
    totalController.text = widget.total!.toString();
    transfer_allowanceController.text = widget.transfer_allowance!.toString();
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.clear();
    phonecontroller.clear();
    dateController.clear();
    salaryController.clear();
    housing_allowanceController.clear();
    transfer_allowanceController.clear();
    otherController.clear();
    totalController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sumtotal();
    employeeProvider = Provider.of<EmployeeProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("تعديل بيانات الموظف"),
          actions: [
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () async {
                    if (await employeeProvider.deleteUser(
                        userid: widget.userid)) {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: HomePageAdmin(),
                            isIos: false,
                            duration: Duration(milliseconds: 500),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("تم حذف الموظف بنجاح")));
                      await employeeProvider.getAllUsers();
                      namecontroller.clear();
                      phonecontroller.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("حدث خطأ، يرجى إعادة المحاولة")));
                    }
                  },
                  value: 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Text("حذف"),
                    ],
                  ),
                ),
              ],
              elevation: 2,
            ),
          ],
        ),
        body: employeeProvider.loadinguserprofile
            ? Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "معلومات الموظف",
                        style: headStyle,
                      ),
                      Divider(
                        color: Colors.transparent,
                      ),
                      Text(
                        "الاسم",
                        style: headStyle,
                      ),
                      TextInputForAll(
                        controller: namecontroller,
                      ),
                      Text(
                        "رقم الهاتف",
                        style: headStyle,
                      ),
                      TextInputForAll(
                        controller: phonecontroller,
                      ),
                      Text(
                        "رقم الهوية",
                        style: headStyle,
                      ),
                      TextInputForAll(
                        controller: number_idintityController,
                      ),
                      Text(
                        "تاريخ انتهاء الإقامة",
                        style: headStyle,
                      ),
                      TextInputForAll(
                        hint: "تاريخ انتهاء الإقامة",
                        controller: dateController,
                        type: TextInputType.datetime,
                      ),
                      Text(
                        "الراتب الأساسي",
                        style: headStyle,
                      ),
                      TextInputForAll(
                        controller: salaryController,
                      ),
                      Text(
                        "بدل السكن",
                        style: headStyle,
                      ),
                      TextInputForAll(
                        controller: housing_allowanceController,
                      ),
                      Text(
                        "بدل النقل",
                        style: headStyle,
                      ),
                      TextInputForAll(
                        controller: transfer_allowanceController,
                      ),
                      Text(
                        "بدلات أخرى",
                        style: headStyle,
                      ),
                      TextInputForAll(
                        controller: otherController,
                      ),
                      Text(
                        "المجموع",
                        style: headStyle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextInputForAll(
                              state: false,
                              hint: "المجموع",
                              controller: totalController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  sumtotal();
                                },
                                icon: Icon(Icons.add_circle_outline_outlined),
                                label: Text("حساب المجموع")),
                          )
                        ],
                      ),
                      Text(
                        "ملاحظة: سيتم احتساب مجموع الراتب إضافة للبدلات تلقائياً عند الضغط على زر حفظ",
                        style: TextStyle(color: Colors.red),
                      ),
                      Row(
                        children: [
                          employeeProvider.loadingedit
                              ? Expanded(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : Expanded(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (await employeeProvider.EditUser(
                                            name: namecontroller.text,
                                            phone: phonecontroller.text,
                                            userid: widget.userid,
                                            dateTime: dateController.text,
                                            housing_allowance:
                                                housing_allowanceController
                                                    .text,
                                            number_idintity:
                                                number_idintityController.text,
                                            other: otherController.text,
                                            salary: salaryController.text,
                                            total: totalController.text,
                                            transfer_allowance:
                                                transfer_allowanceController
                                                    .text)) {
                                          Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.fade,
                                                child: HomePageAdmin(),
                                                isIos: false,
                                                duration:
                                                    Duration(milliseconds: 500),
                                              ));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "تم تعديل بيانات الموظف بنجاح")));
                                          await employeeProvider.getAllUsers();
                                          namecontroller.clear();
                                          phonecontroller.clear();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "حدث خطأ، يرجى إعادة المحاولة")));
                                        }
                                      },
                                      child: Text("حفظ"))),
                        ],
                      ),
                    ]),
              )));
  }
}
