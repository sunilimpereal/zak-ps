import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zak_mobile_app/models/adoption_group.dart';
import 'package:zak_mobile_app/models/zoo.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/animal_selection_screen.dart';
import 'package:zak_mobile_app/view/widgets/zak_circular_indicator.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view/widgets/zoo_overview_card.dart';
import 'package:zak_mobile_app/view_models/adotion_group_view_model.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/extensions/text.dart';

class AdoptionGroupsScreen extends StatefulWidget {
  static const routeName = 'AdoptionGroupsScreen/';

  final Zoo zoo;

  AdoptionGroupsScreen({this.zoo});

  @override
  _AdoptionGroupsScreenState createState() => _AdoptionGroupsScreenState();
}

class _AdoptionGroupsScreenState extends State<AdoptionGroupsScreen> {
  List<AdoptionGroup> _adoptionGroups = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var isLoading = true;

  void _getZooDetails() async {
    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    final adoptionGroupVM = AdoptionGroupViewModel(accessToken);
    _adoptionGroups = await adoptionGroupVM.getAdoptionGroups(widget.zoo.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getZooDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ZAKAppBarWithContactDetails(widget.zoo.contact, _scaffoldKey),
      body: isLoading
          ? Center(
              child: ZAKCircularIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ZAKTitle(
                      title: widget.zoo.name ?? '',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 24),
                      child:
                          'All donations & adoptions are exempted u/s. 80 of the IT Act 1961.'
                              .withStyle(
                                  style: subtitleTextStyle(FontWeight.normal),
                                  color: ZAKGrey),
                    ),
                    _adoptionGroups.isEmpty
                        ? Column(
                            children: <Widget>[
                              Center(child: Text('No groups to select from!')),
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _adoptionGroups.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ZooOverviewCard(
                                  buttonTitle: 'Select animals',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                AnimalSelectionScreen(
                                                  zoo: widget.zoo,
                                                  groups: _adoptionGroups,
                                                  selectedGroupID:
                                                      _adoptionGroups[index]
                                                          .adoptionGroupID,
                                                )));
                                  },
                                  title: _adoptionGroups[index].priceRange,
                                  benefits: _adoptionGroups[index].benefits,
                                ),
                              );
                            }),
                  ],
                ),
              ),
            ),
    );
  }
}
