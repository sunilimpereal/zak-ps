import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/my_passes.dart';
import 'package:zak_mobile_app/view/screens/my_tickets.dart';
import 'package:zak_mobile_app/view/widgets/empty_activity.dart';
import 'package:zak_mobile_app/view/widgets/segmented_control.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/view_models/ticket_view_model.dart';

import 'home_screen.dart';

class MyTicketsAndPassesScreen extends StatefulWidget {
  static const routeName = 'MyTicketsAndPassesScreen';
  @override
  _MyTicketsAndPassesScreenState createState() =>
      _MyTicketsAndPassesScreenState();
}

class _MyTicketsAndPassesScreenState extends State<MyTicketsAndPassesScreen> {
  @override
  bool isLoading = true;
  int groupValue = 0;
  TicketViewModel ticketViewModel;

  void _onSegmentSelected(int index) {
    setState(() {
      groupValue = index;
    });
  }

  @override
  void initState() {
    final auth = Provider.of<AuthenticationViewModel>(context, listen: false);
    ticketViewModel = TicketViewModel(auth.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (ctx) => HomeScreen()));
        return await true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: ZAKTitle(
                  title: 'My Tickets and Passes',
                  // title: 'My Passes',
                ),
              ),
              // NOTE: Book tickets feature has been removed temporarily until it will be required
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  child: SegmentedControl(
                    titles: ['Tickets', 'Vehicle', 'Passes'],
                    groupValue: groupValue,
                    onSegmentSelected: (value) {
                      _onSegmentSelected(value);
                    },
                  ),
                ),
              ),
              groupValue == 0
                  ? FutureBuilder(
                      future: ticketViewModel.getMyTickets(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data.isEmpty) {
                          return EmptyActivity(
                            imagePath: 'assets/images/MeerkatManorImage.png',
                            secondaryText:
                                'Me too. Waiting eagerly to catch-up with you at zoo.',
                            primaryText: 'Missing me?',
                            alignment: ImageAlignment.Left,
                          );
                        } else {
                          return MyTickets(
                            tickets: snapshot.data,
                          );
                        }
                      })
                  : groupValue == 2
                      ? MyPasses()
                      : FutureBuilder(
                          future: ticketViewModel.getVehicleTickets(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.data.isEmpty) {
                              return EmptyActivity(
                                imagePath:
                                    'assets/images/MeerkatManorImage.png',
                                secondaryText:
                                    'Me too. Waiting eagerly to catch-up with you at zoo.',
                                primaryText: 'Missing me?',
                                alignment: ImageAlignment.Left,
                              );
                            } else {
                              return MyVehicleTickets(snapshot.data);
                            }
                          })
            ],
          ),
        ),
      ),
    );
  }
}
