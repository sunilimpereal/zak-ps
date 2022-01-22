import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zak_mobile_app/constants.dart';

import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/set_password_screen.dart';
import 'package:zak_mobile_app/view/screens/verify_user_screen.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_text_field.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = 'ForgotPasswordScreen/';
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
                    ZAKTitle(title: 'Reset password'),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child:
                          'Enter and verify your phone number to reset your password.'
                              .withStyle(
                        style: Theme.of(context).textTheme.bodyText1,
                        color: ZAKGrey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Form(
                          key: _formKey,
                          child: ZAKTextField(
                              keyboardType: TextInputType.number,
                              hintText: 'Phone number',
                              obscureText: false,
                              isPhoneNumberField: true,
                              onChanged: (_) {
                                setState(() {});
                              },
                              controller: _phoneNumberController)),
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
                    onPressed: (_phoneNumberController.text.isEmpty)
                        ? null
                        : () async {
                            _formKey.currentState.validate();
                            if (_phoneNumberController.text.length == 10 &&
                                _phoneNumberController.text
                                    .contains(phoneNumberRegExp)) {
                              final authentication =
                                  Provider.of<AuthenticationViewModel>(context,
                                      listen: false);
                              showCircularIndicator(context);
                              final response = await authentication
                                  .sendOTP(_phoneNumberController.text);
                              Navigator.of(context).pop();
                              if (response.didSucceed) {
                                // ignore: unawaited_futures
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => VerifyUserScreen(
                                          isUserResettingPassword: true,
                                          phoneNumber: _phoneNumberController.text,
                                          onContinue: (String otp,
                                              GlobalKey scaffoldKey) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (_) {
                                              return SetPasswordScreen(
                                                phoneNumber:
                                                    _phoneNumberController.text,
                                                otp: otp,
                                              );
                                            }));
                                          },
                                        )));
                              } else {
                                showSnackbar(_scaffoldKey,
                                    response.responseMessage, () {});
                              }
                            }
                          },
                    title: 'Continue',
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
