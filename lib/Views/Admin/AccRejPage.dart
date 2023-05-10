import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Models/Permissions.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/TextInput.dart';
import 'package:qr_app/constant/colors.dart';
import 'package:qr_app/constant/url.dart';

class AccRejPage extends StatefulWidget {
  Permission? permission;

  AccRejPage({this.permission});

  @override
  State<AccRejPage> createState() => _AccRejPageState();
}

final timeController = TextEditingController();

class _AccRejPageState extends State<AccRejPage> {
  @override
  void initState() {
    setState(() {
      timeController.text = widget.permission!.kind == "personal"
          ? widget.permission!.houres.toString()
          : widget.permission!.days.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    permissionsProvider = Provider.of<PermissionsProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("إدارة الإذن"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("اسم الموظف:", style: headStyle),
              Text(
                "${widget.permission!.username}",
                style: contentStyle,
              ),
              Text("رقم الموظف:", style: headStyle),
              Text(
                "${widget.permission!.phone}",
                style: contentStyle,
              ),
              Text("نوع الإذن:", style: headStyle),
              Text(
                "${widget.permission!.kind == "personal" ? "إذن شخصي" : "إذن مرضي"}",
                style: contentStyle,
              ),
              Visibility(
                  visible: widget.permission!.kind == "personal",
                  child: Text("تاريخ الإذن:", style: headStyle)),
              Visibility(
                  visible: widget.permission!.kind == "personal",
                  child:
                      Text("${widget.permission!.date}", style: contentStyle)),
              Text(
                  "مدة الإذن: ${widget.permission!.kind == "personal" ? "بالساعات" : "باليوم"}",
                  style: headStyle),
              TextInputForAll(
                hint: "مدة الإذن",
                state: widget.permission!.status == 0,
                controller: timeController,
                type: TextInputType.number,
              ),
              Visibility(
                visible: widget.permission!.status == 0,
                child: Text(
                  "ملاحظة: يمكن تعديل المدة الموافق عليها  قبل قبول الطلب",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Visibility(
                  visible: widget.permission!.kind == "personal",
                  child: Text("سبب الإذن:", style: headStyle)),
              Visibility(
                  visible: widget.permission!.kind == "personal",
                  child: Text("${widget.permission!.reason}",
                      style: contentStyle)),
              Visibility(
                  visible: widget.permission!.kind != "personal",
                  child: Text("المرفقات:", style: headStyle)),
              Visibility(
                visible: widget.permission!.kind != "personal",
                child: SizedBox(
                    width: width,
                    height: height * 0.3,
                    child: InstaImageViewer(
                      child: Image.network(
                          "$urlImage/${widget.permission!.image}",
                          fit: BoxFit.contain),
                    )),
              ),
              Divider(),
              widget.permission!.status == 1
                  ? Center(
                      child: Text(
                      "تم قبول  الطلب مسبقاً",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.green),
                    ))
                  : widget.permission!.status == 2
                      ? Center(
                          child: Text(
                          "تم رفض الطلب مسبقاً",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.red),
                        ))
                      : permissionsProvider.loadingacc_rej
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [CircularProgressIndicator()],
                            )
                          : widget.permission!.kind == "personal"
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.green)),
                                        onPressed: () async {
                                          if (await permissionsProvider
                                              .accrejper(
                                                  idper: widget.permission!.id,
                                                  status: 1,
                                                  hours: timeController.text)) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("تم قبول الإذن بنجاح"),
                                              backgroundColor: Colors.green,
                                            ));
                                            timeController.clear();
                                          } else {
                                            Flushbar(
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Colors.red,
                                              title: "تعذر قبول الإذن",
                                              message:
                                                  "حدث خطأ, يرجى إعادة المحاولة",
                                            ).show(context);
                                          }
                                        },
                                        child: Text("قبول")),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.red)),
                                        onPressed: () async {
                                          if (await permissionsProvider
                                              .accrejper(
                                                  idper: widget.permission!.id,
                                                  status: 2,
                                                  hours: timeController.text)) {
                                            Navigator.pop(context);
                                            timeController.clear();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("تم رفض الإذن بنجاح"),
                                              backgroundColor: Colors.green,
                                            ));
                                          } else {
                                            Flushbar(
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Colors.red,
                                              title: "تعذر رفض الإذن",
                                              message:
                                                  "حدث خطأ, يرجى إعادة المحاولة",
                                            ).show(context);
                                          }
                                        },
                                        child: Text("رفض")),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.green)),
                                        onPressed: () async {
                                          if (await permissionsProvider
                                              .accrejsat(
                                                  idper: widget.permission!.id,
                                                  status: 1,
                                                  days: timeController.text)) {
                                            Navigator.pop(context);
                                            timeController.clear();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("تم قبول الإذن بنجاح"),
                                              backgroundColor: Colors.green,
                                            ));
                                          } else {
                                            Flushbar(
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Colors.red,
                                              title: "تعذر قبول الإذن",
                                              message:
                                                  "حدث خطأ, يرجى إعادة المحاولة",
                                            ).show(context);
                                          }
                                        },
                                        child: Text("قبول")),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.red)),
                                        onPressed: () async {
                                          if (await permissionsProvider
                                              .accrejsat(
                                                  idper: widget.permission!.id,
                                                  status: 2,
                                                  days: timeController.text)) {
                                            Navigator.pop(context);
                                            timeController.clear();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("تم رفض الإذن بنجاح"),
                                              backgroundColor: Colors.green,
                                            ));
                                          } else {
                                            Flushbar(
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Colors.red,
                                              title: "تعذر رفض الإذن",
                                              message:
                                                  "حدث خطأ, يرجى إعادة المحاولة",
                                            ).show(context);
                                          }
                                        },
                                        child: Text("رفض")),
                                  ],
                                )
            ],
          ),
        ),
      ),
    );
  }
}
