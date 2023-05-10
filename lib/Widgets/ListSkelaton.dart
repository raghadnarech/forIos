import 'package:flutter/material.dart';

import 'SkelatonCardEmployee.dart';

class ListSkelaton extends StatelessWidget {
  const ListSkelaton({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) =>
          SkelatonCardEmployee(width: width, height: height),
      itemCount: 7,
    );
  }
}
