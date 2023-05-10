import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_app/Views/Admin/acceptPermmision.dart';
import 'package:qr_app/Views/Admin/rejectPermmision.dart';
import 'package:qr_app/Views/Admin/waitPermission.dart';
import 'package:qr_app/Views/Splash/splash.dart';

class PermmisionPage extends StatefulWidget {
  const PermmisionPage({super.key});

  @override
  State<PermmisionPage> createState() => _PermmisionPageState();
}

class _PermmisionPageState extends State<PermmisionPage> {
  @override
  void initState() {
    permissionsProvider.getAllPermmision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            labelColor: Colors.blue,
            tabs: [
              Tab(
                icon: Icon(Icons.access_time_sharp),
                text: "قيد الانتظار",
              ),
              Tab(
                icon: Icon(Icons.cancel_outlined),
                text: "مرفوضة",
              ),
              Tab(
                icon: Icon(Icons.check_circle_outline),
                text: "مقبولة",
              ),
            ],
          ),
          body: TabBarView(
            children: [WaitPermm(), RejPermm(), AccPermm()],
          ),
        ));
  }
}
