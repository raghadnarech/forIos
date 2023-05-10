import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/AuthProvider.dart';
import 'package:qr_app/Controllers/MoneyProvider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Views/Admin/employee.dart';
import 'package:qr_app/Views/Admin/generate_qr_code.dart';
import 'package:qr_app/Views/Admin/gift_discount.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Views/User/moneyPage.dart';
import 'package:qr_app/Views/User/permissions.dart';
import 'package:qr_app/Views/User/scannerQrCode.dart';
import 'package:qr_app/Views/User/tasksPage.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  @override
  void initState() {
    if (taskProvider.listTasks.isEmpty) {
      taskProvider.getMyTask();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    moneyProvider = Provider.of<MoneyProvider>(context);
    taskProvider = Provider.of<TaskProvider>(context);

    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("الموظف"),
            actions: [
              IconButton(
                  onPressed: () async {
                    await authProvider.logout();
                    taskProvider.listTasks.clear();
                    moneyProvider.listmoney.clear();

                    await Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: AuthPage(),
                          isIos: false,
                          duration: Duration(milliseconds: 300),
                        ));
                  },
                  icon: Icon(Icons.logout))
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.qr_code),
                  text: "قراءة Qr",
                ),
                Tab(
                  icon: Icon(Icons.task_outlined),
                  text: "المهام",
                ),
                Tab(
                  icon: Icon(Icons.monetization_on_outlined),
                  text: "مدفوعات",
                ),
                Tab(
                  icon: Icon(Icons.admin_panel_settings_outlined),
                  text: "الأذونات",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ScannerQr(),
              TasksPage(),
              MoneyPage(),
              Permissions(),
            ],
          ),
        ));
  }
}
