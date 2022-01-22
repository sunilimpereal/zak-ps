import 'package:flutter/material.dart';

class ZAKBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/images/BackArrowIcon.png'),
      onPressed: Navigator.of(context).pop,
    );
  }
}
