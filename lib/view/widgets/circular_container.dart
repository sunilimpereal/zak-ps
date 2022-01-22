import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  final double size;
  final Color color;

  CircularContainer({@required this.size, @required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
