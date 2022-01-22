import 'package:flutter/material.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';

class ZAKGradientButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  ZAKGradientButton({this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      decoration: getGradientDecoration(),
      child: FlatButton(
        disabledColor: ZAKGreen.withOpacity(0.5),
        disabledTextColor: Colors.white,
        color: ZAKGreen,
        textColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.button.fontSize,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
    );
  }
}
