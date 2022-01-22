import 'package:flutter/material.dart';
import 'package:zak_mobile_app/utility/colors.dart';

class ZAKButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  ZAKButton({this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Container(), flex: 1),
        Expanded(
          flex: 2,
          child: Container(
            height: 51,
            child: FlatButton(
              disabledColor: ZAKGreen.withOpacity(0.5),
              disabledTextColor: Colors.white,
              color: ZAKGreen,
              textColor: Colors.white,
              child: Text(
                title,
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: onPressed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26)),
            ),
          ),
        ),
        Expanded(child: Container(), flex: 1),
      ],
    );
  }
}
