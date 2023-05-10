import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/TextInput.dart';

class SatisfactoryPermission extends StatefulWidget {
  const SatisfactoryPermission({super.key});

  @override
  State<SatisfactoryPermission> createState() => _SatisfactoryPermissionState();
}

final key = GlobalKey<FormState>();

class _SatisfactoryPermissionState extends State<SatisfactoryPermission> {
  final daysController = TextEditingController();
  ImagePicker picker = ImagePicker();
  String? imageName = "";
  File? imagePath;
  File? file;
  XFile? imagefilesx;
  @override
  Widget build(BuildContext context) {
    permissionsProvider = Provider.of<PermissionsProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    openImagefromGalary() async {
      var pickedfiles = await picker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        setState(() {
          imagefilesx = pickedfiles;
        });
      }
    }

    openImagefromCamer() async {
      var pickedfiles = await picker.pickImage(source: ImageSource.camera);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        setState(() {
          imagefilesx = pickedfiles;
        });
      }
    }

    clearPhoto() async {
      setState(() {
        imagefilesx = null;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("طلب إذن مرضي"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: height * 0.5,
                    width: width * 0.9,
                    child: imagefilesx == null
                        ? Card(
                            elevation: 5,
                            child: Center(
                                child: Text(
                                    "يرجى ارفاق صورة تثبت صحة طلب الإذن المرضي ")),
                          )
                        : Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  child: InstaImageViewer(
                                    child: Image.file(File(imagefilesx!.path),
                                        fit: BoxFit.contain),
                                  )),
                            ),
                          ),
                  ),
                ),
                imagefilesx == null
                    ? SizedBox()
                    : SizedBox(
                        width: width * 0.9,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.red)),
                            onPressed: () {
                              clearPhoto();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("حذف الصورة"),
                                Icon(Icons.delete),
                              ],
                            )),
                      ),
                Divider(),
                SizedBox(
                  width: width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            openImagefromGalary();
                          },
                          child: Row(
                            children: [
                              Icon(Icons.image),
                              Text("اختيار من المعرض"),
                            ],
                          )),
                      ElevatedButton(
                          onPressed: () {
                            openImagefromCamer();
                          },
                          child: Row(
                            children: [
                              Icon(Icons.camera),
                              Text("فتح الكاميرا"),
                            ],
                          )),
                    ],
                  ),
                ),
                Divider(),
                TextInputForAll(
                  lable: "عدد الأيام",
                  hint: "عدد الأيام",
                  controller: daysController,
                  type: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                ),
                permissionsProvider.loadingsendSatisf
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
                                if (imagefilesx != null) {
                                  imagePath = File(imagefilesx!.path);
                                  if (await permissionsProvider
                                      .SatisfactoryPermissionSent(
                                          image: imagePath,
                                          days: daysController.text)) {
                                    Navigator.pop(context);
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
                                } else {
                                  Flushbar(
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.red,
                                    title: "تعذر طلب الإذن",
                                    message: "لايمكن طلب إذن قبل ارفاق صورة",
                                  ).show(context);
                                }
                              } else {
                                Flushbar(
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                  title: "تعذر طلب الإذن",
                                  message:
                                      "لايمكن طلب إذن قبل تحديد عدد الأيام",
                                ).show(context);
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
