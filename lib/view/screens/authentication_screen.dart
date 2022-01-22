import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zak_mobile_app/constants.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/forgot_password_screen.dart';
import 'package:zak_mobile_app/view/screens/home_screen.dart';
import 'package:zak_mobile_app/view/screens/verify_user_screen.dart';
import 'package:zak_mobile_app/view/widgets/zak_app_bar_with_logo.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_flat_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_text_field.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';

class AuthenticationScreen extends StatefulWidget {
  final bool isSignInScreen;

  AuthenticationScreen(this.isSignInScreen);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _signUpUser() {
    _formKey.currentState.validate();
    if (_phoneNumberController.text.isNotEmpty &&
        _phoneNumberController.text.length == 10 &&
        !_phoneNumberController.text.contains(RegExp(r'[A-Za-z]')) &&
        _phoneNumberController.text.contains(phoneNumberRegExp) &&
        _passwordController.text.isNotEmpty &&
        !_passwordController.text.contains(passwordRegExp)) {
      final authenticationVM =
          Provider.of<AuthenticationViewModel>(context, listen: false);
      showCircularIndicator(context);
      authenticationVM
          .signUpUser(
              phoneNumber: _phoneNumberController.text,
              password: _passwordController.text)
          .then((response) {
        Navigator.of(context).pop();
        if (response.didSucceed) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => VerifyUserScreen(
                    isUserResettingPassword: false,
                    onContinue: (String otp, GlobalKey scaffoldKey) async {
                      showCircularIndicator(context);
                      final response = await authenticationVM.verifyOTP(
                          phoneNumber: _phoneNumberController.text, otp: otp);
                      Navigator.of(context).pop();
                      if (response.didSucceed) {
                        // ignore: unawaited_futures
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.routeName, (route) => false);
                      } else {
                        showSnackbar(
                            scaffoldKey, response.responseMessage, () {});
                      }
                    },
                    phoneNumber: _phoneNumberController.text,
                  )));
        } else {
          showSnackbar(_scaffoldKey, response.responseMessage, () {});
        }
      });
    }
  }

  void checkSignInStatus(SignInConfirmed signInConfirmed) {
    if (!signInConfirmed.isSuccessful) {
      showSnackbar(_scaffoldKey, signInConfirmed.message, () {});
    } else {
      _goToHomeScreen();
    }
  }

  void _goToHomeScreen() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
  }

  void _signInUser() {
    _formKey.currentState.validate();
    if (_phoneNumberController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _phoneNumberController.text.length == 10 &&
        _phoneNumberController.text.contains(phoneNumberRegExp)) {
      showCircularIndicator(context);
      final authentication =
          Provider.of<AuthenticationViewModel>(context, listen: false);
      authentication
          .signInUser(
              password: _passwordController.text,
              phoneNumber: _phoneNumberController.text)
          .then((signInConfirmed) {
        Navigator.of(context).pop();
        if (signInConfirmed.isUserConfirmed != null) {
          if (!signInConfirmed.isUserConfirmed) {
            showSnackbar(_scaffoldKey, signInConfirmed.message, () async {
              showCircularIndicator(context);
              final result =
                  await authentication.sendOTP(_phoneNumberController.text);
              Navigator.of(context).pop();
              if (result.didSucceed) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => VerifyUserScreen(
                          isUserResettingPassword: false,
                          onContinue:
                              (String otp, GlobalKey scaffoldKey) async {
                            showCircularIndicator(context);
                            final response = await authentication.verifyOTP(
                                otp: otp,
                                phoneNumber: _phoneNumberController.text);
                            Navigator.of(context).pop();
                            if (response.didSucceed) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomeScreen.routeName, (route) => false);
                            } else {
                              showSnackbar(
                                  scaffoldKey, response.responseMessage, () {});
                            }
                          },
                          phoneNumber: _phoneNumberController.text,
                        )));
              }
            });
          } else {
            checkSignInStatus(signInConfirmed);
          }
        } else {
          checkSignInStatus(signInConfirmed);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 16.0;
    const verticalPadding = 32.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ZAKAppBarWithLogo(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding),
                    child: ZAKTitle(
                        title: widget.isSignInScreen
                            ? 'Sign in to ZAK'
                            : 'Sign up for ZAK'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          ZAKTextField(
                            hintText: 'Phone number',
                            obscureText: false,
                            isPhoneNumberField: true,
                            controller: _phoneNumberController,
                            onChanged: (_) {
                              setState(() {});
                            },
                            keyboardType: TextInputType.number,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24, bottom: 4),
                            child: ZAKTextField(
                              hintText: 'Password',
                              obscureText: true,
                              controller: _passwordController,
                              validator: widget.isSignInScreen
                                  ? null
                                  : (String text) {
                                      if (text.length < 8) {
                                        return 'The password should contain a minimum of 8 characters';
                                      } else if (passwordRegExp
                                          .hasMatch(text)) {
                                        return 'The password should contain uppercase, and lowercase letters, numbers, and at least one special characters';
                                      }
                                      return null;
                                    },
                              onChanged: (_) {
                                setState(() {});
                              },
                            ),
                          ),
                          widget.isSignInScreen
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: ZAKFlatButton(
                                    title: 'Forgot password?',
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          ForgotPasswordScreen.routeName);
                                    },
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
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
                  onPressed: (_passwordController.text.isEmpty ||
                          _phoneNumberController.text.isEmpty)
                      ? null
                      : widget.isSignInScreen
                          ? _signInUser
                          : _signUpUser,
                  title: widget.isSignInScreen ? 'Sign In' : 'Continue',
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
