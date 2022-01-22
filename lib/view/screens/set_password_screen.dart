import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zak_mobile_app/constants.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/authentication_screen.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_text_field.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';

class SetPasswordScreen extends StatefulWidget {
  static const routeName = 'SetPasswordScreen';
  final String phoneNumber;
  final String otp;
  SetPasswordScreen({this.phoneNumber, this.otp});
  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: ZAKAppBar(),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ZAKTitle(title: 'Set password'),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: ZAKTextField(
                          onChanged: (_) {
                            setState(() {});
                          },
                          hintText: 'New password',
                          obscureText: true,
                          validator: (String text) {
                            if (text.length < 8) {
                              return 'The password should contain a minimum of 8 characters';
                            } else if (passwordRegExp.hasMatch(text)) {
                              return 'The password should contain uppercase, and lowercase letters, numbers, and at least one special characters';
                            }
                            return null;
                          },
                          controller: _passwordController),
                    ),
                  )
                ],
              ),
            )),
          ),
          Column(
            children: <Widget>[
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ZAKButton(
                  onPressed: (_passwordController.text.isEmpty ||
                          _passwordController.text.isEmpty)
                      ? null
                      : () async {
                          _formKey.currentState.validate();
                          if (_passwordController.text.isNotEmpty &&
                              !_passwordController.text
                                  .contains(passwordRegExp)) {
                            final authenticationVM =
                                Provider.of<AuthenticationViewModel>(context,
                                    listen: false);
                            showCircularIndicator(context);
                            final response =
                                await authenticationVM.forgotPassword(
                                    otp: widget.otp,
                                    phoneNumber: widget.phoneNumber,
                                    password: _passwordController.text);
                            Navigator.of(context).pop();
                            if (response.didSucceed) {
                              // ignore: unawaited_futures
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => AuthenticationScreen(true)));
                            } else {
                              showSnackbar(_scaffoldKey,
                                  response.responseMessage, () {});
                            }
                          }
                        },
                  title: 'Reset & Sign In',
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
