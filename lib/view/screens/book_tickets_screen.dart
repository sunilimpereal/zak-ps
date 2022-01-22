import 'package:flutter/material.dart';

import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';

class BookTicketsScreen extends StatelessWidget {
  static const routeName = 'BookTicketsScreen/';
  @override
  Widget build(BuildContext context) {
    const padding = 16.0;
    return Scaffold(
      appBar: ZAKAppBar(),
      body: Padding(
        padding:
            const EdgeInsets.only(top: padding, left: padding, right: padding),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ZAKTitle(title: 'Book tickets'),
              ],
            ),
            Column(
              children: <Widget>[
                Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Text(
                      'Booking tickets has been temporary disabled due to COVID-19 until further notice.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: ZAKGrey,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ZAKButton(
                    onPressed: null,
                    title: 'Book Tickets',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
