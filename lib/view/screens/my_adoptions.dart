import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zak_mobile_app/models/adoption.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/widgets/empty_activity.dart';
import 'package:zak_mobile_app/view/widgets/zak_circular_indicator.dart';
import 'package:zak_mobile_app/view_models/adoption_view_model.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';

class MyAdoptions extends StatefulWidget {
  @override
  _MyAdoptionsState createState() => _MyAdoptionsState();
}

class _MyAdoptionsState extends State<MyAdoptions> {
  List<Adoption> adoptions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDonations();
  }

  void getDonations() async {
    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    final adoptionVM = AdoptionViewModel(accessToken);
    adoptions = await adoptionVM.getMyAdoptions();
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
        : adoptions.isEmpty
            ? Expanded(
                child: EmptyActivity(
                  imagePath: 'assets/images/GorillaImage.png',
                  secondaryText: 'You have not adopted any animals yet.',
                  primaryText: 'Hmm!',
                  alignment: ImageAlignment.Right,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: adoptions.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 16, left: 16, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            getFormattedDate(adoptions[index].dateOfAdoption) +
                                ', ' +
                                adoptions[index].zooName,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: adoptions[index].animals.length,
                              itemBuilder: (_, animalIndex) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            adoptions[index]
                                                .animals[animalIndex]
                                                .name,
                                            style: TextStyle(
                                                color: ZAKDarkGreen,
                                                fontSize: 15),
                                          ),
                                          Spacer(),
                                          Text(
                                            adoptions[index]
                                                    .animals[animalIndex]
                                                    .numberOfYears
                                                    .toString() +
                                                (adoptions[index]
                                                            .animals[
                                                                animalIndex]
                                                            .numberOfYears ==
                                                        1
                                                    ? ' year'
                                                    : ' years'),
                                            style: TextStyle(
                                                color: ZAKDarkGreen,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        )
                      ],
                    ),
                  );
                });
  }
}
