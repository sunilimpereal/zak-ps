import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/my_adoptions.dart';
import 'package:zak_mobile_app/view/screens/my_donations.dart';
import 'package:zak_mobile_app/view/screens/my_tickets.dart';
import 'package:zak_mobile_app/view/widgets/segmented_control.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';

class MyActivitiesScreen extends StatefulWidget {
  static const routeName = 'MyActivitiesScreen/';
  @override
  _MyActivitiesScreenState createState() => _MyActivitiesScreenState();
}

class _MyActivitiesScreenState extends State<MyActivitiesScreen> {
  bool isLoading = true;
  int groupValue = 0;

  void _onSegmentSelected(int index) {
    setState(() {
      groupValue = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZAKAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: ZAKTitle(
                title: 'My Adoptions and Donations',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                child: SegmentedControl(
                  titles: ['Adoptions', 'Donation'],
                  groupValue: groupValue,
                  onSegmentSelected: (value) {
                    _onSegmentSelected(value);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: groupValue == 0
                  ? MyAdoptions()
                  : groupValue == 1
                      ? MyDonations()
                      : MyTickets(),
            )
          ],
        ),
      ),
    );
  }
}
