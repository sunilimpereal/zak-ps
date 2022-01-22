import 'package:flutter/material.dart';
import 'package:zak_mobile_app/models/zoo.dart';
import 'package:zak_mobile_app/view/screens/booking_screen.dart';
import 'package:zak_mobile_app/view/screens/vehiclebooking/select_vehicle.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view/widgets/zoo_overview_card.dart';

class TicketTypeSelectionScreen extends StatelessWidget {
  static const routeName = 'TicketTypeSelection';
  final Zoo zoo;
  TicketTypeSelectionScreen(this.zoo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ZAKTitle(
              title: zoo.name ?? '',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: ZooOverviewCard(
              subtitle: 'All the entrance tickets',
              buttonTitle: 'Book Now',
              title: 'Entrance Ticket',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BookingScreen(zoo: zoo),
                ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: ZooOverviewCard(
              buttonTitle: 'Book Now',
              subtitle: 'For touring the zoo in a battery operated vehicle',
              title: 'Safari Ticket',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SelectVehicle(zoo)
                        //VahicleBookingScreen(),
                        ));
              },
            ),
          )
        ],
      ),
    );
  }
}
