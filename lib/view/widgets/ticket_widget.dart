import 'package:flutter/material.dart';
import 'package:zak_mobile_app/models/ticketrequest.dart';
import 'package:zak_mobile_app/models/vehicleBooking.dart/vehicle_response_model.dart';

import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/view/screens/user_ticket_screen.dart';

enum TicketStatus { CONSUMED, ACTIVE }

class TicketWidget extends StatelessWidget {
  final TicketRequestModel ticket;
  final String date;
  final String type;
  final String location;
  final String subcategory;
  const TicketWidget({
    Key key,
    this.date,
    this.type,
    this.ticket,
    this.subcategory,
    this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        // height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ZAKLightGrey,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleSubtitleText(
                            title: date,
                            subtitle: "Date" ?? "-",
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TitleSubtitleText(
                          //   title: type ?? "-",
                          //   subtitle: subcategory ?? "No. of Person",
                          // ),
                          TitleSubtitleText(
                            title:
                                ticket.isScanned ? 'Consumed' : 'Yet to visit',
                            subtitle: "Status",
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleSubtitleText(
                      title: location ?? "",
                      subtitle: "Visiting Zoo",
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      Positioned.fill(
        top: -15,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 30,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: Colors.white,
            ),
          ),
        ),
      ),
      Positioned.fill(
        bottom: -15,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 30,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: Colors.white,
            ),
          ),
        ),
      ),
    ]);
  }
}

class VehicleTicketWidget extends StatelessWidget {
  final VehicleResponseModel ticket;
  final String date;
  final String type;
  final String location;

  const VehicleTicketWidget({
    Key key,
    this.date,
    this.type,
    this.ticket,
    this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        // height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ZAKLightGrey,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleSubtitleText(
                            title: date,
                            subtitle: "Date" ?? "-",
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleSubtitleText(
                              title: ticket.startTime, subtitle: 'Time'),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleSubtitleText(
                      title: 'Vehicle' ?? "",
                      subtitle: ticket.vehicleName,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      Positioned.fill(
        top: -15,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 30,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: Colors.white,
            ),
          ),
        ),
      ),
      Positioned.fill(
        bottom: -15,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 30,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: Colors.white,
            ),
          ),
        ),
      ),
    ]);
  }
}
