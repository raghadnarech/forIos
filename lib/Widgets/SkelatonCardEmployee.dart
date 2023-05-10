import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkelatonCardEmployee extends StatelessWidget {
  const SkelatonCardEmployee({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height * 0.1,
      child: Shimmer.fromColors(
        baseColor: Color.fromARGB(255, 218, 216, 216),
        highlightColor: Color.fromARGB(255, 240, 236, 236),
        child: Card(elevation: 2, child: SizedBox()),
      ),
    );
  }
}
