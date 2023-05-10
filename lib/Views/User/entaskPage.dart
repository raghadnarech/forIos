import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Views/Splash/splash.dart';

class EndTaskPage extends StatefulWidget {
  int? taskid;
  String? status;
  EndTaskPage({this.taskid, this.status});

  @override
  State<EndTaskPage> createState() => _EndTaskPageState();
}

class _EndTaskPageState extends State<EndTaskPage> {
  final ImagePicker _picker = ImagePicker();
  String? imageName = "";
  File? imagePath;
  File? file;
  XFile? imagefilesx;

  openImagefromGalary() async {
    var pickedfiles = await _picker.pickImage(source: ImageSource.gallery);
    //you can use ImageCourse.camera for Camera capture
    if (pickedfiles != null) {
      setState(() {
        imagefilesx = pickedfiles;
      });
    }
  }

  openImagefromCamer() async {
    var pickedfiles = await _picker.pickImage(source: ImageSource.camera);
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

  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: taskProvider.loadingfinish
          ? SizedBox(
              width: width * 0.5,
              height: height * 0.1,
              child: Center(child: CircularProgressIndicator()))
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
                    if (imagefilesx != null) {
                      imagePath = File(imagefilesx!.path);
                      if (await taskProvider.taskfinished(
                          image: imagePath,
                          taskid: widget.taskid,
                          repeated: widget.status)) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("تم إنهاء المهمة بنجاح"),
                          backgroundColor: Colors.green,
                        ));
                      }
                    } else {
                      Flushbar(
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.red,
                        title: "تعذر انهاء المهمة",
                        message: "لايمكن انهاء المهمة قبل ارفاق صورة",
                      ).show(context);
                    }
                  },
                  child: Center(child: Text("تأكيد")),
                ),
              )),
      appBar: AppBar(
        title: Text("صفحة انهاء المهمة"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                                  "يرجى ارفاق صورة تثبت أن المهمة قد انجزت")),
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
                            Text("اختيار من المعرض"),
                            Icon(Icons.image),
                          ],
                        )),
                    ElevatedButton(
                        onPressed: () {
                          openImagefromCamer();
                        },
                        child: Row(
                          children: [
                            Text("فتح الكاميرا"),
                            Icon(Icons.camera),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
