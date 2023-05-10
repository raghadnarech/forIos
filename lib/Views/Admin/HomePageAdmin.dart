import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/AuthProvider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Views/Admin/PermmisionPage.dart';
import 'package:qr_app/Views/Admin/employee.dart';
import 'package:qr_app/Views/Admin/generate_qr_code.dart';
import 'package:qr_app/Views/Admin/gift_discount.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Views/User/scannerQrCode.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  @override
  void initState() {
    if (employeeProvider.listemployee.isEmpty) {
      employeeProvider.getAllUsers();
    }
    if (permissionsProvider.listpermmision.isEmpty) {
      permissionsProvider.getAllPermmision();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    permissionsProvider = Provider.of<PermissionsProvider>(context);
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("المسؤول"),
            actions: [
              IconButton(
                  onPressed: () async {
                    await authProvider.logout();
                    Navigator.pushReplacement(
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
                  text: "انشاء Qr",
                ),
                Tab(
                  icon: Icon(Icons.people),
                  text: "الموظفين",
                ),
                Tab(
                  icon: Icon(Icons.monetization_on_outlined),
                  text: "مدفوعات",
                ),
                Tab(
                  icon: Badge(
                      badgeContent: Text(
                        "${permissionsProvider.countwait}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      child: Icon(Icons.admin_panel_settings_outlined)),
                  text: "الإذونات",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              GenerateQRCode(),
              EmployeePage(),
              Gift_DiscPage(),
              PermmisionPage()
            ],
          ),
        ));
  }
}
