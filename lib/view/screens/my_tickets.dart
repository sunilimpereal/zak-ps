import 'package:flutter/material.dart';

import 'package:zak_mobile_app/models/ticketrequest.dart';
import 'package:zak_mobile_app/models/vehicleBooking.dart/vehicle_response_model.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/home_screen.dart';
import 'package:zak_mobile_app/view/screens/tickets_passes/ticket_details.dart';

import 'package:zak_mobile_app/view/widgets/ticket_widget.dart';
import 'package:zak_mobile_app/view_models/ticket_view_model.dart';

class MyTickets extends StatefulWidget {
  final List<TicketRequestModel> tickets;
  const MyTickets({
    Key key,
    this.tickets,
  }) : super(key: key);
  @override
  _MyTicketsState createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  TicketViewModel ticketViewModel;
  String getSubCategory(TicketRequestModel ticket) {
    String subcategory = "";
    for (int i = 0; i < ticket.lineItems.length; i++) {
      subcategory +=
          (' ${ticket.lineItems[i].quantity.toString()} ${ticket.lineItems[i].subCategoryName}');
      if (i != ticket.lineItems.length - 1) {
        subcategory += ",";
      }
    }
    return subcategory;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          widget.tickets.length,
          (index) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            TicketDetailsScreen(widget.tickets[index])));
                  },
                  child: TicketWidget(
                    ticket: widget.tickets[index],
                    date: widget.tickets[index].userDetails.dateOfVisit != null
                        ? getFormattedDate(DateTime.parse(
                            widget.tickets[index].userDetails.dateOfVisit))
                        : "-",
                    location: widget.tickets[index].organizationName ?? "-",
                    type: getSubCategory(widget.tickets[index]) ?? "-",
                    subcategory:
                        widget.tickets[index].lineItems[0].category.toString(),
                  ),
                ),
              )),
    );
  }
}

class MyVehicleTickets extends StatelessWidget {
  final List<VehicleResponseModel> tickets;
  const MyVehicleTickets(this.tickets);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          tickets.length,
          (index) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) =>
                    //         TicketDetailsScreen(tickets[index])));
                  },
                  child: VehicleTicketWidget(
                    ticket: tickets[index],
                    date: tickets[index].date,
                    // location: widget.tickets[index].organizationName ?? "-",
                    //   type: getSubCategory(widget.tickets[index]) ?? "-",
                    // subcategory:
                    //     widget.tickets[index].lineItems[0].category.toString(),
                  ),
                ),
              )),
    );
    ;
  }
}
