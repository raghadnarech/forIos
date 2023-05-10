import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Models/Task.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Views/User/entaskPage.dart';
import 'package:qr_app/Widgets/ListSkelaton.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

final key = GlobalKey<FormState>();

final nameController = TextEditingController();
final phoneController = TextEditingController();
final passwordController = TextEditingController();

class _TasksPageState extends State<TasksPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    loadItems();

    super.initState();
  }

  List<Task> _listItems = [];

  Future loadItems() async {
    await taskProvider.getMyTask();
    _listItems = [];
    var future = Future(() {});
    for (var i = 0; i < taskProvider.listTasks.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 75), () {
          _listItems.add(taskProvider.listTasks[i]);
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
                  await taskProvider.getMyTask();
                  loadItems();
                },
                child: taskProvider.listTasks.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("لايوجد مهام مسندة إليك"),
                            ],
                          ),
                        ],
                      )
                    : taskProvider.loadinglist
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
                                      child: Card(
                                        elevation: 2,
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
                                                          "${_listItems[index].task}"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            _listItems[index].status ==
                                                    "repeated"
                                                ? Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Icon(Icons.repeat),
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                EndTaskPage(
                                                                          status:
                                                                              _listItems[index].status,
                                                                          taskid:
                                                                              _listItems[index].id,
                                                                        ),
                                                                      ));
                                                                },
                                                                child: Text(
                                                                    "إنهاء المهمة")),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Checkbox(
                                                          value: taskProvider
                                                                      .listTasks[
                                                                          index]
                                                                      .status ==
                                                                  "finished"
                                                              ? true
                                                              : false,
                                                          onChanged: (value) {
                                                            if (taskProvider
                                                                    .listTasks[
                                                                        index]
                                                                    .status !=
                                                                "finished") {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            EndTaskPage(
                                                                      status: _listItems[
                                                                              index]
                                                                          .status,
                                                                      taskid:
                                                                          _listItems[index]
                                                                              .id,
                                                                    ),
                                                                  ));
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          ),
              )))
    ]));
  }
}
