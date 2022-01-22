import 'package:flutter/material.dart';
import 'package:zak_mobile_app/utility/colors.dart';

class ZAKCircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(ZAKGreen),
    );
  }
}
