import 'package:flutter/material.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/extensions/text.dart';

class ZAKRadioButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool isSelected;

  ZAKRadioButton(
      {@required this.onPressed,
      @required this.title,
      @required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: onPressed,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: ZAKGreen),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  height: 7,
                                  width: 7,
                                  decoration: BoxDecoration(
                                    color: ZAKGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    ),
                    title.withStyle(
                        style: subtitleTextStyle(FontWeight.w500),
                        color: ZAKDarkGreen),
                  ],
                ))),
      ],
    );
  }
}
