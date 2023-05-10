import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Views/Admin/AccRejPage.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/ListSkelaton.dart';

class RejPermm extends StatefulWidget {
  const RejPermm({super.key});

  @override
  State<RejPermm> createState() => _RejPermmState();
}

class _RejPermmState extends State<RejPermm> {
  @override
  Widget build(BuildContext context) {
    permissionsProvider = Provider.of<PermissionsProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
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
                        itemCount: permissionsProvider.listdenpermmision.length,
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
                                            .listdenpermmision[index]),
                                  ));
                            },
                            child: Card(
                              elevation: 3,
                              child: Row(
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
                                                "${permissionsProvider.listdenpermmision[index].username}"),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: AutoSizeText(
                                                "${permissionsProvider.listdenpermmision[index].phone}"),
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
                                                "${permissionsProvider.listdenpermmision[index].kind == "personal" ? "شخصي" : "مرضي"}"),
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
                                            Colors.red,
                                            Color.fromARGB(255, 255, 169, 169)
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
