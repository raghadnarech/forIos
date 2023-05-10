import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/constant/colors.dart';

class MoneyUser extends StatelessWidget {
  const MoneyUser({super.key});

  @override
  Widget build(BuildContext context) {
    employeeProvider = Provider.of<EmployeeProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("مدفوعات الموظف"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: employeeProvider.loadinguserprofile
            ? SizedBox(
                height: height,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Text(
                    "المدفوعات",
                    style: headStyle,
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Card(
                      elevation: 5,
                      child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text("المبلغ"),
                            ),
                            DataColumn(
                              label: Text("نوع الدفعة"),
                            ),
                            DataColumn(
                              label: Text("السبب"),
                            ),
                            DataColumn(
                              label: Text(" التاريخ"),
                            ),
                          ],
                          rows: employeeProvider.profileUser!.money!
                              .map(
                                (e) => DataRow(cells: [
                                  DataCell(Text(e.amount!)),
                                  DataCell(Text(e.amount_status! == "add"
                                      ? "مكافأة"
                                      : e.amount_status! == "deduction"
                                          ? "خصم"
                                          : "سلفة")),
                                  DataCell(Text(e.reason!)),
                                  DataCell(Text(e.date!)),
                                ]),
                              )
                              .toList()),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
