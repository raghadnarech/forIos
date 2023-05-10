import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Views/Admin/AccRejPage.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/ListSkelaton.dart';

class WaitPermm extends StatefulWidget {
  const WaitPermm({super.key});

  @override
  State<WaitPermm> createState() => _WaitPermmState();
}

class _WaitPermmState extends State<WaitPermm> {
  @override
  void initState() {
    permissionsProvider.getAllPermmision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    permissionsProvider = Provider.of<PermissionsProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Divider(color: Colors.transparent),
          SizedBox(
              height: height,
              width: width,
              child: RefreshIndicator(
                onRefresh: () async {
                  await permissionsProvider.getAllPermmision();
                },
                child: permissionsProvider.loadinggetPermissin
                    ? ListSkelaton(width: width, height: height)
                    : ListView.builder(
                        itemCount:
                            permissionsProvider.listwaitpermmision.length,
                        itemBuilder: (context, index) => SizedBox(
                          width: width,
                          height: height * 0.1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AccRejPage(
                                        permission: permissionsProvider
                                            .listwaitpermmision[index]),
                                  ));
                            },
                            child: Card(
                              elevation: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: AutoSizeText(
                                                "${permissionsProvider.listwaitpermmision[index].username}"),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: AutoSizeText(
                                                "${permissionsProvider.listwaitpermmision[index].phone}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Center(
                                                child:
                                                    AutoSizeText("نوع الإذن"))),
                                        Expanded(
                                          child: Center(
                                            child: AutoSizeText(
                                                "${permissionsProvider.listwaitpermmision[index].kind == "personal" ? "شخصي" : "مرضي"}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Center(
                                                child:
                                                    AutoSizeText("مدة الإذن"))),
                                        Expanded(
                                          child: Center(
                                            child: AutoSizeText(
                                                "${permissionsProvider.listwaitpermmision[index].kind == "personal" ? "ساعات ${permissionsProvider.listwaitpermmision[index].houres}" : "أيام ${permissionsProvider.listwaitpermmision[index].days}"}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 5,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.amber,
                                            Color.fromARGB(255, 255, 222, 104)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              )),
        ]),
      ),
    ));
  }
}
