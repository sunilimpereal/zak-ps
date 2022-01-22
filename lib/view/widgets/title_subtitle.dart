import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/utility/colors.dart';

class TitleSubtitleText extends StatelessWidget {
  final String title, subtitle;
  TitleSubtitleText({@required this.title, @required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.withStyle(
            color: ZAKDarkGreen, style: Theme.of(context).textTheme.headline6),
        SizedBox(
          height: 5,
        ),
        subtitle.withStyle(
            style: Theme.of(context).textTheme.subtitle2, color: ZAKGrey)
      ],
    );
  }
}
