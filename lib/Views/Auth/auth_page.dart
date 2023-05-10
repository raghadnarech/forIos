import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion/motion.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/AuthProvider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/MoneyProvider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Views/Admin/HomePageAdmin.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Views/User/HomePageUser.dart';
import 'package:qr_app/Widgets/TextInput.dart';
import 'package:qr_app/constant/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

final key = GlobalKey<FormState>();

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController phonecontroller = TextEditingController();
  final controller = MotionController();

  TextEditingController passwordcontroller = TextEditingController();
  String _identifier = 'Unknown';
  String? identifier;
  Future<void> initUniqueIdentifierState() async {
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;

    setState(() {
      _identifier = identifier!;
      print(_identifier);
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (value) async {
        await initUniqueIdentifierState();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    authProvider = Provider.of<AuthProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: width * 0.7,
                      child: Image.asset("image/login.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        width: width * 0.85,
                        child: Motion(
                          glare: GlareConfiguration.fromElevation(1),
                          controller: controller,
                          child: Card(
                            elevation: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: key,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: TextInputForAll(
                                          hint: "رقم الهاتف",
                                          lable: "رقم الهاتف",
                                          controller: phonecontroller,
                                          type: TextInputType.phone),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: TextInputForAll(
                                          hint: "كلمة المرور",
                                          lable: "كلمة المرور",
                                          controller: passwordcontroller),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        authProvider.lodinglogin
                                            ? Expanded(
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              )
                                            : Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    if (key.currentState!
                                                        .validate()) {
                                                      int statuscode =
                                                          await authProvider.login(
                                                              phone:
                                                                  phonecontroller
                                                                      .text,
                                                              password:
                                                                  passwordcontroller
                                                                      .text,
                                                              uuid:
                                                                  _identifier);
                                                      print(statuscode);
                                                      if (statuscode == 200) {
                                                        if (authProvider
                                                            .user!.role!) {
                                                          prefs.setBool(
                                                              "isLogged", true);
                                                          Navigator
                                                              .pushReplacement(
                                                                  context,
                                                                  PageTransition(
                                                                    type: PageTransitionType
                                                                        .fade,
                                                                    child:
                                                                        HomePageAdmin(),
                                                                    isIos:
                                                                        false,
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            300),
                                                                  ));
                                                        } else {
                                                          prefs.setBool(
                                                              "isLogged", true);
                                                          Navigator
                                                              .pushReplacement(
                                                                  context,
                                                                  PageTransition(
                                                                    type: PageTransitionType
                                                                        .fade,
                                                                    child:
                                                                        HomePageUser(),
                                                                    isIos:
                                                                        false,
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            300),
                                                                  ));
                                                        }
                                                      } else if (statuscode ==
                                                          400) {
                                                        Flushbar(
                                                          duration: Duration(
                                                              seconds: 3),
                                                          backgroundColor:
                                                              Colors.red,
                                                          title:
                                                              "خطأ في تسجيل الدخول",
                                                          message:
                                                              "رقم الهاتف أو كلمة المرور غير صحيحة",
                                                        ).show(context);
                                                      } else if (statuscode ==
                                                          422) {
                                                        Flushbar(
                                                          duration: Duration(
                                                              seconds: 3),
                                                          backgroundColor:
                                                              Colors.red,
                                                          title:
                                                              "تسجيل دخول من جهاز جديد",
                                                          message:
                                                              "يرجى تسجيل الدخول من الجهاز الخاص بك",
                                                        ).show(context);
                                                      } else {
                                                        Flushbar(
                                                          duration: Duration(
                                                              seconds: 3),
                                                          backgroundColor:
                                                              Colors.red,
                                                          title:
                                                              "خطأ غير معروف",
                                                          message:
                                                              "حدث خطأ, يرجى إعادة المحاولة",
                                                        ).show(context);
                                                      }
                                                    }
                                                  },
                                                  style: ButtonStyle(),
                                                  child: Text("تسجيل الدخول"),
                                                ),
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
