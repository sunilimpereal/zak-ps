import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zak_mobile_app/main.dart';
import 'package:zak_mobile_app/models/contact.dart';
import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/view/widgets/zak_back_button.dart';
import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';

void showCircularIndicator(BuildContext context) {
  dismissKeyboard(context);
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ZAKGreen),
          )));
}

void dismissKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

void showSnackbar(
    GlobalKey<ScaffoldState> scaffoldKey, String title, Function onClosed) {
  scaffoldKey.currentState
      .showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text(title),
        action: SnackBarAction(
          label: 'OK',
          textColor: ZAKGreen,
          onPressed: () {},
        ),
      ))
      .closed
      .then((_) {
    onClosed();
  });
}

Widget ZAKAppBar() {
  return AppBar(
    leading: Container(height: 50, child: ZAKBackButton()),
  );
}

Widget ZAKAppBarWithContactDetails(Contact contact, GlobalKey scaffoldKey) {
  return AppBar(
    leading: Container(height: 50, child: ZAKBackButton()),
    actions: <Widget>[
      IconButton(
          icon: Image.asset('assets/images/ConatctIcon.png'),
          onPressed: () {
            showContactDetailsCard(contact, scaffoldKey);
          })
    ],
  );
}

void showContactDetailsCard(Contact contact, GlobalKey scaffoldKey) {
  final context = navigatorKey.currentState.overlay.context;
  showDialog(
      context: context,
      builder: (context) => Column(
            children: <Widget>[
              Spacer(),
              Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                insetPadding: EdgeInsets.all(16),
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Spacer(),
                        Image.asset('assets/images/RightBackgroundPattern.png')
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: 'Zoo Contact Details'.withStyle(
                                style: TextStyle(fontSize: 20),
                                color: ZAKDarkGreen),
                          ),
                          contact.name == null
                              ? Container()
                              : contact.name.isEmpty
                                  ? Container()
                                  : contact.name.withStyle(
                                      style: subtitleTextStyle(FontWeight.w500),
                                      color: ZAKDarkGreen),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: contact.role.withStyle(
                                style: TextStyle(fontSize: 13), color: ZAKGrey),
                          ),
                          contact.email == null
                              ? Container()
                              : GestureDetector(
                                  onTap: () async {
                                    final _emailLaunchURI = Uri(
                                      scheme: 'mailto',
                                      path: contact.email,
                                    );
                                    if (await canLaunch(
                                        _emailLaunchURI.toString())) {
                                      launch(_emailLaunchURI.toString());
                                    } else {
                                      showSnackbar(
                                          scaffoldKey,
                                          'Something went wrong. Please try again later.',
                                          () {});
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      contact.email,
                                      style: TextStyle(
                                          color: ZAKGreen,
                                          decoration: TextDecoration.underline,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                          contact.phoneNumber == null
                              ? Container()
                              : GestureDetector(
                                  onTap: () async {
                                    final phoneNumber = contact.phoneNumber;
                                    final _phoneLauncherURI =
                                        'tel:' + phoneNumber;
                                    ;
                                    if (await canLaunch(_phoneLauncherURI)) {
                                      launch(_phoneLauncherURI);
                                    } else {
                                      showSnackbar(
                                          scaffoldKey,
                                          'Something went wrong. Please try again later.',
                                          () {});
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      contact.phoneNumber,
                                      style: TextStyle(
                                          color: ZAKGreen,
                                          decoration: TextDecoration.underline,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
            ],
          ));
}

TextStyle subtitleTextStyle(FontWeight fontWeight) {
  return TextStyle(
    fontSize: 15,
    letterSpacing: -0.23,
    fontWeight: fontWeight,
    height: 1.6,
  );
}

BoxDecoration getGradientDecoration() {
  return BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(26),
    boxShadow: [
      BoxShadow(
        color: ZAKGreen.withOpacity(0.5),
        blurRadius: 14,
        offset: Offset(0, 3),
      ),
    ],
  );
}

String getFormattedDate(DateTime date) {
  final formatter = DateFormat('dd MMMM yyyy');
  return (formatter.format(date));
}
