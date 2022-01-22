import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_flat_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_text_field.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';

class VerifyUserScreen extends StatefulWidget {
  static const routeName = 'VerifyUserScreen/';
  final bool isUserResettingPassword;
  final Function onContinue;
  final String phoneNumber;

  VerifyUserScreen(
      {this.isUserResettingPassword, this.onContinue, this.phoneNumber});

  @override
  _VerifyUserScreenState createState() => _VerifyUserScreenState();
}

class _VerifyUserScreenState extends State<VerifyUserScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool canRequestOTP = false;
  final timerMinutes = 2;
  final timerSeconds = 59;
  int minutesLeft;
  int secondsLeft;
  Timer timer;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void startTimer() {
    minutesLeft = timerMinutes;
    secondsLeft = timerSeconds;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          setState(() {
            secondsLeft -= 1;
            if (timer.tick % 60 == 0) {
              if (minutesLeft == 0) {
                timer.cancel();
                canRequestOTP = true;
              } else {
                minutesLeft -= 1;
                secondsLeft = 59;
              }
            }
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        dismissKeyboard(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: ZAKAppBar(),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ZAKTitle(
                      title: 'Verify your phone number',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child:
                          'An OTP has been sent to your phone number. Please enter the same to verify.'
                              .withStyle(
                        style: Theme.of(context).textTheme.bodyText1,
                        color: ZAKGrey,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(child: Container()),
                        Expanded(
                          flex: 2,
                          child: Form(
                              key: _formKey,
                              child: ZAKTextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) {
                                    setState(() {});
                                  },
                                  hintText: '',
                                  obscureText: false,
                                  isOTP: true,
                                  controller: _otpController)),
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: canRequestOTP
                          ? Center(
                              child: ZAKFlatButton(
                              title: 'Resend OTP',
                              onPressed: () async {
                                startTimer();
                                final authenticationVM =
                                    Provider.of<AuthenticationViewModel>(
                                        context,
                                        listen: false);
                                showCircularIndicator(context);
                                final response = await authenticationVM
                                    .sendOTP(widget.phoneNumber);
                                Navigator.of(context).pop();
                                if (response.didSucceed) {
                                  canRequestOTP = false;
                                  showSnackbar(_scaffoldKey,
                                      'OTP was successfully sent', () {});
                                } else {
                                  showSnackbar(
                                      _scaffoldKey,
                                      'Could not send OTP. Please try again',
                                      () {});
                                }
                              },
                            ))
                          : Center(
                              child: Text(
                              'You can request another OTP in ' +
                                  minutesLeft.toString().padLeft(2, '0') +
                                  ':' +
                                  secondsLeft.toString().padLeft(2, '0'),
                              style: TextStyle(color: ZAKGrey),
                            )),
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: ZAKButton(
                    onPressed: (_otpController.text.isEmpty ||
                            _otpController.text.length != 6)
                        ? null
                        : () {
                            if (widget.isUserResettingPassword) {
                              widget.onContinue(
                                  _otpController.text, _scaffoldKey);
                            } else {
                              widget.onContinue(
                                  _otpController.text, _scaffoldKey);
                            }
                          },
                    title: widget.isUserResettingPassword
                        ? 'Continue'
                        : 'Verify & Sign Up',
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
