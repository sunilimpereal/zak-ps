import 'package:flutter/material.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/view/widgets/zak_gradient_button.dart';

import 'package:zak_mobile_app/view/widgets/zak_title.dart';

class ZooOption extends StatelessWidget {
  final String buttonTitle;
  final String body;
  final String title;
  final Alignment titleAlignment;
  final Function onPressed;

  ZooOption({
    this.title,
    this.body,
    this.buttonTitle,
    this.titleAlignment = Alignment.center,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Align(
            alignment: titleAlignment,
            child: ZAKTitle(title: title),
          ),
        ),
        Container(
          height: 150,
          child: Stack(
            children: <Widget>[
              Container(
                  height: 123,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                      color: ZAKLightGrey,
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    body,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: ZAKDarkGreen,
                        letterSpacing: -0.23,
                        height: 1.6),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  )),
              Column(
                children: <Widget>[
                  Spacer(),
                  Container(
                    height: 51,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ZAKGradientButton(
                        onPressed: onPressed,
                        title: buttonTitle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
