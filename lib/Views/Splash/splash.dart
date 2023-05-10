import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/AuthProvider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/MoneyProvider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Controllers/WorkTimeProvider.dart';
import 'package:qr_app/Views/Admin/HomePageAdmin.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/User/HomePageUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

EmployeeProvider employeeProvider = EmployeeProvider();
AuthProvider authProvider = AuthProvider();
TaskProvider taskProvider = TaskProvider();
MoneyProvider moneyProvider = MoneyProvider();
WorkTimeProvider workTimeProvider = WorkTimeProvider();
PermissionsProvider permissionsProvider = PermissionsProvider();

class Splash extends StatefulWidget {
  final bool isLogging;
  Splash({required this.isLogging});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    _navigatetohome();
    super.initState();
  }

  Future<Widget> routePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.isLogging) {
      if (prefs.getBool("role") ?? false) {
        return HomePageAdmin();
      } else {
        return HomePageUser();
      }
    } else {
      return AuthPage();
    }
  }

  _navigatetohome() async {
    await Future.delayed(
        Duration(seconds: 5),
        () async => {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: await routePage(),
                    isIos: false,
                    duration: Duration(milliseconds: 300),
                  ))
            });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: width * 0.8,
                      child: Image.asset("image/splash.png")),
                  SizedBox(
                    height: height * 0.2,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        FadeAnimatedText('Work Cycle',
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Robota"))
                      ],
                    ),
                  )
                ]),
          ],
        ));
  }
}
