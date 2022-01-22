import 'package:flutter/material.dart';
import 'package:zak_mobile_app/utility/colors.dart';

class ZAKFlatButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  ZAKFlatButton({this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: -0.23),
      ),
      textColor: ZAKGreen,
    );
  }
}
