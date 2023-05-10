import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/TextInput.dart';

class EditTask extends StatefulWidget {
  int? userid;
  int? taskid;
  String? task;
  String? status;

  EditTask({this.status, this.task, this.taskid, this.userid});
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final taskController = TextEditingController();

  bool? repeated;
  @override
  void initState() {
    taskController.text = widget.task!;
    repeated = widget.status == "repeated" ? true : false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("تعديل المهمة"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextInputForAll(
                lable: "المهمة",
                controller: taskController,
              ),
              Row(
                children: [
                  Checkbox(
                      value: repeated,
                      onChanged: (value) {
                        setState(() {
                          repeated = value!;
                        });
                      }),
                  Text("مكررة"),
                ],
              ),
              Row(
                children: [
                  taskProvider.loadingedittask
                      ? Expanded(
                          child: Center(
                          child: CircularProgressIndicator(),
                        ))
                      : Expanded(
                          child: ElevatedButton.icon(
                              onPressed: () async {
                                if (await taskProvider.edit_task(
                                    repeated: repeated,
                                    task: taskController.text,
                                    taskid: widget.taskid,
                                    userid: widget.userid.toString())) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("تم تعديل المهمة بنجاح")));
                                  taskController.clear();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "حدث خطأ, يرجى إعادة المحاولة")));
                                  taskController.clear();
                                }
                              },
                              icon: Icon(Icons.done),
                              label: Text("حفظ")),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
