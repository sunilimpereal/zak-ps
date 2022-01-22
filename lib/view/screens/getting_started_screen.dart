import 'package:flutter/material.dart';

import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/view/screens/authentication_screen.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/extensions/text.dart';

class GettingStartedScreen extends StatelessWidget {
  static const routeName = 'GettingStartedScreen/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Image.asset(
                'assets/images/WelcomeDesignImage.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Welcome to ZAK!',
                style: Theme.of(context).accentTextTheme.headline2,
              ),
            ),
            Container(
              width: 234,
              child: Text(
                'Book tickets, and adopt animals, all from a single app now.',
                style: TextStyle(
                  color: ZAKGrey,
                  fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: ZAKButton(
                title: 'Get Started',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => AuthenticationScreen(false)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, top: 32),
              child: Column(
                children: <Widget>[
                  'Already have an account?'.withStyle(
                      style: Theme.of(context).textTheme.bodyText1,
                      color: ZAKGrey),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: MaterialButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      height: 0,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AuthenticationScreen(true)));
                      },
                      child: Text('Sign In'),
                      textColor: ZAKGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
