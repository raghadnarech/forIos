import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Views/Admin/EditTask.dart';
import 'package:qr_app/Views/Admin/ImagesTasks.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/constant/colors.dart';
import 'package:qr_app/constant/url.dart';

class TaskUser extends StatelessWidget {
  int? userid;
  TaskUser({this.userid});

  @override
  Widget build(BuildContext context) {
    employeeProvider = Provider.of<EmployeeProvider>(context);
    taskProvider = Provider.of<TaskProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("مهام الموظف"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: employeeProvider.loadinguserprofile
            ? SizedBox(
                height: height,
                child: Row(
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
                children: [
                  Text(
                    "المهام",
                    style: headStyle,
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Card(
                      elevation: 5,
                      child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text("المهمة"),
                            ),
                            DataColumn(
                              label: Text("الحالة"),
                            ),
                            DataColumn(
                              label: Text("الخيارات"),
                            ),
                          ],
                          rows: employeeProvider.profileUser!.task!
                              .map(
                                (e) => DataRow(cells: [
                                  DataCell(Text(e.task!)),
                                  DataCell(Text(e.status! == "repeated"
                                      ? "مكررة"
                                      : e.status! == "finished"
                                          ? "منتهية"
                                          : "غير منتهية")),
                                  DataCell(Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (e.status == "repeated") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImagesTasks(
                                                          task: e.listimage!),
                                                ));
                                          } else {
                                            if (e.status == "finished") {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.close),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            Divider(),
                                                            InstaImageViewer(
                                                                child: Image
                                                                    .network(
                                                              "$urlImage/${e.image!}",
                                                            )),
                                                          ],
                                                        ),
                                                      ));
                                            } else {
                                              Flushbar(
                                                duration: Duration(seconds: 3),
                                                backgroundColor: Colors.red,
                                                title: "المهمة غير منتهية",
                                                message:
                                                    "المهمة غير منتهية, لايوجد صورة لعرضها",
                                              ).show(context);
                                            }
                                          }
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      VerticalDivider(
                                        color: Colors.transparent,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          print(e.id);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditTask(
                                                    status: e.status!,
                                                    task: e.task,
                                                    taskid: e.id,
                                                    userid: userid),
                                              ));
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      VerticalDivider(
                                        color: Colors.transparent,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: Text(
                                                  "هل أنت متأكد من حذف هذه المهمة"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      if (await taskProvider
                                                          .deleteTask(e.id!)) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              "تم حذف المهمة بنجاح"),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ));
                                                        employeeProvider
                                                            .getUserProfile(
                                                                userid);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text("نعم")),
                                                TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("خروج"))
                                              ],
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )),
                                ]),
                              )
                              .toList()),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
