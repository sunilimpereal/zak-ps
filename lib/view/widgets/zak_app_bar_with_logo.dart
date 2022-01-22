import 'package:flutter/material.dart';
import 'package:zak_mobile_app/view/widgets/zak_back_button.dart';

class ZAKAppBarWithLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 16.0;
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: horizontalPadding, top: 66),
                  child: Image.asset('assets/images/ZAKLogo.png'),
                )
              ],
            ),
            Image.asset('assets/images/Pattern.png'),
          ],
        ),
        Container(
          height: 50,
          child: AppBar(
            leading: ZAKBackButton(),
            backgroundColor: Colors.transparent,
          ),
        )
      ],
    );
  }
}
