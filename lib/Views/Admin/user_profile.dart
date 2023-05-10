import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Views/Admin/EditUserProfile.dart';
import 'package:qr_app/Views/Admin/HomePageAdmin.dart';
import 'package:qr_app/Views/Admin/MoneyUser.dart';
import 'package:qr_app/Views/Admin/TaskUser.dart';
import 'package:qr_app/Views/Admin/WorkTimeUser.dart';
import 'package:qr_app/Views/Admin/employee.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/SkelatonTable.dart';
import 'package:qr_app/Widgets/TextInput.dart';
import 'package:qr_app/constant/colors.dart';
import 'package:qr_app/constant/url.dart';

class UserProfile extends StatefulWidget {
  UserProfile(
      {this.userid,
      this.name,
      this.phone,
      this.dateTime,
      this.housing_allowance,
      this.number_idintity,
      this.other,
      this.salary,
      this.imageuser,
      this.total,
      this.transfer_allowance});
  int? userid;
  String? name;
  String? phone;
  String? number_idintity;
  String? dateTime;
  String? imageuser;
  var salary;
  var housing_allowance;
  var transfer_allowance;
  var other;
  var total;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    employeeProvider = Provider.of<EmployeeProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("الملف الشخصي للموظف"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: employeeProvider.loadinguserprofile
              ? SizedBox(
                  height: height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "معلومات الموظف",
                      style: headStyle,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "اسم الموظف: ",
                                style: contentStyle,
                              ),
                              Text(widget.name!),
                              Text(
                                "رقم الموظف: ",
                                style: contentStyle,
                              ),
                              Text(widget.phone!),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "الصورة الشخصية",
                              style: contentStyle,
                            ),
                            SizedBox(
                              height: height * 0.2,
                              width: width * 0.4,
                              child: widget.imageuser == null
                                  ? Center(
                                      child: Text("لم بتم إضافة صورة"),
                                    )
                                  : InstaImageViewer(
                                      child: Image.network(
                                          '$urlImage/${widget.imageuser}')),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Text(
                      "الخيارات",
                      style: headStyle,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskUser(userid: widget.userid),
                                    ));
                              },
                              icon: Icon(Icons.task_outlined),
                              label: Text("المهام")),
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MoneyUser(),
                                    ));
                              },
                              icon: Icon(Icons.monetization_on_outlined),
                              label: Text("المدفوعات")),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkTimeUser(
                                          name: widget.name,
                                          userid: widget.userid),
                                    ));
                              },
                              icon: Icon(Icons.work_history_outlined),
                              label: Text("جدول الدوام")),
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditUserProfile(
                                        dateTime: widget.dateTime,
                                        housing_allowance:
                                            widget.housing_allowance,
                                        name: widget.name,
                                        number_idintity: widget.number_idintity,
                                        other: widget.other,
                                        phone: widget.phone,
                                        salary: widget.salary,
                                        total: widget.total,
                                        transfer_allowance:
                                            widget.transfer_allowance,
                                        userid: widget.userid,
                                      ),
                                    ));
                              },
                              icon: Icon(Icons.edit),
                              label: Text("تعديل")),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
