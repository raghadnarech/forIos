import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/TextInput.dart';

class PersonalPermissions extends StatefulWidget {
  const PersonalPermissions({super.key});

  @override
  State<PersonalPermissions> createState() => _PersonalPermissionsState();
}

final datepersonalController = TextEditingController();
final hoursController = TextEditingController();
final reasonController = TextEditingController();
final key = GlobalKey<FormState>();

class _PersonalPermissionsState extends State<PersonalPermissions> {
  @override
  void initState() {
    datepersonalController.clear();
    hoursController.clear();
    reasonController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    permissionsProvider = Provider.of<PermissionsProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("طلب إذن شخصي"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                TextInputForAll(
                  lable: "تاريخ الإذن",
                  hint: "تاريخ الإذن",
                  controller: datepersonalController,
                  type: TextInputType.datetime,
                ),
                TextInputForAll(
                  lable: "عدد الساعات",
                  hint: "عدد الساعات",
                  controller: hoursController,
                  type: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                ),
                TextInputForAll(
                  lable: "السبب",
                  hint: "السبب",
                  controller: reasonController,
                ),
                permissionsProvider.loadingsendPersonal
                    ? SizedBox(
                        width: width * 0.5,
                        height: height * 0.1,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox(
                        width: width * 0.5,
                        height: height * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(2),
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.green)),
                            onPressed: () async {
                              if (key.currentState!.validate()) {
                                if (await permissionsProvider
                                    .PersonalPermissionSent(
                                        date: datepersonalController.text,
                                        hours: hoursController.text,
                                        reason: reasonController.text)) {
                                  Navigator.pop(context);
                                  datepersonalController.clear();
                                  hoursController.clear();
                                  reasonController.clear();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("تم طلب الإذن بنجاح"),
                                    backgroundColor: Colors.green,
                                  ));
                                } else {
                                  Flushbar(
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.red,
                                    title: "تعذر طلب الإذن",
                                    message: "حدث خطأ, يرجى إعادة المحاولة",
                                  ).show(context);
                                }
                              }
                            },
                            child: Center(child: Text("تأكيد")),
                          ),
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
