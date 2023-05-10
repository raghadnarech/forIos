import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/WorkTimeProvider.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/SkelatonCardEmployee.dart';
import 'package:qr_app/Widgets/SkelatonTable.dart';
import 'package:shimmer/shimmer.dart';

class WorkTime extends StatefulWidget {
  const WorkTime({super.key});

  @override
  State<WorkTime> createState() => _WorkTimeState();
}

class _WorkTimeState extends State<WorkTime> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    workTimeProvider = Provider.of<WorkTimeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("جدول الدوام")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: workTimeProvider.loadinglist
              ? SkelatonTable(width: width, height: height)
              : Row(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            child: DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text("التاريخ"),
                                  ),
                                  DataColumn(
                                    label: Text("بداية الدوام"),
                                  ),
                                  DataColumn(
                                    label: Text("نهاية الدوام"),
                                  ),
                                  DataColumn(
                                    label: Text("ساعات الدوام"),
                                  ),
                                ],
                                rows: workTimeProvider.listworktime
                                    .map(
                                      (e) => DataRow(cells: [
                                        DataCell(Text(e.date!)),
                                        DataCell(Text(e.in_time!)),
                                        DataCell(Text(e.out_time!)),
                                        DataCell(Text(e.total!)),
                                      ]),
                                    )
                                    .toList()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
