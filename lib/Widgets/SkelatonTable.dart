import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkelatonTable extends StatelessWidget {
  const SkelatonTable({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 218, 216, 216),
      highlightColor: Color.fromARGB(255, 240, 236, 236),
      child: SizedBox(
        width: width,
        height: height * 0.5,
        child: Card(
            elevation: 5,
            child: DataTable(columns: [
              DataColumn(
                label: Text("التاريخ"),
              ),
              DataColumn(
                label: Text("بداية الدوام"),
              ),
              DataColumn(
                label: Text("نهاية الدوام"),
              ),
            ], rows: [
              DataRow(cells: [
                DataCell(SizedBox()),
                DataCell(Card()),
                DataCell(Card()),
              ]),
            ])),
      ),
    );
  }
}
