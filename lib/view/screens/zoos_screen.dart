import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zak_mobile_app/models/zoo.dart';

import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/booking_screen.dart';
import 'package:zak_mobile_app/view/screens/donation_details_screen.dart';
import 'package:zak_mobile_app/view/screens/tickets_passes/ticket_type_selection.dart';
import 'package:zak_mobile_app/view/screens/zoo_details_screen.dart';
import 'package:zak_mobile_app/view/widgets/zak_circular_indicator.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view/widgets/zoo_overview_card.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/view_models/zoo_view_model.dart';

import '../../constants.dart';

class ZoosScreen extends StatefulWidget {
  static const routeName = 'ZoosScreen/';
  final ZooScreenType screenType;

  ZoosScreen({@required this.screenType});

  @override
  _ZoosScreenState createState() => _ZoosScreenState();
}

class _ZoosScreenState extends State<ZoosScreen> {
  List<Zoo> _zoos = [];
  var isLoading = true;

  void _getZoos() async {
    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    final zooVM = ZooViewModel(accessToken);
    if (widget.screenType == ZooScreenType.TicketBooking) {
      _zoos = await zooVM.getZoosForTicketBooking();
    } else {
      _zoos = await zooVM.getZoos(
          toDonate: widget.screenType == ZooScreenType.Donation);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getZoos();
  }

  String getButtonTitleBasedOnScreenType() {
    String buttonTitle;
    switch (widget.screenType) {
      case ZooScreenType.Adoption:
        buttonTitle = 'Start Adopting';
        break;
      case ZooScreenType.Donation:
        buttonTitle = 'Start Donating';
        break;
      case ZooScreenType.TicketBooking:
        buttonTitle = 'Start Booking';
        break;
      default:
        buttonTitle = '';
        break;
    }
    return buttonTitle;
  }

  void onButtonPressed(Zoo zoo) {
    switch (widget.screenType) {
      case ZooScreenType.Adoption:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AdoptionGroupsScreen(
                  zoo: zoo,
                )));
        break;
      case ZooScreenType.Donation:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DonationDetailsScreen(
            zooID: zoo.id,
            zooName: zoo.name,
            zoo: zoo,
          ),
        ));
        break;
      case ZooScreenType.TicketBooking:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => TicketTypeSelectionScreen(zoo)));

        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZAKAppBar(),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: ZAKTitle(
                        title: 'Select Zoo',
                      ),
                    ),
                    _zoos.isEmpty
                        ? Column(
                            children: <Widget>[
                              Center(child: Text('No zoos to select from!')),
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _zoos.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ZooOverviewCard(
                                  subtitle: widget.screenType ==
                                          ZooScreenType.Adoption
                                      ? (_zoos[index]
                                              .numberOfSpecies
                                              .toString() +
                                          ' species to choose from')
                                      : '',
                                  buttonTitle:
                                      getButtonTitleBasedOnScreenType(),
                                  onPressed: () {
                                    onButtonPressed(_zoos[index]);
                                  },
                                  placeName: _zoos[index].city,
                                  title: _zoos[index].name,
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
