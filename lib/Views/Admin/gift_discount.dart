import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/MoneyProvider.dart';
import 'package:qr_app/Models/Employee.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/SkelatonCardEmployee.dart';
import 'package:qr_app/Widgets/TextInput.dart';

class Gift_DiscPage extends StatefulWidget {
  const Gift_DiscPage({super.key});

  @override
  State<Gift_DiscPage> createState() => _Gift_DiscPageState();
}

final key = GlobalKey<FormState>();

final deductionController = TextEditingController();
final dateadvancepayment = TextEditingController();
final addController = TextEditingController();
final reasonController = TextEditingController();

class _Gift_DiscPageState extends State<Gift_DiscPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<Employee> _listItems = [];
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

  String? text;
  Future loadItems() async {
    await employeeProvider.getAllUsers();

    _listItems = [];
    var future = Future(() {});
    for (var i = 0; i < employeeProvider.listemployee.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 75), () {
          _listItems.add(employeeProvider.listemployee[i]);
          print(_listItems.length);
          _listKey.currentState!.insertItem(_listItems.length - 1);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    employeeProvider = Provider.of<EmployeeProvider>(context);
    moneyProvider = Provider.of<MoneyProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // String Selectemploye = "الموظف 1";
    // List<String> employees = ["الموظف 3", "الموظف 2", "الموظف 1"];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: height,
                width: width,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await employeeProvider.getAllUsers();
                    loadItems();
                  },
                  child: employeeProvider.loadinglist
                      ? ListView.builder(
                          itemBuilder: (context, index) => SkelatonCardEmployee(
                              width: width, height: height),
                          itemCount: 7,
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
                                child: Slidable(
                                  startActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  StatefulBuilder(
                                                builder: (context, setState) =>
                                                    AlertDialog(
                                                  content: Form(
                                                    key: key,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextInputForAll(
                                                          hint: "السلفة",
                                                          controller:
                                                              deductionController,
                                                        ),
                                                        TextInputForAll(
                                                          hint: "تاريخ السلفة",
                                                          controller:
                                                              dateadvancepayment,
                                                          type: TextInputType
                                                              .datetime,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      children: [
                                                        moneyProvider
                                                                .isloadinggiveMoney
                                                            ? Expanded(
                                                                child: Center(
                                                                    child:
                                                                        CircularProgressIndicator()))
                                                            : Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                                  child: Text(
                                                                      "موافق"),
                                                                  onPressed:
                                                                      () async {
                                                                    if (key
                                                                        .currentState!
                                                                        .validate()) {
                                                                      setState(
                                                                        () {},
                                                                      );
                                                                      if (await moneyProvider.giveMoneyforUserAdvance(
                                                                          amount: deductionController
                                                                              .text,
                                                                          amount_status:
                                                                              "Advance payment",
                                                                          userId: employeeProvider
                                                                              .listemployee[index]
                                                                              .id
                                                                              .toString(),
                                                                          date: dateadvancepayment.text)) {
                                                                        Navigator.pop(
                                                                            context);
                                                                        deductionController
                                                                            .clear();
                                                                        reasonController
                                                                            .clear();
                                                                        dateadvancepayment
                                                                            .clear();
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content:
                                                                                Text("تم اسناد سلفة للموظف بنجاح")));
                                                                      } else {
                                                                        Navigator.pop(
                                                                            context);
                                                                        deductionController
                                                                            .clear();
                                                                        reasonController
                                                                            .clear();
                                                                        dateadvancepayment
                                                                            .clear();
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content:
                                                                                Text("حدث خطأ, يرجى إعادة المحاولة")));
                                                                      }
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                        VerticalDivider(),
                                                        ElevatedButton(
                                                          child: Text('خروج'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            deductionController
                                                                .clear();
                                                            reasonController
                                                                .clear();
                                                            dateadvancepayment
                                                                .clear();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          backgroundColor: Color(0xFF21B7CA),
                                          foregroundColor: Colors.white,
                                          icon: Icons.handshake_outlined,
                                          label: 'سلفة',
                                        ),
                                      ]),
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                StatefulBuilder(
                                              builder: (context, setState) =>
                                                  AlertDialog(
                                                content: Form(
                                                  key: key,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextInputForAll(
                                                        hint: "المكافأة",
                                                        controller:
                                                            addController,
                                                      ),
                                                      TextInputForAll(
                                                        hint: "السبب",
                                                        controller:
                                                            reasonController,
                                                      ),
                                                      TextInputForAll(
                                                        hint: "تاريخ المكافأة",
                                                        controller:
                                                            dateadvancepayment,
                                                        type: TextInputType
                                                            .datetime,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    children: [
                                                      moneyProvider
                                                              .isloadinggiveMoney
                                                          ? Expanded(
                                                              child: Center(
                                                                  child:
                                                                      CircularProgressIndicator()))
                                                          : Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                child: Text(
                                                                    "موافق"),
                                                                onPressed:
                                                                    () async {
                                                                  if (key
                                                                      .currentState!
                                                                      .validate()) {
                                                                    setState(
                                                                      () {},
                                                                    );
                                                                    if (await moneyProvider.giveMoneyforUser(
                                                                        amount: addController
                                                                            .text,
                                                                        amount_status:
                                                                            "add",
                                                                        date: dateadvancepayment
                                                                            .text,
                                                                        userId: employeeProvider
                                                                            .listemployee[
                                                                                index]
                                                                            .id
                                                                            .toString(),
                                                                        reason:
                                                                            reasonController.text)) {
                                                                      Navigator.pop(
                                                                          context);
                                                                      addController
                                                                          .clear();
                                                                      reasonController
                                                                          .clear();
                                                                      dateadvancepayment
                                                                          .clear();
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text("تم إضافة المبلغ للموظف بنجاح")));
                                                                    } else {
                                                                      Navigator.pop(
                                                                          context);
                                                                      addController
                                                                          .clear();
                                                                      reasonController
                                                                          .clear();
                                                                      dateadvancepayment
                                                                          .clear();
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text("حدث خطأ, يرجى إعادة المحاولة")));
                                                                    }
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                      VerticalDivider(),
                                                      ElevatedButton(
                                                        child: Text('خروج'),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          addController.clear();
                                                          reasonController
                                                              .clear();
                                                          dateadvancepayment
                                                              .clear();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        icon: Icons.attach_money,
                                        label: 'مكافأة',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                StatefulBuilder(
                                              builder: (context, setState) =>
                                                  AlertDialog(
                                                content: Form(
                                                  key: key,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextInputForAll(
                                                        hint: "الخصم",
                                                        controller:
                                                            deductionController,
                                                      ),
                                                      TextInputForAll(
                                                        hint: "السبب",
                                                        controller:
                                                            reasonController,
                                                      ),
                                                      TextInputForAll(
                                                        hint: "تاريخ الخصم",
                                                        controller:
                                                            dateadvancepayment,
                                                        type: TextInputType
                                                            .datetime,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    children: [
                                                      moneyProvider
                                                              .isloadinggiveMoney
                                                          ? Expanded(
                                                              child: Center(
                                                                  child:
                                                                      CircularProgressIndicator()))
                                                          : Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                child: Text(
                                                                    "موافق"),
                                                                onPressed:
                                                                    () async {
                                                                  if (key
                                                                      .currentState!
                                                                      .validate()) {
                                                                    setState(
                                                                      () {},
                                                                    );
                                                                    if (await moneyProvider.giveMoneyforUser(
                                                                        amount: deductionController
                                                                            .text,
                                                                        amount_status:
                                                                            "deduction",
                                                                        userId: employeeProvider
                                                                            .listemployee[
                                                                                index]
                                                                            .id
                                                                            .toString(),
                                                                        date: dateadvancepayment
                                                                            .text,
                                                                        reason:
                                                                            reasonController.text)) {
                                                                      Navigator.pop(
                                                                          context);
                                                                      deductionController
                                                                          .clear();
                                                                      reasonController
                                                                          .clear();
                                                                      dateadvancepayment
                                                                          .clear();
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text("تم خصم المبلغ من الموظف بنجاح")));
                                                                    } else {
                                                                      Navigator.pop(
                                                                          context);
                                                                      deductionController
                                                                          .clear();
                                                                      reasonController
                                                                          .clear();
                                                                      dateadvancepayment
                                                                          .clear();
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text("حدث خطأ, يرجى إعادة المحاولة")));
                                                                    }
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                      VerticalDivider(),
                                                      ElevatedButton(
                                                        child: Text('خروج'),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          deductionController
                                                              .clear();
                                                          reasonController
                                                              .clear();
                                                          dateadvancepayment
                                                              .clear();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        backgroundColor: Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.money_off,
                                        label: 'خصم',
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    width: width,
                                    height: height * 0.1,
                                    child: Card(
                                      elevation: 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "${employeeProvider.listemployee[index].name}"),
                                          Text(
                                              "${employeeProvider.listemployee[index].phone}"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                          },
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
