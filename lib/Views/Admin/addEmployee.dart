import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/TextInput.dart';

class AddEmployee extends StatefulWidget {
  AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

var dateformat = DateFormat('yyyy-MM-dd').format(DateTime.now());
final dateaddemployeeController = TextEditingController();

class _AddEmployeeState extends State<AddEmployee> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final salaryController = TextEditingController();
  final housing_allowanceController = TextEditingController();
  final number_idintityController = TextEditingController();
  final otherController = TextEditingController();
  final totalController = TextEditingController();
  final transfer_allowanceController = TextEditingController();
  final key = GlobalKey<FormState>();
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
    totalController.text = total.toString();
  }

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
  void initState() {
    dateaddemployeeController.text = dateformat.toString();

    sumtotal();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    employeeProvider = Provider.of<EmployeeProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    sumtotal();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("إضافة موظف جديد"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              nameController.clear();
              passwordController.clear();
              phoneController.clear();
              dateaddemployeeController.clear();
              salaryController.clear();
              housing_allowanceController.clear();
              transfer_allowanceController.clear();
              otherController.clear();
              totalController.clear();
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInputForAll(
                  hint: "اسم الموظف",
                  lable: "اسم الموظف",
                  controller: nameController,
                ),
                TextInputForAll(
                  hint: "رقم الهاتف",
                  lable: "رقم الهاتف",
                  controller: phoneController,
                  type: TextInputType.number,
                ),
                TextInputForAll(
                  hint: "كلمة المرور",
                  lable: "كلمة المرور",
                  controller: passwordController,
                ),
                TextInputForAll(
                  hint: "رقم الهوية",
                  lable: "رقم الهوية",
                  controller: number_idintityController,
                  type: TextInputType.number,
                ),
                TextInputForAll(
                  hint: "$dateformat",
                  lable: "تاريخ انتهاء الإقامة",
                  controller: dateaddemployeeController,
                  type: TextInputType.datetime,
                ),
                TextInputForAll(
                  hint: "الراتب الأساسي",
                  lable: "الراتب الأساسي",
                  controller: salaryController,
                  type: TextInputType.number,
                ),
                TextInputForAll(
                  hint: "بدل السكن",
                  lable: "بدل السكن",
                  controller: housing_allowanceController,
                  type: TextInputType.number,
                ),
                TextInputForAll(
                  hint: "بدل المواصلات",
                  lable: "بدل المواصلات",
                  controller: transfer_allowanceController,
                  type: TextInputType.number,
                ),
                TextInputForAll(
                  hint: "بدلات أخرى",
                  lable: "بدلات أخرى",
                  controller: otherController,
                  type: TextInputType.number,
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
                  "ملاحظة: سيتم احتساب مجموع الراتب إضافة للبدلات تلقائياً عند الضغط على زر إضافة",
                  style: TextStyle(color: Colors.red),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: height * 0.3,
                        width: width * 0.9,
                        child: imagefilesx == null
                            ? Card(
                                elevation: 5,
                                child: Center(
                                    child: Text("يرجى ارفاق صورة الموظف")),
                              )
                            : Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                              style: BorderStyle.solid)),
                                      child: InstaImageViewer(
                                        child: Image.file(
                                            File(imagefilesx!.path),
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
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
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
                Row(
                  children: [
                    employeeProvider.isloadingadd
                        ? Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Expanded(
                            child: ElevatedButton(
                              child: Text('إضافة'),
                              onPressed: () async {
                                if (key.currentState!.validate()) {
                                  await sumtotal();
                                  if (imagefilesx != null) {
                                    if (await employeeProvider.addEmployee(
                                        name: nameController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text,
                                        dateTime:
                                            dateaddemployeeController.text,
                                        housing_allowance:
                                            housing_allowanceController.text,
                                        number_idintity:
                                            number_idintityController.text,
                                        other: otherController.text,
                                        salary: salaryController.text,
                                        total: totalController.text,
                                        transfer_allowance:
                                            transfer_allowanceController.text,
                                        image: File(imagefilesx!.path))) {
                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "تمت إضافة الموظف بنجاح")));
                                      nameController.clear();
                                      passwordController.clear();
                                      phoneController.clear();
                                      dateaddemployeeController.clear();
                                      salaryController.clear();
                                      housing_allowanceController.clear();
                                      transfer_allowanceController.clear();
                                      otherController.clear();
                                      totalController.clear();
                                    } else {
                                      nameController.clear();
                                      passwordController.clear();
                                      phoneController.clear();
                                      dateaddemployeeController.clear();
                                      salaryController.clear();
                                      housing_allowanceController.clear();
                                      transfer_allowanceController.clear();
                                      otherController.clear();
                                      totalController.clear();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "حدث خطأ, يرجى إعادة المحاولة")));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "لايمكن إضافة الموظف قبل إرفاق صورة")));
                                  }
                                }
                              },
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
