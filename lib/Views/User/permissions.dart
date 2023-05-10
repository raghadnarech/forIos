import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Models/Permissions.dart';
import 'package:qr_app/Models/UserPermmision.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Views/User/PerDetailPage.dart';
import 'package:qr_app/Views/User/PersonalPermissions.dart';
import 'package:qr_app/Views/User/SatisfactoryPermission.dart';
import 'package:qr_app/Widgets/ListSkelaton.dart';

class Permissions extends StatefulWidget {
  const Permissions({super.key});

  @override
  State<Permissions> createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissions> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<PermissionUser> _listItems = [];
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        await loadItems();
      },
    );

    super.initState();
  }

  Future loadItems() async {
    await permissionsProvider.getMyPer();
    _listItems = [];
    var future = Future(() {});
    for (var i = 0; i < permissionsProvider.listpermmisionuser.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 75), () {
          _listItems.add(permissionsProvider.listpermmisionuser[i]);
          _listKey.currentState!.insertItem(_listItems.length - 1);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    permissionsProvider = Provider.of<PermissionsProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SatisfactoryPermission(),
                        ));
                  },
                  child: Text("إذن مرضي")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalPermissions(),
                        ));
                  },
                  child: Text("إذن شخصي")),
            ],
          ),
          Expanded(
              child: SizedBox(
            height: height,
            width: width,
            child: RefreshIndicator(
              onRefresh: () async {
                await permissionsProvider.getMyPer();
                loadItems();
              },
              child: permissionsProvider.listpermmisionuser.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("لايوجد إذونات لديك"),
                          ],
                        ),
                      ],
                    )
                  : permissionsProvider.loadinggetper
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListSkelaton(width: width, height: height),
                        )
                      : AnimatedList(
                          key: _listKey,
                          initialItemCount: _listItems.length,
                          itemBuilder: (context, index, animation) {
                            return SlideTransition(
                                position: CurvedAnimation(
                                  curve: Curves.easeOut,
                                  parent: animation,
                                ).drive((Tween<Offset>(
                                  begin: Offset(1, 0),
                                  end: Offset(0, 0),
                                ))),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: SizedBox(
                                    width: width,
                                    height: height * 0.1,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PerDetail(
                                                  permissionUser:
                                                      _listItems[index]),
                                            ));
                                      },
                                      child: Card(
                                        elevation: 3,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                                          "${_listItems[index].kind == "personal" ? "شخصي" : "مرضي"}"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            VerticalDivider(),
                                            _listItems[index].status == 0
                                                ? Container(
                                                    width: 5,
                                                    decoration:
                                                        const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.amber,
                                                            Color.fromARGB(255,
                                                                255, 222, 104)
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter),
                                                    ),
                                                  )
                                                : _listItems[index].status == 1
                                                    ? Container(
                                                        width: 5,
                                                        decoration:
                                                            const BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                                Colors.green,
                                                                Colors
                                                                    .greenAccent
                                                              ],
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 5,
                                                        decoration:
                                                            const BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                                Colors.red,
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    169,
                                                                    169)
                                                              ],
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter),
                                                        ),
                                                      )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                          },
                        ),
            ),
          ))
        ],
      ),
    );
  }
}
