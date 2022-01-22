import 'package:flutter/material.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/view/widgets/circular_container.dart';

class BulletPoint extends StatelessWidget {
  final String title;

  BulletPoint(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8, top: 6),
          child: CircularContainer(size: 6, color: ZAKGreen),
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyText2.fontSize,
              letterSpacing:
                  Theme.of(context).textTheme.bodyText2.letterSpacing,
              color: ZAKGrey,
            ),
            maxLines: 5,
          ),
        ),
      ],
    );
  }
}
