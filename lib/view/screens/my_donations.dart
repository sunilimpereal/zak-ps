import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:zak_mobile_app/models/donation.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/widgets/empty_activity.dart';
import 'package:zak_mobile_app/view/widgets/zak_circular_indicator.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/view_models/donation_view_model.dart';

class MyDonations extends StatefulWidget {
  @override
  _MyDonationsState createState() => _MyDonationsState();
}

class _MyDonationsState extends State<MyDonations> {
  List<Donation> donations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDonations();
  }

  void getDonations() async {
    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    final donationVM = DonationViewModel(accessToken);
    donations = await donationVM.getMyDonations();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: ZAKCircularIndicator(),
          )
        : donations.isEmpty
            ? EmptyActivity(
                imagePath: 'assets/images/KingfisherImage.png',
                secondaryText: 'You have not donated to any zoo yet.',
                primaryText: 'Hmm!',
                alignment: ImageAlignment.Center,
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: donations.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                donations[index].zooName,
                                style: TextStyle(
                                    color: ZAKDarkGreen, fontSize: 15),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    getFormattedDate(
                                        donations[index].dateOfDontaion),
                                    style: TextStyle(
                                      color: ZAKGrey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  'INR ' +
                                      donations[index]
                                          .donationAmount
                                          .toString(),
                                  style: TextStyle(
                                    color: ZAKDarkGreen,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              );
  }
}
