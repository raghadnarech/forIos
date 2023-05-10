import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/WorkTimeProvider.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Views/User/workTime.dart';

class ScannerQr extends StatefulWidget {
  const ScannerQr({super.key});

  @override
  State<ScannerQr> createState() => _ScannerQrState();
}

class _ScannerQrState extends State<ScannerQr> {
  String? text = "";
  String? city;
  String? slot;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    employeeProvider = Provider.of<EmployeeProvider>(context);
    workTimeProvider = Provider.of<WorkTimeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: MobileScanner(
                      allowDuplicates: false,
                      fit: BoxFit.fill,
                      controller: MobileScannerController(
                          facing: CameraFacing.back, torchEnabled: false),
                      onDetect: (barcode, args) async {
                        await [Permission.camera].request();
                        if (barcode.rawValue == null) {
                          debugPrint('Failed to scan Barcode');
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (await employeeProvider
                                            .takeEnterTime(barcode)) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "تم تسجيل وقت بداية الدوام بنجاح")));
                                        } else {
                                          Navigator.pop(context);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "تم تسجيل وقت بداية الدوام مسبقاً")));
                                        }
                                      },
                                      child: Text("بداية الدوام")),
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (await employeeProvider
                                            .takeOutTime(barcode)) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "تم تسجيل وقت نهاية الدوام بنجاح")));
                                        } else {
                                          Navigator.pop(context);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "تم تسجيل وقت نهاية الدوام مسبقاً")));
                                        }
                                      },
                                      child: Text("نهاية الدوام")),
                                ],
                              ),
                            ]),
                          );
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        workTimeProvider.getMytime();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkTime(),
                            ));
                      },
                      child: Text("جدول الدوام"))
                ],
              ),
            ],
          ),
        ),
        Text(text!)
      ],
    ));
  }
}
