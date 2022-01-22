import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/book_tickets_screen.dart';
import 'package:zak_mobile_app/view/screens/my_activities_screen.dart';
import 'package:zak_mobile_app/view/screens/my_tickets_and_passes_screen.dart';
import 'package:zak_mobile_app/view/screens/tickets_passes/ticket_type_selection.dart';
import 'package:zak_mobile_app/view/screens/zoos_screen.dart';
import 'package:zak_mobile_app/view/screens/getting_started_screen.dart';
import 'package:zak_mobile_app/view/widgets/zak_flat_button.dart';
import 'package:zak_mobile_app/view/widgets/zoo_option.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/extensions/text.dart';

import '../../constants.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'HomeScreen/';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    void _showSignOutConfirmationDialog() {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              content: Text(
                'Are you sure you want to logout from ZAK?',
                style: TextStyle(
                  color: ZAKDarkGreen,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel',
                        style: TextStyle(
                          color: ZAKGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ))),
                FlatButton(
                    onPressed: () {
                      final authenticationVM =
                          Provider.of<AuthenticationViewModel>(context,
                              listen: false);
                      authenticationVM.signOutUser();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          GettingStartedScreen.routeName, (route) => false);
                    },
                    child: Text('Logout',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: ZAKGreen,
                        ))),
              ],
            );
          });
    }

    void showEasterEgg() async {
      final packageInfo = await PackageInfo.fromPlatform();
      final versionNumber = packageInfo.version;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Spacer(),
              Dialog(
                insetPadding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        '© Zoo Authority of Karnataka'.withStyle(
                            style: subtitleTextStyle(FontWeight.w500),
                            color: ZAKDarkGreen),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 24),
                          child: ('v ' + versionNumber).withStyle(
                              style: TextStyle(fontSize: 12), color: ZAKGrey),
                        ),
                        'App designed and developed by'.withStyle(
                            style: TextStyle(fontSize: 12), color: ZAKGrey),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 16),
                          child: GestureDetector(
                              onTap: () async {
                                const url =
                                    'https://codemonk.in/?source=zak_mobile_app';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  showSnackbar(_scaffoldKey,
                                      'Could not open the webpage', () {});
                                }
                              },
                              child: Image.asset(
                                  'assets/images/CodemonkLogoHorizontal.png')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          );
        },
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 16),
                        child: GestureDetector(
                            onLongPress: () async {
                              showEasterEgg();
                            },
                            child: Image.asset('assets/images/ZAKLogo.png')),
                      ),
                      Spacer(),
                      IconButton(
                          icon: Image.asset('assets/images/TicketsIcon.png'),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(MyTicketsAndPassesScreen.routeName);
                          }),
                      IconButton(
                          icon: Image.asset('assets/images/GiftIcon.png'),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(MyActivitiesScreen.routeName);
                          }),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: IconButton(
                            icon: Image.asset('assets/images/LogoutIcon.png'),
                            onPressed: _showSignOutConfirmationDialog),
                      ),
                    ],
                  ),
                  // NOTE: Book tickets feature has been removed temporarily until it will be required
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                        'assets/images/BookTicketsBackgroundTop.png'),
                  ),
                  SizedBox(height: 153),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                          'assets/images/BookTicketsBackgroundBottom.png'),
                    ),
                  ),
                  SizedBox(height: 303),
                  Align(
                    alignment: Alignment.topRight,
                    child:
                        Image.asset('assets/images/DonationBackgroundTop.png'),
                  ),
                  SizedBox(height: 143),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                        'assets/images/DonationBackgroundBottom.png'),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 82),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        transform: Matrix4.translationValues(-34, 34, 0),
                        child: Image.asset('assets/images/DeerImage.png')),
                  ),
                  SizedBox(height: 173),
                  Container(
                    transform: Matrix4.translationValues(34, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset('assets/images/OtterImage.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: 180),
                  Container(
                    transform: Matrix4.translationValues(-34, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset('assets/images/GiraffeImage.png'),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 82),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16, left: 76, top: 132),
                    child: ZooOption(
                      body:
                          'Select your favourite zoo, book entrance and safari tickets hassle free!',
                      buttonTitle: 'Start Booking',
                      title: 'Book tickets',
                      titleAlignment: Alignment.topRight,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ZoosScreen(
                                screenType: ZooScreenType.TicketBooking)));
                        //  ZoosScreen(
                        //       screenType: ZooScreenType.TicketBooking,
                        //     )));
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 76, top: 156),
                    child: ZooOption(
                      body:
                          'Show your support and care for wild animals by adopting your favourite animal!',
                      buttonTitle: 'Start Adopting',
                      title: 'Adopt animals',
                      titleAlignment: Alignment.topLeft,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ZoosScreen(
                                  screenType: ZooScreenType.Adoption,
                                )));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 16, left: 76, top: 170, bottom: 40),
                    child: ZooOption(
                      body:
                          'Contribute towards the maintenance of the zoo and lessen the burden!',
                      buttonTitle: 'Start Donating',
                      title: 'Donate',
                      titleAlignment: Alignment.topRight,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ZoosScreen(
                                  screenType: ZooScreenType.Donation,
                                )));
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
