import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/MoneyProvider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Models/Money.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/ListSkelaton.dart';
import 'package:qr_app/Widgets/TextInput.dart';
import 'package:qr_app/constant/colors.dart';

class MoneyPage extends StatefulWidget {
  const MoneyPage({super.key});

  @override
  State<MoneyPage> createState() => _MoneyPageState();
}

final key = GlobalKey<FormState>();

class _MoneyPageState extends State<MoneyPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    loadItems();

    super.initState();
  }

  List<Money> _listItems = [];

  Future loadItems() async {
    await moneyProvider.getMyMoney();
    _listItems = [];
    var future = Future(() {});
    for (var i = 0; i < moneyProvider.listmoney.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 75), () {
          _listItems.add(moneyProvider.listmoney[i]);
          _listKey.currentState!.insertItem(_listItems.length - 1);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? text;
    employeeProvider = Provider.of<EmployeeProvider>(context);
    taskProvider = Provider.of<TaskProvider>(context);
    moneyProvider = Provider.of<MoneyProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: SizedBox(
          height: height,
          width: width,
          child: RefreshIndicator(
              onRefresh: () async {
                await moneyProvider.getMyMoney();
                loadItems();
              },
              child: moneyProvider.listmoney.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("لايوجد أي مدفوعات"),
                          ],
                        ),
                      ],
                    )
                  : moneyProvider.isloadingmoney
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListSkelaton(width: width, height: height),
                        )
                      : AnimatedList(
                          key: _listKey,
                          initialItemCount: _listItems.length,
                          itemBuilder: (context, index, animation) =>
                              SlideTransition(
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
                                child: Card(
                                  elevation: 4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Center(
                                              child: AutoSizeText(
                                                "القيمة:",
                                                style: headStyle,
                                              ),
                                            ),
                                            Center(
                                              child: SizedBox(
                                                child: AutoSizeText(
                                                  maxLines: 1,
                                                  "${_listItems[index].amount} ${_listItems[index].amount_status == "add" ? "+" : "-"}",
                                                  style: contentStyle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            "${_listItems[index].amount_status == "add" ? "مكافأة" : _listItems[index].amount_status == "deduction" ? "خصم" : "سلفة"}",
                                            style: headStyle,
                                          ),
                                          Divider(),
                                          Visibility(
                                              visible:
                                                  _listItems[index].reason !=
                                                      "لايوجد",
                                              child: Center(
                                                  child: AutoSizeText(
                                                "السبب:",
                                                style: contentStyle,
                                              ))),
                                          Visibility(
                                            visible: _listItems[index].reason !=
                                                "لايوجد",
                                            child: Center(
                                                child: SizedBox(
                                              width: width * 0.3,
                                              child: AutoSizeText(
                                                textAlign: TextAlign.center,
                                                "${_listItems[index].reason}",
                                                style: contentStyle,
                                              ),
                                            )),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: AutoSizeText(
                                                "التاريخ",
                                                style: headStyle,
                                              ),
                                            ),
                                            Center(
                                                child: AutoSizeText(
                                              "${_listItems[index].date}",
                                              style: contentStyle,
                                            ))
                                          ],
                                        ),
                                      ),
                                      _listItems[index].amount_status == "add"
                                          ? Container(
                                              height: height * 0.2,
                                              width: 10,
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.green,
                                                      Colors.green,
                                                      Colors.green,
                                                      Colors.green,
                                                      Colors.greenAccent
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end:
                                                        Alignment.bottomCenter),
                                              ),
                                            )
                                          : Container(
                                              height: height * 0.2,
                                              width: 10,
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.red,
                                                      Colors.red,
                                                      Colors.red,
                                                      Colors.red,
                                                      Color.fromARGB(
                                                          255, 255, 169, 169)
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end:
                                                        Alignment.bottomCenter),
                                              ),
                                            )
                                    ],
                                  ),

                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceAround,
                                  //   children: [
                                  //     Text(
                                  //         "${_listItems[index].amount} ${_listItems[index].amount_status == "add" ? "+" : "-"}"),
                                  //     Text(
                                  //         "${_listItems[index].amount_status == "add" ? "مكافأة" : _listItems[index].amount_status == "deduction" ? "خصم" : "سلفة"}"),
                                  //     Icon(
                                  //       Icons.monetization_on,
                                  //       color:
                                  //           _listItems[index].amount_status ==
                                  //                   "add"
                                  //               ? Colors.green
                                  //               : Colors.red,
                                  //     )
                                  //   ],
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        )),
        ),
      ),
    ]));
  }
}
