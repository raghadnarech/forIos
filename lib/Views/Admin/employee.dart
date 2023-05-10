import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Models/Employee.dart';
import 'package:qr_app/Views/Admin/addEmployee.dart';
import 'package:qr_app/Views/Admin/user_profile.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/SkelatonCardEmployee.dart';
import 'package:qr_app/Widgets/TextInput.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../../Widgets/ListSkelaton.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

final nameController = TextEditingController();
final phoneController = TextEditingController();
final passwordController = TextEditingController();
final taskcontroller = TextEditingController();

class _EmployeePageState extends State<EmployeePage> {
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

  Future loadItems() async {
    await employeeProvider.getAllUsers();
    _listItems = [];
    var future = Future(() {});
    for (var i = 0; i < employeeProvider.listemployee.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 75), () {
          _listItems.add(employeeProvider.listemployee[i]);
          _listKey.currentState!.insertItem(_listItems.length - 1);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? text;
    bool repeated = false;
    employeeProvider = Provider.of<EmployeeProvider>(context);
    taskProvider = Provider.of<TaskProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEmployee(),
                          ));
                    },
                    child: Text("إضافة موظف"))
              ],
            ),
            Expanded(
              child: SizedBox(
                height: height,
                width: width,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await employeeProvider.getAllUsers();
                    _listItems.clear();

                    loadItems();
                  },
                  child: employeeProvider.loadinglist
                      ? ListSkelaton(width: width, height: height)
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
                                      onPressed: (context) async {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child: UserProfile(
                                                imageuser:
                                                    _listItems[index].image,
                                                userid: _listItems[index].id,
                                                name: _listItems[index].name,
                                                phone: _listItems[index].phone,
                                                dateTime:
                                                    _listItems[index].dateTime,
                                                housing_allowance:
                                                    _listItems[index]
                                                        .housing_allowance,
                                                number_idintity:
                                                    _listItems[index]
                                                        .number_idintity,
                                                other: _listItems[index].other,
                                                salary:
                                                    _listItems[index].salary,
                                                total: _listItems[index].total,
                                                transfer_allowance:
                                                    _listItems[index]
                                                        .transfer_allowance,
                                              ),
                                              isIos: false,
                                              duration:
                                                  Duration(milliseconds: 300),
                                            ));
                                        await employeeProvider.getUserProfile(
                                            _listItems[index].id);
                                      },
                                      backgroundColor: Color(0xFF21B7CA),
                                      foregroundColor: Colors.white,
                                      icon: Icons.remove_red_eye,
                                      label: 'عرض',
                                    ),
                                  ],
                                ),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                StatefulBuilder(
                                                  builder:
                                                      (context, setState) =>
                                                          AlertDialog(
                                                    content: Form(
                                                      key: key,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextInputForAll(
                                                            hint: "المهمة",
                                                            controller:
                                                                taskcontroller,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                  value:
                                                                      repeated,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      repeated =
                                                                          value!;
                                                                    });
                                                                  }),
                                                              Text("مكررة"),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          taskProvider
                                                                  .loadinggivetask
                                                              ? Expanded(
                                                                  child: Center(
                                                                      child:
                                                                          CircularProgressIndicator()))
                                                              : Expanded(
                                                                  child: ElevatedButton(
                                                                      child: Text('اسناد المهمة'),
                                                                      onPressed: () async {
                                                                        if (key
                                                                            .currentState!
                                                                            .validate()) {
                                                                          setState(
                                                                            () {},
                                                                          );
                                                                          if (await taskProvider.givetaskforuser(
                                                                              userid: employeeProvider.listemployee[index].id!.toString(),
                                                                              task: taskcontroller.text,
                                                                              repeated: repeated)) {
                                                                            taskcontroller.clear();

                                                                            Navigator.pop(context);
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم اسناد المهمة للموظف بنجاح")));
                                                                          } else {
                                                                            taskcontroller.clear();

                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("حدث خطأ, يرجى إعادة المحاولة")));
                                                                          }
                                                                        }
                                                                      }),
                                                                ),
                                                          VerticalDivider(),
                                                          ElevatedButton(
                                                            child: Text('خروج'),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              taskcontroller
                                                                  .clear();
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ));
                                      },
                                      backgroundColor: Color(0xFF21B7CA),
                                      foregroundColor: Colors.white,
                                      icon: Icons.add_task,
                                      label: 'اسناد مهمة',
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
                                        Text("${_listItems[index].name}"),
                                        Text("${_listItems[index].phone}"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
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
